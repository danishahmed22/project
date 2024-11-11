import 'package:flutter/material.dart';

class User {
  String? name;
  String? email;
  String? password;
  String? gender;
  DateTime? dob;
  TimeOfDay? tob;
  String? city;

  User({
    this.name,
    this.email,
    this.password,
    this.gender,
    this.dob,
    this.tob,
    this.city,
  });
}

class RegistrationProvider with ChangeNotifier {
  User _user = User();

  User get user => _user;

  void updateUserName(String name) {
    _user.name = name;
    notifyListeners();
  }

  void updateUserData({
    String? name,
    String? email,
    String? password,
    String? gender,
    DateTime? dob,
    TimeOfDay? tob,
    String? city,
  }) {
    if (name != null) _user.name = name;
    if (email != null) _user.email = email;
    if (password != null) _user.password = password;
    if (gender != null) _user.gender = gender;
    if (dob != null) _user.dob = dob;
    if (tob != null) _user.tob = tob;
    if (city != null) _user.city = city;
    notifyListeners();
  }
}