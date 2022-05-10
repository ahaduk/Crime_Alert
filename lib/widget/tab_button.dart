import 'package:crime_alert/utility/dimensions.dart';
import 'package:crime_alert/widget/big_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavTabs extends StatelessWidget {
  final String text;
  final int selectedPage;
  final int pageNumber;
  final VoidCallback onPressed;
  const NavTabs(
      {Key? key,
      required this.text,
      this.selectedPage = 0,
      this.pageNumber = 0,
      required this.onPressed})
      : super(key: key);
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height10,
          horizontal: Dimensions.height20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        child: BigText(
          text: text,
          size: screenHeight <= 825 ? 16 : Dimensions.font20,
          color: selectedPage == pageNumber
              ? const Color.fromARGB(255, 2, 2, 2)
              : const Color.fromARGB(255, 167, 166, 166),
        ),
      ),
    );
  }
}
