import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart'; // Importa la clase Player

class ScoreService {
  static const String _scoreKey = 'topScores';

  // Guardar un nuevo puntaje si está entre los mejores
  Future<void> savePlayer(Player player) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> topScores = prefs.getStringList(_scoreKey) ?? [];

    // Agregar el nuevo puntaje a la lista
    topScores.add(player.toStorageString());

    // Ordenar la lista de mayor a menor
    topScores.sort((a, b) {
      int scoreA = int.parse(a.split(': ')[1]);
      int scoreB = int.parse(b.split(': ')[1]);
      return scoreB.compareTo(scoreA); // Orden descendente
    });

    // Guardar solo los 5 mejores puntajes
    if (topScores.length > 5) {
      topScores = topScores.sublist(0, 5);
    }

    await prefs.setStringList(_scoreKey, topScores);
  }

  // Obtener la lista de los mejores puntajes como Player
  Future<List<Player>> getTopPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> topScores = prefs.getStringList(_scoreKey) ?? [];

    return topScores
        .map((scoreString) => Player.fromStorageString(scoreString))
        .toList();
  }

  // Limpiar todos los puntajes (para pruebas o reiniciar el juego)
  Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoreKey);
  }
}
