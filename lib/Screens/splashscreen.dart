import 'dart:ui';
import 'package:flutter/material.dart';

import '../provider/auth_service.dart';
import 'constants/background_video.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late Animation<Offset> _imageAnimation;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();

    _imageAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _imageAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut,
    ));

    _imageAnimationController.forward();

    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    AuthService authService = AuthService();

    authService.authStateChanges.listen((user) async {
      await Future.delayed(Duration(seconds: 5));

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
      setState(() {
        _isChecking = false;
      });
    });
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideoWidget(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _imageAnimationController,
                      builder: (context, child) {
                        return FadeTransition(
                            opacity: _imageAnimationController,
                            child: SlideTransition(
                              position: _imageAnimation,
                              child: child,
                            ));
                      },
                      child: Center(
                        child: Image.asset(
                          'lib/Assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isChecking) ...[
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    'Checking authentication...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}