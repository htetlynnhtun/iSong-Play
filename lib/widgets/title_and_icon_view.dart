import 'package:flutter/material.dart';
import 'package:music_app/widgets/asset_image_button.dart';
import 'package:music_app/widgets/title_text.dart';

import '../resources/colors.dart';

class TitleAndSettingIconButtonView extends StatelessWidget {
  final String title;
  final Function onTap;
  final String imageUrl;
  const TitleAndSettingIconButtonView(
      {required this.title,
      required this.onTap,
        required this.imageUrl,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TitleText(title: title),
        const Spacer(),
        AssetImageButton(
          height: 20,
          width: 20,
          imageUrl: imageUrl,
          color: primaryColor,
          onTap: () {
            onTap();
          },
        ),
      ],
    );
  }
}
