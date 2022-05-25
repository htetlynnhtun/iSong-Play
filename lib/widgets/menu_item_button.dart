import 'package:flutter/material.dart';
class MenuItemButton extends StatelessWidget {
  final String title;
  final IconData icon;

  const MenuItemButton({
    required this.title,
    required this.icon,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:  [
        Text(title),
        const SizedBox(
          width: 6,
        ),
        Icon(icon),
      ],
    );
  }
}
