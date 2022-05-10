import 'package:flutter/material.dart';

import '../utility/dimensions.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
            errors.length, (index) => formErrorText(error: errors[index])));
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        const Icon(
          Icons.error,
          color: Colors.red,
        ),
        SizedBox(
          width: Dimensions.width10,
          height: Dimensions.height15,
        ),
        Flexible(
            child: Text(
          error,
          style: const TextStyle(fontSize: 13),
        ))
      ],
    );
  }
}
