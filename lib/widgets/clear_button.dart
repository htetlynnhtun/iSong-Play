import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  final Function onTap;
  const ClearButton({
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Image.asset(
        'assets/images/ic_clear.png',
        height: 20,
        width: 20,
      ),
      onPressed: () {
        onTap();
      },
    );
  }
}
