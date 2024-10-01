import 'package:flutter/material.dart';
import 'dart:async';
import '../services/movement_service.dart';

class GameScreen extends StatefulWidget {
  final String playerName;
  GameScreen({required this.playerName});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MovementService _movementService = MovementService();
  late StreamSubscription _movementSubscription;
  String currentDirection = "Waiting...";
  bool isCorrectMove = false;

  // Genera una dirección aleatoria para que el jugador realice el movimiento
  String generateRandomDirection() {
    List<String> directions = ["left", "right", "up", "down"];
    directions.shuffle();
    return directions.first;
  }

  void _startGame() {
    setState(() {
      currentDirection = generateRandomDirection();
      isCorrectMove = false;
    });
  }

  @override
  void initState() {
    super.initState();

    // Escuchar los movimientos detectados
    _movementService.startListening();
    _movementSubscription = _movementService.movementStream.listen((movement) {
      if (movement == currentDirection) {
        setState(() {
          isCorrectMove = true;
        });

        // Mostrar pantalla verde temporalmente y cambiar la dirección
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            isCorrectMove = false;
            currentDirection = generateRandomDirection();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _movementSubscription.cancel();
    _movementService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game On, ${widget.playerName}!')),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        color: isCorrectMove ? Colors.green : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Move the phone to the $currentDirection',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              child: Text('Start Next Move'),
            ),
          ],
        ),
      ),
    );
  }
}
