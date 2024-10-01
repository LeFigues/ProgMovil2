import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final String playerName;
  GameScreen({required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game On, $playerName!')),
      body: Center(
        child: Text(
          'Let\'s Play!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
