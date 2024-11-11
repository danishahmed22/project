// lib/widgets/navigation_arrows.dart
import 'package:flutter/material.dart';

class NavigationArrows extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onForward;

  const NavigationArrows({Key? key, this.onBack, this.onForward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildArrowButton(Icons.check, onForward),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback? onPressed) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onPressed,
            child: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}