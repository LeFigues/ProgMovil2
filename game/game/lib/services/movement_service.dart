import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class MovementService {
  final StreamController<String> _movementController =
      StreamController<String>();

  // Escuchar los movimientos del acelerómetro
  void startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x > 2) {
        _movementController.add("left"); // Movimiento hacia la izquierda
      } else if (event.x < -2) {
        _movementController.add("right"); // Movimiento hacia la derecha
      } else if (event.y > 2) {
        _movementController.add("up"); // Movimiento hacia arriba
      } else if (event.y < -2) {
        _movementController.add("down"); // Movimiento hacia abajo
      }
    });
  }

  // Obtener los movimientos detectados como un Stream
  Stream<String> get movementStream => _movementController.stream;

  void dispose() {
    _movementController.close();
  }
}
