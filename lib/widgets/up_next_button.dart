import 'package:flutter/material.dart';

class UpNextButton extends StatelessWidget {
  final String iconUrl;
  const UpNextButton({
    Key? key,
    required this.iconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconUrl,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          'Up Next',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white,
          ),
        ),

      ],
    );
  }
}
