import 'package:flutter/material.dart';
import '../Screens/chat_screen/chat_screen.dart';
import '../Screens/home_page.dart';
import '../Screens/profile.dart';

class CustomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Total height of the navbar and the floating icon
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // The container that holds the home and profile icons
          Container(
            width: 250,
            height: 60, // Height of the navigation bar
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.3), // Semi-transparent background
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home Icon
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Image.asset(
                    'lib/Assets/images/home_icon.png', // Home icon
                    width: 30,
                    height: 30,
                    color: Colors.white, // Adjust the color as needed
                  ),
                ),
                SizedBox(width: 100), // Spacer for the center circle
                // Profile Icon
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: Image.asset(
                    'lib/Assets/images/profileicon.png', // Profile icon
                    width: 30,
                    height: 30,
                    color: Colors.white, // Adjust the color as needed
                  ),
                ),
              ],
            ),
          ),
          // Center Circle Icon - Positioned above the navbar
          Positioned(
            bottom: -4, // This will raise the icon above the bar
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Image.asset(
                  'lib/Assets/images/cyrstalball.png', // Center circle icon
                  fit: BoxFit.contain,
                  height: 120,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
