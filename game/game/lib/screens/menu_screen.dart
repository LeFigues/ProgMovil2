import 'package:flutter/material.dart';
import 'game_screen.dart'; // Asegúrate de que este archivo esté correctamente referenciado

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String playerName = "";
  List<Map<String, dynamic>> scores =
      []; // Lista para guardar los puntajes de los jugadores

  // Función para reiniciar el juego y volver al menú
  void _restartGame(String name, int score) {
    setState(() {
      scores.add(
          {'player': name, 'score': score}); // Agregar el puntaje a la lista
      playerName =
          ""; // Reinicia el nombre del jugador o ajusta según lo que necesites
    });
    Navigator.pop(context); // Volver al menú
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Nombre del Jugador"),
              onChanged: (value) {
                playerName = value; // Guarda el nombre del jugador
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (playerName.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(
                        playerName: playerName,
                        onRestart: (name, score) => _restartGame(
                            name, score), // Pasa la función al juego
                      ),
                    ),
                  );
                } else {
                  // Muestra un mensaje si el nombre está vacío
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor ingresa un nombre')),
                  );
                }
              },
              child: Text("Iniciar Juego"),
            ),
            SizedBox(height: 20),
            if (scores.isNotEmpty)
              Column(
                children: [
                  Text("Puntajes de Jugadores:"),
                  for (var score in scores)
                    Text("${score['player']}: ${score['score']} puntos"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
