import 'package:flutter/material.dart';

class SlideButton extends StatelessWidget {
  final bool isArmed;
  final Function onSlide;

  SlideButton({required this.isArmed, required this.onSlide});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(isArmed ? 'Desactivado' : 'Activado'),
        Switch(
          value: isArmed,
          onChanged: (value) => onSlide(),
        ),
      ],
    );
  }
}
