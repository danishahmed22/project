import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white,),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
