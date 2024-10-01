import 'package:flutter/material.dart';
import '../widgets/score_list.dart';
import 'game_screen.dart';
import '../services/score_service.dart';
import '../models/player.dart'; // Asegúrate de importar Player aquí

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ScoreService _scoreService = ScoreService();
  List<Player> topScores = []; // Cambiar a List<Player> en vez de List<String>

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  // Cargar los puntajes almacenados
  void _loadScores() async {
    List<Player> scores = await _scoreService
        .getTopPlayers(); // getTopPlayers devuelve List<Player>
    setState(() {
      topScores = scores;
    });
  }

  void _startGame() {
    String playerName = _nameController.text;
    if (playerName.isNotEmpty) {
      // Navegar a la pantalla del juego con el nombre del jugador
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GameScreen(playerName: playerName)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter your name:'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              child: Text('Play'),
            ),
            SizedBox(height: 40),
            Text(
              'Top 5 Scores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ScoreList(
                  players: topScores), // Ahora se pasa una lista de Player
            ),
          ],
        ),
      ),
    );
  }
}
