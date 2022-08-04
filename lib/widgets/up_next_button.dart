import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpNextButton extends StatelessWidget {
  final String iconUrl;
  const UpNextButton({
    Key? key,
    required this.iconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconUrl,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          'Up Next',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
