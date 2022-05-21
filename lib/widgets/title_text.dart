import 'package:flutter/material.dart';

import '../resources/colors.dart';

class TitleText extends StatelessWidget {
  final String title;
  const TitleText({ required this.title,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: primaryColor,
        fontSize: 18,
      ),
    );
  }
}
