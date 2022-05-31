import 'package:flutter/material.dart';

class AssetImageButton extends StatelessWidget {
  final Function onTap;
  final double width,height;
  final String imageUrl;
  final Color? color;
  const AssetImageButton({
    required this.onTap,
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.color,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Image.asset(
          color:color,
          imageUrl,
          height: width,
          width: height,
        ),
        onPressed: () {
          onTap();
        },
      ),
    );
  }
}
