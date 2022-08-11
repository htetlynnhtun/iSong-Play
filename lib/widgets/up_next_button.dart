import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/utils/extension.dart';

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
          scale: context.isMobile() ? 2.5 : 1.5,
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
