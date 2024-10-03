import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GameScreen extends StatefulWidget {
  final String playerName;
  GameScreen({required this.playerName});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double accelerometerX = 0.0, accelerometerY = 0.0, accelerometerZ = 0.0;
  String position =
      ""; // Se usará solo para mostrar "Arriba", "Abajo", "Izquierda", "Derecha"
  bool isPlaying = false;
  List<String> instructions = ["Arriba", "Abajo", "Izquierda", "Derecha"];
  List<String> sequence = [];
  int currentIndex = 0;
  Color backgroundColor = Colors.white;
  String currentInstruction = "Presiona Start para comenzar";
  bool isShowingSequence = false;

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
      position = "Arriba";
    } else if (accelerometerZ <= -4) {
      position = "Abajo";
    } else if (accelerometerX >= 7) {
      position = "Izquierda";
    } else if (accelerometerX <= -7) {
      position = "Derecha";
    } else {
      position = ""; // No mostrar nada si no es un movimiento válido
    }

    // Validar movimiento cuando se esté jugando y no se esté mostrando la secuencia
    if (isPlaying && !isShowingSequence && position.isNotEmpty) {
      _validateMove();
    }
  }

  // Función para iniciar el juego
  void _startGame() {
    setState(() {
      sequence =
          _generateRandomSequence(3); // Genera una secuencia de 3 movimientos
      isPlaying = true;
      backgroundColor =
          Colors.black; // Cambia a fondo negro para mostrar la secuencia
      currentIndex = 0;
    });
    _playSequence();
  }

  // Genera una secuencia aleatoria de instrucciones
  List<String> _generateRandomSequence(int length) {
    return List.generate(
        length, (index) => instructions[index % instructions.length]);
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
    });
  }

  // Validar si el movimiento es correcto usando los valores de posición y texto de la secuencia
  void _validateMove() {
    if (position == sequence[currentIndex]) {
      setState(() {
        backgroundColor = Colors.green; // Movimiento correcto, fondo verde
        currentIndex++;
      });

      Future.delayed(Duration(milliseconds: 800), () {
        if (currentIndex == sequence.length) {
          _completeLevel();
        } else {
          setState(() {
            backgroundColor =
                Colors.white; // Preparado para el siguiente movimiento
          });
        }
      });
    }
  }

  // Completa el nivel actual
  void _completeLevel() {
    setState(() {
      backgroundColor = Colors.yellow;
      currentInstruction = "¡Nivel completado!";
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        backgroundColor = Colors.black;
        currentIndex = 0;
        sequence = _generateRandomSequence(
            sequence.length + 2); // Aumenta la longitud de la secuencia en 2
        _playSequence();
      });
    });
  }

  // Termina el juego
  void _endGame() {
    setState(() {
      backgroundColor = Colors.red;
      currentInstruction =
          "¡Juego terminado! Puntuación: ${sequence.length - 1}";
      isPlaying = false;
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
              // Mostrar la instrucción actual
              Text(
                'Instrucción: $currentInstruction',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              // Mostrar solo las posiciones válidas detectadas
              if (position.isNotEmpty)
                Text(
                  '$position',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              // Mostrar valores del acelerómetro para referencia
              Text(
                'X: ${accelerometerX.toStringAsFixed(2)}, Y: ${accelerometerY.toStringAsFixed(2)}, Z: ${accelerometerZ.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
