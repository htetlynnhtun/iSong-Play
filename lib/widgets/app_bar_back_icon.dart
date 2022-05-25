import 'package:flutter/material.dart';

import '../resources/colors.dart';
import 'asset_image_button.dart';

class AppBarBackIcon extends StatelessWidget {
  const AppBarBackIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AssetImageButton(
      imageUrl: 'assets/images/ic_back.png',
      width: 20,
      height: 20,
      color: primaryColor,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
