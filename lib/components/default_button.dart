import 'package:crime_alert/utility/constants.dart';
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
      width: double.infinity,
      height: Dimensions.screenHeight / 15,
      child: Ink(
        decoration: BoxDecoration(
          gradient: Constants.defaultGradient(),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: TextButton(
          onPressed: press,
          child: Text(
            text!,
            style: TextStyle(
              fontSize: Dimensions.screenWidth / 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
