import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogTextButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onTap;
  const DialogTextButton({Key? key, required this.title, required this.color, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextButton(
      onPressed: () {
        onTap();
      },
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
