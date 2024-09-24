import 'package:flutter/material.dart';
import 'package:movement_alert/controllers/alarm_controller.dart';
import 'alarm_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AlarmController _alarmController = AlarmController();

  @override
  void dispose() {
    _alarmController.dispose();
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _alarmController.backgroundColor, // Cambiar fondo dinámicamente
      appBar: AppBar(
        title: Text('Alarma de Movimiento'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlarmView(
            isArmed: _alarmController.isArmed,
            alarmTriggered: _alarmController.alarmTriggered,
            onToggleAlarm: () => _alarmController.toggleAlarm(_updateUI),
            onDisarmAlarm: () => _alarmController.disarmAlarm(_updateUI),
          ),
          SizedBox(height: 40),
          Text(
            "Sensibilidad: ${_alarmController.sensitivityThreshold.toStringAsFixed(1)}",
            style: TextStyle(fontSize: 18),
          ),
          Slider(
            value: _alarmController.sensitivityThreshold,
            min: 1.0,
            max: 10.0,
            divisions: 18, // Divisiones del slider
            label: _alarmController.sensitivityThreshold.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _alarmController
                    .updateSensitivity(value); // Actualizar sensibilidad
              });
            },
          ),
        ],
      ),
    );
  }
}
