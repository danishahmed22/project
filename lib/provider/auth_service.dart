import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to monitor authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Method to sign up with email and password
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'createdAt': Timestamp.now(),
        // Add any other user data you want to save
      });

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  // Method to sign in with email and password
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        // User is signed in successfully
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle case where user is not found
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  // Method to sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        // Store additional user information in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'createdAt': Timestamp.now(),
          // Additional user data
        }, SetOptions(merge: true));

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle case where user is not found
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-In Error: ${e.toString()}')));
    }
  }

  // Method to sign up with Google
  Future<void> signupWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        // Store user data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'createdAt': Timestamp.now(),
          // Additional user data
        }, SetOptions(merge: true));

        Navigator.pushReplacementNamed(context, '/name');
      } else {
        // Handle case where user is not found
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-Up Error: ${e.toString()}')));
    }
  }

  // Method to sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
