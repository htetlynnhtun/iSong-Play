import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemButton extends StatelessWidget {
  final String title;
  final IconData icon;

  const MenuItemButton({required this.title, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const Spacer(),
        Icon(icon),
      ],
    );
  }
}
