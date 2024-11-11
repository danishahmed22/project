import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;

  const BlurredTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
