import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors.dart';
import 'asset_image_button.dart';

class AppBarBackIcon extends StatelessWidget {
  final Color color;
  const AppBarBackIcon({this.color = primaryColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.chevron_left,
        size: 30.h,
        color: color,
      ),
    );
  }
}
