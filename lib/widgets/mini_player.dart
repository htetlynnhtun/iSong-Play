import 'package:flutter/material.dart';
import 'package:music_app/resources/colors.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: primaryColor,
    );
  }
}
