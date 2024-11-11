import 'package:flutter/material.dart';
import 'dart:ui';
import '../Widgets/navigation_arrows.dart';
import '../provider/auth_service.dart';
import 'constants/background_video.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    // Check if the email field is empty
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }

    // Define the regex pattern for validating email addresses
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    // Validate the email against the regex pattern
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Invalid email address format.';
    }

    return null; // Return null if the email is valid
  }

  String? validatePassword(String? value) {
    // Check if the password field is empty
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }

    // Validate password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Validate presence of at least one uppercase letter
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Validate presence of at least one lowercase letter
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter.';
    }

    // Validate presence of at least one digit
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one number.';
    }

    // Validate presence of at least one special character
    if (!RegExp(r'(?=.*[\W_])').hasMatch(value)) {
      return 'Password must contain at least one special character.';
    }

    return null; // Return null if the password is valid
  }
  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required String? Function(String?) validator,
    Widget? suffixIcon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: suffixIcon,
            ),
            obscureText: obscureText,
            validator: validator,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return NavigationArrows(
      onForward: () => Navigator.pushNamed(context, '/welcome'), // Adjust as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundVideoWidget(),
            Container(
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pushNamed(context, '/welcome');
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeTransition(
                      opacity: AlwaysStoppedAnimation<double>(1.0),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    FadeTransition(
                      opacity: AlwaysStoppedAnimation<double>(1.0),
                      child: buildTextField(
                        controller: _emailController,
                        labelText: 'Email ID',
                        obscureText: false,
                        validator: validateEmail,
                      ),
                    ),
                    SizedBox(height: 24),
                    FadeTransition(
                      opacity: AlwaysStoppedAnimation<double>(1.0),
                      child: buildTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: !_passwordVisible,
                        validator: validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    FadeTransition(
                      opacity: AlwaysStoppedAnimation<double>(1.0),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF4285F4).withOpacity(1.0),
                                Color(0xFFFBCFD8).withOpacity(1.0),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                            child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.transparent,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await authService.signup(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  context: context,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    FadeTransition(
                      opacity: AlwaysStoppedAnimation<double>(1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4285F4).withOpacity(1.0),
                                    Color(0xFFDB4437).withOpacity(1.0),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google.png',
                                      height: 25,
                                      width: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Continue with Google',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors.transparent,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await authService.signupWithGoogle(context);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    FadeTransition(
                      opacity: AlwaysStoppedAnimation<double>(1.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Already a user? Login',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}