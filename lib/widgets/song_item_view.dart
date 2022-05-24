import 'package:flutter/material.dart';
import 'package:music_app/resources/colors.dart';

import 'custom_cached_image.dart';

class SongItemView extends StatelessWidget {
  final String title, artist;
  const SongItemView({required this.title, required this.artist, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomCachedImage(
            width: 56,
            height: 56,
            imageUrl:
                'https://img.youtube.com/vi/e-ORhEE9VVg/maxresdefault.jpg',
            cornerRadius: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(artist),
          ],
        ),
        const Spacer(),
        IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: const Icon(Icons.more_horiz,
            color: primaryColor,
            )),
      ],
    );
  }
}
