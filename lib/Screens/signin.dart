import 'package:flutter/material.dart';
import 'dart:ui';
import '../provider/auth_service.dart';
import 'constants/background_video.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _signInTextAnimation;
  late Animation<Offset> _textBoxAnimation;
  late Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _signInTextAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _textBoxAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _buttonAnimation = Tween<Offset>(begin: Offset(0, 5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter an email';
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~]+@"
        r"[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    return !RegExp(pattern).hasMatch(value) ? 'Invalid email address' : null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters long';
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) return 'Must contain an uppercase letter';
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) return 'Must contain a lowercase letter';
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) return 'Must contain a number';
    if (!RegExp(r'(?=.*[\W_])').hasMatch(value)) return 'Must contain a special character';
    return null;
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
            border: Border.all(color: Colors.transparent.withOpacity(0.1)),
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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundVideoWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 110.0),
                    child: Text(
                      'Futurist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 120),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SlideTransition(
                          position: _signInTextAnimation,
                          child: Text(
                            'おかえりなさい☆',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        SlideTransition(
                          position: _textBoxAnimation,
                          child: Column(
                            children: [
                              buildTextField(
                                controller: _emailController,
                                labelText: 'Email ID',
                                obscureText: false,
                                validator: _validateEmail,
                              ),
                              SizedBox(height: 16),
                              buildTextField(
                                controller: _passwordController,
                                labelText: 'Password',
                                obscureText: !_passwordVisible,
                                validator: _validatePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        SlideTransition(
                          position: _buttonAnimation,
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
                                child: Text('Sign In', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    await authService.signin(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context,
                                    );
                                    setState(() => _isLoading = false);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        Padding(
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
                                      SizedBox(width: 8),
                                      Text('Sign in with Google', style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  onPressed: () async {
                                    setState(() => _isLoading = true);
                                    await authService.signInWithGoogle(context);
                                    setState(() => _isLoading = false);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              'New user? Sign up here',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}