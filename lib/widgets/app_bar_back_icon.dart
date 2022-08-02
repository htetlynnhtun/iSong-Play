import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors.dart';
import 'asset_image_button.dart';

class AppBarBackIcon extends StatelessWidget {
  final Color color;
  const AppBarBackIcon({
    this.color = primaryColor,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AssetImageButton(
      imageUrl: 'assets/images/ic_back.png',
      width:16.h,
      height: 16.h,
      color: color,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
