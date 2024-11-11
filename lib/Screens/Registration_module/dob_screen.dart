import 'dart:ui';

import 'package:flutter/material.dart';
import '../../Widgets/back.dart';
import '../constants/background_video.dart';
import 'package:provider/provider.dart';
import '../../Widgets/navigation_arrows.dart';
import '../../provider/registration_provider.dart';
import '../constants/progressbar.dart';

class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({Key? key}) : super(key: key);

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;
  bool isSkip = false;

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDay = now.day;
    selectedMonth = now.month;
    selectedYear = now.year;
  }

  int _daysInMonth(int year, int month) {
    if (month == 2) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
        return 29;
      }
      return 28;
    }
    const daysInMonth = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month - 1];
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
                    CustomBackButton(),  // Add the custom back button here
                  ],
                ),
                FormProgressIndicator(currentStep: 3, totalSteps: 6),
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
                  'Birth Date',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _buildDatePicker(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Set width to 80% of the screen
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 300,
          child: Center( // Center the scroll wheel container
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // Set width to 80% of the screen
              child: Row(
                children: [
                  Expanded(
                    child: _buildScrollWheel(
                      items: months,
                      initialItem: selectedMonth - 1,
                      onChanged: (index) {
                        setState(() {
                          selectedMonth = index + 1;
                          int daysInNewMonth = _daysInMonth(selectedYear, selectedMonth);
                          if (selectedDay > daysInNewMonth) {
                            selectedDay = daysInNewMonth;
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildScrollWheel(
                      items: List.generate(_daysInMonth(selectedYear, selectedMonth),
                              (index) => (index + 1).toString().padLeft(2, '0')),
                      initialItem: selectedDay - 1,
                      onChanged: (index) => setState(() => selectedDay = index + 1),
                    ),
                  ),
                  Expanded(
                    child: _buildScrollWheel(
                      // Generate years starting from (current year - 13) to (current year - 150)
                      items: List.generate(
                          150 - 13, // Adjust the range to exclude years within 13 years from the present
                              (index) => (DateTime.now().year - 150 + index + 1).toString()
                      ),
                      initialItem: 150 - (DateTime.now().year - selectedYear) - 1,
                      onChanged: (index) {
                        setState(() {
                          selectedYear = DateTime.now().year - 150 + index + 1;
                          if (selectedMonth == 2) {
                            int daysInNewMonth = _daysInMonth(selectedYear, selectedMonth);
                            if (selectedDay > daysInNewMonth) {
                              selectedDay = daysInNewMonth;
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
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


  void _validateAndNavigate() {
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    if (isSkip) {
      registrationProvider.updateUserData(dob: null);
    } else {
      registrationProvider.updateUserData(dob: DateTime(selectedYear, selectedMonth, selectedDay));
    }
    Navigator.pushNamed(context, '/tob');
  }

  Widget _buildNavigationButtons() {
    return NavigationArrows(
      onForward: _validateAndNavigate,
    );
  }
}