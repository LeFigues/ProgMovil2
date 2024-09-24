import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AlarmController {
  bool isArmed = false;
  bool alarmTriggered = false;
  StreamSubscription? _accelerometerSubscription;
  Color backgroundColor = Colors.green; // Color inicial del fondo
  double sensitivityThreshold =
      5.0; // Ajustamos la sensibilidad para menos sensibilidad
  double noiseThreshold =
      0.1; // Ajustamos el umbral de ruido para ignorar más variaciones pequeñas
  int stableReadings = 0; // Contador de lecturas estables sin movimiento
  int stableReadingLimit =
      10; // Cantidad de lecturas estables antes de considerar que no hay movimiento
  int bufferLimit = 10; // Número de lecturas a promediar
  List<AccelerometerEvent> eventBuffer = []; // Buffer para almacenar lecturas
  late Timer _timer;

  void toggleAlarm(Function updateUI) {
    if (isArmed) {
      _stopDetection();
    } else {
      _startDetection(updateUI);
    }
    isArmed = !isArmed;
    updateUI();
  }

  void _startDetection(Function updateUI) {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      eventBuffer.add(event);

      if (eventBuffer.length >= bufferLimit) {
        // Calculamos el promedio del buffer
        AccelerometerEvent averagedEvent = _averageBuffer();
        eventBuffer.clear(); // Limpiar el buffer después de promediar

        // Filtrar el ruido del acelerómetro
        if (_isStable(averagedEvent)) {
          stableReadings++;
          if (stableReadings > stableReadingLimit && alarmTriggered) {
            disarmAlarm(
                updateUI); // Si el celular está quieto por un tiempo, desactivar la alarma
          }
        } else {
          stableReadings = 0; // Reiniciar si hay movimiento
          if (!alarmTriggered && _isSignificantMovement(averagedEvent)) {
            _triggerAlarm(updateUI);
          }
        }
      }
    });
  }

  // Promediar las lecturas del acelerómetro en el buffer
  AccelerometerEvent _averageBuffer() {
    double avgX = 0.0, avgY = 0.0, avgZ = 0.0;
    for (var event in eventBuffer) {
      avgX += event.x;
      avgY += event.y;
      avgZ += event.z;
    }
    DateTime timestamp = DateTime.now(); // Usamos DateTime como el timestamp
    return AccelerometerEvent(
      avgX / eventBuffer.length,
      avgY / eventBuffer.length,
      avgZ / eventBuffer.length,
      timestamp, // El cuarto argumento es ahora un DateTime
    );
  }

  bool _isSignificantMovement(AccelerometerEvent event) {
    return event.x.abs() > sensitivityThreshold ||
        event.y.abs() > sensitivityThreshold ||
        event.z.abs() > sensitivityThreshold;
  }

  bool _isStable(AccelerometerEvent event) {
    return event.x.abs() < noiseThreshold &&
        event.y.abs() < noiseThreshold &&
        event.z.abs() < noiseThreshold;
  }

  void _triggerAlarm(Function updateUI) {
    alarmTriggered = true;
    updateUI();

    // Cambiar el fondo repetidamente
    HapticFeedback.heavyImpact();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      backgroundColor =
          backgroundColor == Colors.green ? Colors.white : Colors.green;
      updateUI();
    });
  }

  void disarmAlarm(Function updateUI) {
    alarmTriggered = false;
    _timer.cancel(); // Detener el cambio de fondo
    backgroundColor = Colors.green; // Reiniciar color de fondo
    updateUI();
  }

  void updateSensitivity(double newSensitivity) {
    sensitivityThreshold = newSensitivity;
  }

  void _stopDetection() {
    _accelerometerSubscription?.cancel();
  }

  void dispose() {
    _accelerometerSubscription?.cancel();
    _timer.cancel();
  }
}
