import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/dimensions.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    required this.press,
  }) : super(key: key);
  final String? text;
  final Function() press;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.screenWidth * 0.7,
      height: Dimensions.screenHeight / 15,
      child: Ink(
        decoration: BoxDecoration(
          gradient: AppColors.defaultGradient(),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: TextButton(
          onPressed: press,
          child: Text(
            text!,
            style: TextStyle(
              fontSize: Dimensions.screenWidth / 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
