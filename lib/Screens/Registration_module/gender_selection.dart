import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/back.dart';
import '../../Widgets/navigation_arrows.dart';
import '../../provider/registration_provider.dart';
import '../constants/background_video.dart';
import '../constants/progressbar.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;
  bool isSkip = false;

  @override
  Widget build(BuildContext context) {
    // Retrieve the userName within the build method
    final userName = Provider.of<RegistrationProvider>(context).user.name ?? 'User';

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideoWidget(),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildNavigationButtons(),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomBackButton(),
                  ],
                ),
                FormProgressIndicator(currentStep: 2, totalSteps: 6),
                const SizedBox(height: 100),
                Text(
                  'Hi $userName',
                  style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text(
                  'I hope you are doing great!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
                const Text(
                  'Can you assist me with your',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
                const Text(
                  'Gender',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _buildGenderSelection(),
                const SizedBox(height: 20),
                _buildSkipButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderOption('Male', Icons.male),
        const SizedBox(width: 20),
        _buildGenderOption('Female', Icons.female),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
          isSkip = false;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 50,
              color: isSelected ? Colors.white : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            isSkip = !isSkip;
            selectedGender = null;
          });
        },
        child: Text(
          "I do not wish to disclose",
          style: TextStyle(
            color: isSkip ? Colors.white : Colors.grey,
            decoration: TextDecoration.underline,
            decorationColor: isSkip ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  void _validateAndNavigate() {
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    registrationProvider.updateUserData(gender: selectedGender);
    Navigator.pushNamed(context, '/dob'); // Replace with your next screen route
  }

  Widget _buildNavigationButtons() {
    return NavigationArrows(
      onForward: _validateAndNavigate,
    );
  }
}
