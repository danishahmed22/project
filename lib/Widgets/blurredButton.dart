import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary; // To differentiate between primary and secondary buttons

  const BlurredButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isPrimary ? Colors.blue.withOpacity(0.3) : Colors.white.withOpacity(0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextButton(
            onPressed: onPressed,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
