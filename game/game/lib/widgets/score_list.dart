import 'package:flutter/material.dart';
import '../models/player.dart'; // Asegúrate de importar Player

class ScoreList extends StatelessWidget {
  final List<Player> players; // Ahora recibe una lista de Player

  ScoreList({required this.players});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${players[index].name}: ${players[index].score}'),
        );
      },
    );
  }
}
