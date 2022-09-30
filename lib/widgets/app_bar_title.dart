import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      style:  TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
        color: primaryColor,
      ),
    );
  }
}
