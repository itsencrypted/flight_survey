import 'package:flutter/material.dart';

class StepQuestion extends StatelessWidget {
  final String question;

  const StepQuestion({Key key, @required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 64, right: 16),
      child: Text(
        question,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

