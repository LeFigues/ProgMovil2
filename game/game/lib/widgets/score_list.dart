import 'package:flutter/material.dart';

class ScoreList extends StatelessWidget {
  final List<String> topScores = [
    'Player1: 10',
    'Player2: 9',
    'Player3: 8',
    'Player4: 7',
    'Player5: 6'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topScores.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(topScores[index]),
        );
      },
    );
  }
}
