import 'package:flutter/material.dart';

import '../utility/dimensions.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  const BigText(
      {Key? key,
      this.color = const Color(0xFF332d2b),
      this.size = 0,
      required this.text,
      this.fontWeight = FontWeight.w700,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: 4,
      style: TextStyle(
          color: color,
          // fontFamily: 'Montserrat',
          fontWeight: fontWeight,
          fontSize: size == 0 ? Dimensions.font20 : size),
    );
  }
}
