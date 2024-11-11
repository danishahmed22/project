import 'dart:ui';
import 'package:flutter/material.dart';
import '../../Widgets/back.dart';
import '../constants/background_video.dart';
import 'package:provider/provider.dart';
import '../../Widgets/navigation_arrows.dart';
import '../../provider/registration_provider.dart';
import '../constants/progressbar.dart';

class TimeOfBirthScreen extends StatefulWidget {
  const TimeOfBirthScreen({Key? key}) : super(key: key);

  @override
  State<TimeOfBirthScreen> createState() => _TimeOfBirthScreenState();
}

class _TimeOfBirthScreenState extends State<TimeOfBirthScreen> {
  late int selectedHour;
  late int selectedMinute;
  bool isSkip = false;

  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    selectedHour = now.hour;
    selectedMinute = now.minute;
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
            child: _buildNavigationButtons(),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomBackButton(),  // Custom back button
                  ],
                ),
                FormProgressIndicator(currentStep: 4, totalSteps: 6),
                const SizedBox(height: 100),
                const Text(
                  'Hold on!',
                  style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Can you assist me with your',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
                const Text(
                  'Time of Birth',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _buildTimePicker(),
                const SizedBox(height: 20),
                _buildSkipButton(), // Skip button
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Set width to 90% of the screen
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 300,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: _buildScrollWheel(
                    items: List.generate(24, (index) => index.toString().padLeft(2, '0')),
                    initialItem: selectedHour,
                    onChanged: (index) {
                      setState(() {
                        selectedHour = index;
                        isSkip = false;
                      });
                    },
                  ),
                ),
                const Text(":", style: TextStyle(fontSize: 26.0, height: 1.5, color: Colors.white)),
                Expanded(
                  child: _buildScrollWheel(
                    items: List.generate(60, (index) => index.toString().padLeft(2, '0')),
                    initialItem: selectedMinute,
                    onChanged: (index) {
                      setState(() {
                        selectedMinute = index;
                        isSkip = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollWheel({
    required List<String> items,
    required int initialItem,
    required Function(int) onChanged,
  }) {
    const unselectedTextStyle = TextStyle(fontSize: 18.0, color: Colors.white70);
    const selectedTextStyle = TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold);

    return ListWheelScrollView.useDelegate(
      controller: FixedExtentScrollController(initialItem: initialItem),
      itemExtent: 50,
      perspective: 0.005,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: items.length,
        builder: (context, index) {
          bool isSelected = index == initialItem;
          return Center(
            child: Text(
              items[index],
              style: isSelected ? selectedTextStyle : unselectedTextStyle,
            ),
          );
        },
      ),
      onSelectedItemChanged: onChanged,
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isSkip = true;
        });
        _validateAndNavigate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You skipped the time of birth")),
        );
      },
      child: const Text(
        "I'll skip this",
        style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline, decorationColor: Colors.white60),
      ),
    );
  }

  void _validateAndNavigate() {
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    if (isSkip) {
      registrationProvider.updateUserData(tob: null);
    } else {
      registrationProvider.updateUserData(tob: TimeOfDay(hour: selectedHour, minute: selectedMinute));
    }
    Navigator.pushNamed(context, '/location');
  }

  Widget _buildNavigationButtons() {
    return NavigationArrows(
      onBack: () => Navigator.pop(context),
      onForward: _validateAndNavigate,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
