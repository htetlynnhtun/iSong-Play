import 'package:flutter/material.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:provider/provider.dart';

import 'asset_image_button.dart';

class RecentAndSuggestionView extends StatelessWidget {
  final String title;
  final bool isRecent;
  const RecentAndSuggestionView(
      {required this.title, this.isRecent = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
        if (isRecent)
          AssetImageButton(
            onTap: () {
              context.read<SearchBloc>().onTapDeleteRecent(title);
            },
            width: 20,
            height: 20,
            imageUrl: 'assets/images/ic_clear.png',
            color: null,
          ),
      ],
    );
  }
}
