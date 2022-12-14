import 'package:flutter/material.dart';

class AppColors {
  static LinearGradient defaultGradient() {
    return const LinearGradient(
      colors: [iconColor1, iconColor3],
      begin: FractionalOffset.centerLeft,
      end: FractionalOffset.centerRight,
    );
  }

  static Color primaryColor = Colors.blue.shade800;
  static const Color paracolor = Color(0x6F6F6F6F);
  static const Color textColor = Color.fromARGB(255, 115, 115, 115);
  static const Color mainColor = Color(0xF6F6BE00);
  static const Color background = Color.fromARGB(255, 227, 229, 231);

  static const Color nocolor = Colors.black;
  static const Color yescolor = Colors.black38;

  static const Color iconColor1 = Color.fromARGB(255, 255, 153, 0);
  static const Color iconColor2 = Color.fromARGB(255, 252, 187, 90);
  static const Color iconColor3 = Color.fromARGB(255, 253, 203, 127);
  static const Color iconColor4 = Color.fromARGB(255, 255, 237, 210);
  static const Color paraColor = Color(0xFF8f837f);
  static const Color buttonBackgroundColor = Color(0xFFf7f6f4);
  static const Color signColor = Color(0xFFa9a29f);
  static const Color titlecolor = Color.fromARGB(109, 53, 53, 53);
}
