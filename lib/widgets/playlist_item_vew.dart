import 'package:flutter/material.dart';
import 'package:music_app/widgets/custom_cached_image.dart';

import '../resources/colors.dart';
import 'menu_item_button.dart';

class PlaylistItemView extends StatelessWidget {
  final Function onTap;
  const PlaylistItemView({
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Row(
        children: [
          const CustomCachedImage(
            imageUrl: 'https://img.youtube.com/vi/e-ORhEE9VVg/maxresdefault.jpg',
            cornerRadius: 10,
            width: 99,
            height: 56,
          ),
          const SizedBox(
            width: 16,
          ),
          const PlaylistTitleAndTracksView(),
          const Spacer(),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_horiz,
              color: primaryColor,
            ),
            elevation: 2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            onSelected: (value) {
              // TODO: handle menu button action
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'test',
                child: MenuItemButton(
                  title: 'Add to Library',
                  icon: Icons.add,
                ),
              ),
              const PopupMenuItem(
                value: 'test',
                child: MenuItemButton(
                  title: 'Add to Library',
                  icon: Icons.add,
                ),
              ),
              const PopupMenuItem(
                value: 'test',
                child: MenuItemButton(
                  title: 'Add to Library',
                  icon: Icons.add,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlaylistTitleAndTracksView extends StatelessWidget {
  const PlaylistTitleAndTracksView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Fav Song ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          '20 Tracks ',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
