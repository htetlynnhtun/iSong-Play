import 'package:flutter/material.dart';

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
      width: 20,
      height: 20,
      color: color,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
