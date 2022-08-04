import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepTimerHeader extends StatelessWidget {
  final String title;
  const SleepTimerHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: 40.h,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
