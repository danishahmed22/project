import 'dart:ui';
import 'package:flutter/material.dart';
import '../../Widgets/back.dart';
import '../constants/background_video.dart';
import 'package:provider/provider.dart';
import '../../Constants/list_of_cities_in_japan.dart';
import '../../widgets/navigation_arrows.dart';
import '../../provider/registration_provider.dart';
import '../constants/glassMorphicContainer.dart';
import '../constants/progressbar.dart';
import 'confirmation_screen.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _cityController = TextEditingController();
  List<String> _filteredCities = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _filteredCities = [];
  }

  @override
  Widget build(BuildContext context) {
    final registrationProvider = Provider.of<RegistrationProvider>(context);

    void _validateAndNavigate() {
      if (_cityController.text.isNotEmpty) {
        registrationProvider.updateUserData(city: _cityController.text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmationScreen()),
        );
      }
    }

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
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomBackButton(), // Add the custom back button here
                    ],
                  ),
                  FormProgressIndicator(currentStep: 5, totalSteps: 6),
                  SizedBox(height: 40),
                  GlassmorphicContainer(
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0), // Padding to avoid text close to edges
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isTyping = value.isNotEmpty;
                            _filteredCities = japanLocations
                                .where((city) => city.toLowerCase().startsWith(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                  ),
                  if (_isTyping)
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0), // Padding around the dropdown
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Optional: If you want rounded corners
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: (_filteredCities.length > 5 ? 5 * 56 : _filteredCities.length * 56).toDouble(), // Limit to 5 items max
                              maxWidth: MediaQuery.of(context).size.width - 32, // Make sure it fits the input field width
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true, // Ensure the list does not take up more space than needed
                              itemCount: _filteredCities.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    _filteredCities[index],
                                    style: TextStyle(color: Colors.white), // Adjust text style if needed
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _cityController.text = _filteredCities[index];
                                      _filteredCities = [];
                                      _isTyping = false; // Stop showing background and dropdown
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}