import 'package:flutter/material.dart';

import '../resources/colors.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  const AppBarTitle({
    required this.title,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: primaryColor,
      ),
    );
  }
}
