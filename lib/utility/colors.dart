import 'package:flutter/material.dart';

class AppColors {
  static LinearGradient defaultGradient() {
    return LinearGradient(
      colors: [Colors.blue.shade800, Colors.blue.shade300],
      begin: FractionalOffset.centerLeft,
      end: FractionalOffset.centerRight,
    );
  }

  static Color primaryColor = Colors.blue.shade800;
  static const Color textColor = Color.fromARGB(255, 115, 115, 115);
  static const Color mainColor = Color(0xFF89dad0);
  static const Color background = Color.fromARGB(255, 227, 229, 231);

  static const Color iconColor1 = Color.fromARGB(255, 255, 153, 0);
  static const Color iconColor2 = Color.fromARGB(255, 252, 187, 90);
  static const Color paraColor = Color(0xFF8f837f);
  static const Color buttonBackgroundColor = Color(0xFFf7f6f4);
  static const Color signColor = Color(0xFFa9a29f);
  static const Color titleColor = Color(0xFF5c524f);
}
