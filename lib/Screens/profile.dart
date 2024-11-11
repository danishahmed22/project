import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widgets/back.dart';
import '../Widgets/circle_test.dart';
import '../Widgets/navBar.dart';
import 'constants/background_video.dart';
import 'constants/glassMorphicContainer.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideoWidget(),

          // Main Column for Layout
          Positioned(
            left: 20,
            top: 116,
            child: DynamicCircle(
              size: 180,
              text: '1', // Earth
            ),
          ),
          Positioned(
            right: 30,
            top: 85,
            child: DynamicCircle(
              size: 160,
              text: '2', // Water
            ),
          ),
          Positioned(
            left: 60,
            top: 320,
            child: DynamicCircle(
              size: 100,
              text: '3', // Fire
            ),
          ),
          Positioned(
            right: 40,
            top: 250,
            child: DynamicCircle(
              size: 180,
              text: '4', // Metal
            ),
          ),
          Positioned(
            left: 140,
            top: 390,
            child: DynamicCircle(
              size: 90,
              text: '5', // Wood
            ),
          ),

          // Text Information in the next 20%
          Positioned(
            bottom: 100,
            child: GlassmorphicContainer(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '笑顔の魔法使い 己酉',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '仕事では、隠れた才能がどんどん開花。パッと\n'
                          '社蓋が開くように、新しいアイデアが次々と生\n'
                          'まれ、周囲から頼られる存在になり、プロジェ\n'
                          'クトリーダーの座につきます。\n'
                          '\n'
                          '・ラッキーフード：旬のフルーツ盛り合わせ\n'
                          '・ラッキーアイテム：手帳とカラフルなペン',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar in the bottom 20%
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomNavBar(),
              ),
            ),
          ),

          // Back Button at the top left corner
          Positioned(
            top: 16.0,
            left: 16.0,
            child: CustomBackButton(),
          ),

          // IconButton at the top right corner
          Positioned(
            top: 16.0,
            right: 16.0,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return SettingsScreen();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isEditing = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController birthTimeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          emailController.text = userDoc['email'] ?? '';
          birthDateController.text = userDoc['dob'] ?? '';
          birthTimeController.text = userDoc['tob'] ?? '';
          addressController.text = userDoc['city'] ?? '';
        });
      }
    }
  }

  Future<void> saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'email': emailController.text,
        'dob': birthDateController.text,
        'tob': birthTimeController.text,
        'city': addressController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Stack(
        children: [
          BackgroundVideoWidget(), // Adds the background video widget
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SafeArea(
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '設定',
                                style: TextStyle(fontSize: 24, color: Colors.white),
                              ),
                              IconButton(
                                icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
                                onPressed: () async {
                                  if (isEditing) {
                                    await saveUserData();
                                    Navigator.pop(context);
                                  }
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: emailController,
                            enabled: isEditing,
                            decoration: InputDecoration(
                              hintText: 'you@futurist.com',
                              hintStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            obscureText: true,
                            controller: passwordController,
                            enabled: isEditing,
                            decoration: InputDecoration(
                              hintText: '********',
                              hintStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: birthDateController,
                                  enabled: isEditing,
                                  decoration: InputDecoration(
                                    hintText: '1989/12/15',
                                    hintStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.2),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: birthTimeController,
                                  enabled: isEditing,
                                  decoration: InputDecoration(
                                    hintText: '14:00',
                                    hintStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.2),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: addressController,
                            enabled: isEditing,
                            decoration: InputDecoration(
                              hintText: 'Japan, Tokyo',
                              hintStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
