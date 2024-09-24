import 'package:flutter/material.dart';
import 'package:movement_alert/widgets/slide_button.dart';

class AlarmView extends StatelessWidget {
  final bool isArmed;
  final bool alarmTriggered;
  final VoidCallback onToggleAlarm;
  final VoidCallback onDisarmAlarm;

  AlarmView({
    required this.isArmed,
    required this.alarmTriggered,
    required this.onToggleAlarm,
    required this.onDisarmAlarm,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (alarmTriggered)
            Text(
              'MOVIMIENTO DETECTADO',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          SizedBox(height: 20),
          SlideButton(
            isArmed: isArmed,
            onSlide: onToggleAlarm,
          ),
          if (alarmTriggered)
            Column(
              children: [
                SizedBox(height: 20),
                Text(
                  '¡Alarma Activada!',
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: onDisarmAlarm,
                  child: Text('Desactivar Alarma'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
