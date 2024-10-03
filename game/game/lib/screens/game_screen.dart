import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final String playerName;
  final Function(String, int)
      onRestart; // Callback para volver al menú inicial con puntaje
  GameScreen({required this.playerName, required this.onRestart});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double accelerometerX = 0.0, accelerometerY = 0.0, accelerometerZ = 0.0;
  String position =
      ""; // Solo usaremos las posiciones válidas: Arriba, Abajo, Izquierda, Derecha
  bool isPlaying = false;
  List<String> instructions = ["↑", "↓", "←", "→"];
  List<String> sequence = [];
  int currentIndex = 0;
  Color backgroundColor = Colors.white;
  String currentInstruction = "Presiona Start para comenzar";
  bool isShowingSequence = false;
  bool waitingForMove = false;
  bool showEndGameButton =
      false; // Nueva variable para controlar el botón al final
  bool showSequence = false; // Variable para mostrar la secuencia al final

  @override
  void initState() {
    super.initState();

    // Suscribirse al acelerómetro
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        accelerometerX = event.x;
        accelerometerY = event.y;
        accelerometerZ = event.z;

        // Detectar posición según los valores que mencionaste
        _detectPosition();
      });
    });
  }

  // Función para detectar la posición basada en los valores que mencionaste
  void _detectPosition() {
    if (accelerometerZ >= 8) {
      position = "↑";
    } else if (accelerometerZ <= -4) {
      position = "↓";
    } else if (accelerometerX >= 7) {
      position = "←";
    } else if (accelerometerX <= -7) {
      position = "→";
    } else {
      position =
          "Neutro"; // Consideramos que está en "Neutro" cuando no hay un movimiento válido
    }

    // Validar movimiento solo si el jugador está jugando y esperando para moverse
    if (isPlaying && waitingForMove && position != "Neutro") {
      _validateMove();
    }
  }

  // Función para iniciar el juego
  void _startGame() {
    setState(() {
      sequence =
          _generateRandomSequence(3); // Genera una secuencia inicial aleatoria
      isPlaying = true;
      backgroundColor =
          Colors.black; // Cambia a fondo negro para mostrar la secuencia
      currentIndex = 0;
      waitingForMove = false; // Asegurarse de no estar esperando al principio
      showEndGameButton = false; // Ocultar el botón al iniciar de nuevo
      showSequence = false; // Ocultar la secuencia al iniciar el juego
    });
    _playSequence();
  }

  // Genera una secuencia aleatoria de movimientos
  List<String> _generateRandomSequence(int length) {
    Random random = Random();
    return List.generate(
        length, (index) => instructions[random.nextInt(instructions.length)]);
  }

  // Función que maneja la visualización de la secuencia
  void _playSequence() async {
    setState(() {
      isShowingSequence = true;
    });

    for (String instruction in sequence) {
      setState(() {
        currentInstruction = instruction;
      });
      await Future.delayed(
          Duration(milliseconds: 800)); // Mostrar la instrucción por 0.8s

      setState(() {
        currentInstruction = ""; // Pausa de 0.2s sin texto
      });
      await Future.delayed(Duration(milliseconds: 200));
    }

    setState(() {
      currentInstruction = "";
      backgroundColor = Colors
          .white; // Cambia el fondo a blanco una vez mostrada la secuencia
      isShowingSequence = false;
      waitingForMove = true; // Ahora el jugador puede realizar movimientos
    });
  }

  // Validar si el movimiento es correcto usando los valores de posición y texto de la secuencia
  void _validateMove() {
    if (position == sequence[currentIndex]) {
      setState(() {
        backgroundColor = Colors.green; // Movimiento correcto, fondo verde
        currentIndex++;
        waitingForMove =
            false; // Desactivar la espera mientras se evalúa el siguiente paso
      });

      Future.delayed(Duration(milliseconds: 800), () {
        if (currentIndex == sequence.length) {
          _completeLevel();
        } else {
          setState(() {
            backgroundColor =
                Colors.white; // Preparado para el siguiente movimiento
            waitingForMove = true; // Volver a esperar el próximo movimiento
          });
        }
      });
    } else {
      _endGame(); // Si el movimiento es incorrecto, termina el juego
    }
  }

  // Completa el nivel actual y genera una secuencia aleatoria más larga
  void _completeLevel() {
    setState(() {
      backgroundColor = Colors.yellow;
      currentInstruction = "¡Nivel completado!";
      waitingForMove =
          false; // Dejar de esperar mientras se muestra el mensaje de nivel completado
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        backgroundColor = Colors.black;
        currentIndex = 0;
        sequence.addAll(
            _generateRandomSequence(2)); // Agrega 2 pasos más aleatorios
        _playSequence();
      });
    });
  }

  // Termina el juego, muestra pantalla roja durante 2.5s y luego muestra el botón de volver al menú
  void _endGame() {
    setState(() {
      backgroundColor = Colors.red;
      currentInstruction = "¡Perdiste! Puntuación: ${sequence.length - 1}";
      isPlaying = false;
      waitingForMove = false;
      showEndGameButton = false; // Inicialmente, no mostrar el botón
      showSequence = true; // Mostrar la secuencia al final del juego
    });

    // Mostrar la pantalla de "Perdiste" por 2.5 segundos antes de mostrar el botón
    Future.delayed(Duration(seconds: 2, milliseconds: 500), () {
      setState(() {
        showEndGameButton =
            true; // Ahora se puede mostrar el botón para regresar al menú
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Juega, ${widget.playerName}!'),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isPlaying)
                ElevatedButton(
                  onPressed: _startGame,
                  child: Text("Start"),
                ),
              // Mostrar la instrucción actual centrada
              Text(
                ' $currentInstruction',
                style: TextStyle(
                    fontSize: 50, // Aumentar el tamaño del texto
                    color: backgroundColor == Colors.yellow
                        ? Colors.black
                        : Colors
                            .white), // Cambiar el color a negro cuando el fondo es amarillo
                textAlign: TextAlign.center, // Centrar el texto
              ),
              // Mostrar solo las posiciones válidas detectadas, omitiendo Neutro
              if (position != "Neutro" && position.isNotEmpty)
                Text(
                  '$position',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              // Mostrar la secuencia en la parte inferior cuando termina el juego
              if (showSequence)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Secuencia: ${sequence.join(', ')}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Botón para regresar al menú una vez que el juego ha terminado, tras 2.5 segundos
              if (showEndGameButton)
                ElevatedButton(
                  onPressed: () {
                    widget.onRestart(
                        widget.playerName,
                        sequence.length -
                            1); // Llamar a la función para volver al menú con puntaje
                  },
                  child: Text("Volver al menú"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
