import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/back.dart';
import '../../provider/database.dart';
import '../../widgets/navigation_arrows.dart';
import '../../provider/registration_provider.dart';
import '../constants/background_video.dart';
import '../constants/progressbar.dart';
import 'gender_selection.dart';
import 'name_email_password_screen.dart';
import 'dob_screen.dart';
import 'time_picker_screen.dart';
import 'location_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registrationProvider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideoWidget(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomBackButton(),
                    ],
                  ),
                  FormProgressIndicator(currentStep: 6, totalSteps: 6),
                  SizedBox(height: 40),
                  Text(
                    'Confirm Your Details',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildEditableField(
                          context,
                          label: 'Name',
                          value: registrationProvider.user.name ?? 'Not provided',
                          onEdit: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NameEmailPasswordScreen())),
                        ),
                        _buildEditableField(
                          context,
                          label: 'Email',
                          value: registrationProvider.user.email ?? 'Not provided',
                          onEdit: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NameEmailPasswordScreen())),
                        ),
                        _buildEditableField(
                          context,
                          label: 'Password',
                          value: registrationProvider.user.password != null ? '*' * registrationProvider.user.password!.length : 'Not provided',
                          onEdit: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NameEmailPasswordScreen())),
                        ),
                        _buildEditableField(
                          context,
                          label: 'Gender',
                          value: registrationProvider.user.gender ?? 'Not provided',
                          onEdit: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GenderSelectionScreen())),
                        ),
                        _buildEditableField(
                          context,
                          label: 'Date of Birth',
                          value: registrationProvider.user.dob != null ? "${registrationProvider.user.dob!.toLocal()}".split(' ')[0] : 'Not provided',
                          onEdit: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DateOfBirthScreen())),
                        ),
                        _buildEditableField(
                          context,
                          label: 'Time of Birth',
                          value: registrationProvider.user.tob != null ? "${registrationProvider.user.tob!.format(context)}" : 'Not provided',
                          onEdit: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TimeOfBirthScreen())),
                        ),
                        _buildEditableField(
                          context,
                          label: 'City',
                          value: registrationProvider.user.city ?? 'Not provided',
                          onEdit: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LocationScreen())),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
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
                        child: Text('Save and Continue', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Colors.transparent,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          await saveUserDetails(context, registrationProvider);
                          Navigator.pushReplacementNamed(context, '/home');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Details saved successfully!')),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveUserDetails(BuildContext context, RegistrationProvider provider) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Capture the user's details in a map
      Map<String, dynamic> userDetails = {
        'name': provider.user.name ?? 'Not provided',
        'email': provider.user.email ?? user.email,
        'gender': provider.user.gender ?? 'Not provided',
        'dob': provider.user.dob?.toIso8601String(),
        'tob': provider.user.tob != null ? provider.user.tob!.format(context) : 'Not provided',
        'city': provider.user.city ?? 'Not provided',
        'updatedAt': Timestamp.now(),
      };

      // Log each field to confirm data presence
      print("Saving user details to Firestore:");
      userDetails.forEach((key, value) {
        print("$key: $value");
      });

      try {
        // Attempt to add/update user data in Firestore
        await DatabaseMethods().addUser(user.uid, userDetails);
        print("Data successfully stored in Firestore for user: ${user.uid}");
      } catch (e) {
        print("Error saving user details in Firestore: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save details: $e')),
        );
      }
    } else {
      print("User not authenticated. Unable to save details.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not authenticated')),
      );
    }
  }

  Widget _buildEditableField(BuildContext context, {required String label, required String value, required VoidCallback onEdit}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
