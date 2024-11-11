import 'package:flutter/material.dart';
import '../constants/background_video.dart';
import 'package:provider/provider.dart';
import '../../widgets/navigation_arrows.dart';
import '../../provider/registration_provider.dart';
import '../constants/glassMorphicContainer.dart';
import '../constants/progressbar.dart';

class NameEmailPasswordScreen extends StatefulWidget {
  @override
  _NameEmailPasswordScreenState createState() => _NameEmailPasswordScreenState();
}

class _NameEmailPasswordScreenState extends State<NameEmailPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    _nameController = TextEditingController(text: registrationProvider.user.name ?? '');
    _emailController = TextEditingController(text: registrationProvider.user.email ?? '');
    _passwordController = TextEditingController(text: registrationProvider.user.password ?? '');
    _confirmPasswordController = TextEditingController(text: registrationProvider.user.password ?? '');
  }

  void _validateAndNavigate() {
    if (_formKey.currentState!.validate()) {
      Provider.of<RegistrationProvider>(context, listen: false).updateUserData(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushNamed(context, '/gender');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideoWidget(),
          Positioned(
            bottom: 0,
            right: 0,
            child: NavigationArrows(
              onForward: _validateAndNavigate,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormProgressIndicator(currentStep: 1, totalSteps: 6),
                    SizedBox(height: 80),
                    Center(
                      child: Text(
                        'Register yourself',
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Welcome! Let's create your account.",
                        style: TextStyle(fontSize: 20, color: Colors.white70),
                      ),
                    ),
                    SizedBox(height: 40),
                    GlassmorphicContainer(
                      borderRadius: BorderRadius.circular(30),
                      child: TextFormField(
                        onChanged: (value) {
                          context.read<RegistrationProvider>().updateUserName(value);
                        },
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelText: 'Name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GlassmorphicContainer(
                      borderRadius: BorderRadius.circular(30),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelText: 'Email',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GlassmorphicContainer(
                      borderRadius: BorderRadius.circular(30),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelText: 'Password',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GlassmorphicContainer(
                      borderRadius: BorderRadius.circular(30),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelText: 'Confirm Password',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible = !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_confirmPasswordVisible,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

