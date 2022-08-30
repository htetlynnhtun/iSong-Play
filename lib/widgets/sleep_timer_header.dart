import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/utils/extension.dart';

import '../resources/colors.dart';

class SleepTimerHeader extends StatelessWidget {
  final String title;
  const SleepTimerHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.isDarkMode(context) ? darkModeContainerBackgroundColor : containerBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.h),
            topRight: Radius.circular(16.h),
          )),
      height: 40.h,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            color: context.isDarkMode(context) ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
