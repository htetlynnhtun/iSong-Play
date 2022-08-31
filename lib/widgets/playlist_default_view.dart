import 'package:flutter/material.dart';

import '../resources/colors.dart';

class PlaylistDefaultView extends StatelessWidget {
  final double width,height, cornerRadius, scale;
  const PlaylistDefaultView(
      {Key? key,
      required this.width,
      required this.cornerRadius,
      required this.scale, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: Center(
          child: Image.asset(
        'assets/images/ic_playlist.png',
        scale: scale,
      )),
    );
  }
}
