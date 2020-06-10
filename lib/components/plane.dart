import 'package:flutter/material.dart';

class Plane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 32.0 + 8,
      top: 32,
      child: RotatedBox(
        quarterTurns: 2,
        child: Icon(
          Icons.airplanemode_active,
          size: 64,
        ),
      ),
    );
  }
}