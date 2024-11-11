import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:futurist_project/provider/auth_service.dart';
import 'package:provider/provider.dart';
import 'Screens/signin.dart';
import 'Screens/signup_validate.dart';
import 'Screens/home_page.dart';
import 'Screens/profile.dart';
import 'Screens/chat_screen/chat_screen.dart';
import 'Screens/Welcome.dart';
import 'Screens/Registration_module/name_email_password_screen.dart';
import 'Screens/Registration_module/gender_selection.dart';
import 'Screens/Registration_module/dob_screen.dart';
import 'Screens/Registration_module/time_picker_screen.dart';
import 'Screens/Registration_module/location_screen.dart';
import 'Screens/Registration_module/confirmation_screen.dart';
import 'Screens/splashscreen.dart';
import 'provider/registration_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

const gemini_api_key = 'AIzaSyBM54HOZd4s9DdZgYLphTL9Baufl9_uNV0';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: gemini_api_key);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MyApp(),
    ),
  );
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: context.read<AuthService>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return Welcome(); // Show Welcome screen for unauthenticated users
          }
          return HomeScreen(); // Show HomeScreen for authenticated users
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: SplashScreen(),
      routes: {
        '/welcome': (context) => Welcome(),
        '/signup': (context) => SignUpScreen(),
        '/signin': (context) => SignInScreen(),
        '/name': (context) => NameEmailPasswordScreen(),
        '/gender': (context) => GenderSelectionScreen(),
        '/dob': (context) => DateOfBirthScreen(),
        '/tob': (context) => TimeOfBirthScreen(),
        '/location': (context) => LocationScreen(),
        '/confirm': (context) => ConfirmationScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/gpt': (context) => ChatScreen(),
      },
    );
  }
}
