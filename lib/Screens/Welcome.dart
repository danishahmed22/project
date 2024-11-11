import 'dart:ui';
import 'package:flutter/material.dart';
import 'constants/background_video.dart';

class Welcome extends StatefulWidget {
  Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late AnimationController _imageAnimationController;
  late AnimationController _buttonAnimationController;

  late Animation<Offset> _textAnimation;
  late Animation<Offset> _imageAnimation;
  late Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _textAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _imageAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _buttonAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    _imageAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut,
    ));

    _buttonAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    _textAnimationController.forward();
    _imageAnimationController.forward();
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _imageAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: welcome_backgroundColor,
      body: Stack(
        children: [
          const BackgroundVideoWidget(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          ),
                        );
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
                FadeTransition(
                  opacity: _buttonAnimationController,
                  child: SlideTransition(
                    position: _buttonAnimation,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF4285F4).withOpacity(1.0), // #4285F4 at 31%
                                  Color(0xFFFBCFD8).withOpacity(1.0), // #FBCFD8 at 100%
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: ElevatedButton(
                              child: Text('Login', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                elevation: 50,
                                backgroundColor: Colors.transparent,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/signin');
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 60, // Adjust this value to match your desired height
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30), // Half of the height for maximum curvature
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Stack(
                                children: [
                                  // Background blur effect
                                  Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Reduced blur for a 40% effect
                                      child: Container(
                                        color: Colors.white.withOpacity(0.1), // Slightly more opaque to mix blur and visibility
                                      ),
                                    ),
                                  ),
                                  // Semi-transparent overlay with gradient
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.2),
                                            Colors.white.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Centered text
                                  ElevatedButton(
                                    child: Text('Signup', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 50,
                                      backgroundColor: Colors.transparent,
                                      minimumSize: Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}