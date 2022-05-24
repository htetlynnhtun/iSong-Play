import 'package:flutter/material.dart';

import 'clear_button.dart';

class RecentAndSuggestionView extends StatelessWidget {
  final String title;
  final bool isRecent;
  const RecentAndSuggestionView({
    required this.title,
    this.isRecent = true,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/ic_search.png',
          color: Colors.black,
          height: 16,
          width: 16,
        ),
        const SizedBox(
          width: 8,
        ),
         Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        const Spacer(),
        if(isRecent)
        ClearButton(
          onTap: () {},
        ),
      ],
    );
  }
}
