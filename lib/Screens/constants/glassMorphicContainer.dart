import 'package:flutter/material.dart';
import 'dart:ui';

class GlassmorphicContainer extends StatelessWidget {
  final double blurX;
  final double blurY;
  final double opacity;
  final BorderRadius? borderRadius;
  final Widget child;

  const GlassmorphicContainer({
    Key? key,
    this.blurX = 10.0,
    this.blurY = 10.0,
    this.opacity = 0.2,
    this.borderRadius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(30),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  borderRadius: borderRadius ?? BorderRadius.circular(30),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
