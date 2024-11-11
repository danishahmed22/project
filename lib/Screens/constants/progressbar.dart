import 'package:flutter/material.dart';

class FormProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const FormProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: currentStep / totalSteps,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ],
    );
  }
}
