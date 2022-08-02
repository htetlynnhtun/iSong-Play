import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors.dart';

class TitleText extends StatelessWidget {
  final String title;
  const TitleText({ required this.title,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 16.w),
      child: Text(title,
        style:  TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryColor,
          fontSize: 20.sp,
        ),
      ),
    );
  }
}
