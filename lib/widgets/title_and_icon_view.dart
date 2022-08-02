import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          height: 18.h,
          width: 18.h,
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
