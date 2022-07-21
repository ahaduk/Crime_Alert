import 'package:flutter/material.dart';

import '../utility/colors.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.mainColor,
        ),
      ),
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: ShapeDecoration(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        gradient: AppColors.defaultGradient(),
      ),
    );
  }
}
