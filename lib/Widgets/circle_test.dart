import 'dart:ui';
import 'package:flutter/material.dart';

import '../Screens/constants/background_video.dart';

class DynamicCirclesUI extends StatefulWidget {
  @override
  State<DynamicCirclesUI> createState() => _DynamicCirclesUIState();
}

class _DynamicCirclesUIState extends State<DynamicCirclesUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideoWidget(),
          // Circle widgets
          Positioned(
            left: 20,
            top: 116,
            child: DynamicCircle(
              size: 200,
              text: '1', // Earth
            ),
          ),
          Positioned(
            right: 20,
            top: 85,
            child: DynamicCircle(
              size: 160,
              text: '2', // Water
            ),
          ),
          Positioned(
            left: 30,
            top: 320,
            child: DynamicCircle(
              size: 100,
              text: '3', // Fire
            ),
          ),
          Positioned(
            right: 20,
            top: 250,
            child: DynamicCircle(
              size: 180,
              text: '4', // Metal
            ),
          ),
          Positioned(
            left: 130,
            top: 390,
            child: DynamicCircle(
              size: 90,
              text: '5', // Wood
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicCircle extends StatelessWidget {
  final double size;
  final String text;

  const DynamicCircle({
    Key? key,
    required this.size,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: size / 3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
