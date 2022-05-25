import 'package:flutter/material.dart';
import 'package:music_app/resources/colors.dart';

import '../widgets/asset_image_button.dart';
import '../widgets/menu_item_button.dart';
import '../widgets/song_item_view.dart';

class SongsDetailPage extends StatelessWidget {
  final String title;
  const SongsDetailPage({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: AssetImageButton(
          imageUrl: 'assets/images/ic_back.png',
          width: 20,
          height: 20,
          color: primaryColor,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: primaryColor,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.sort,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            const SongCountPlayShuffleView(),
            const SizedBox(
              height: 22,
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => SongItemView(
                        title: 'This is fucking long song title text $index',
                        artist: 'This is fucking long artist text name $index',
                      ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                  itemCount: 100),
            ),
          ],
        ),
      ),
    );
  }
}

class SongCountPlayShuffleView extends StatelessWidget {
  const SongCountPlayShuffleView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '7 Songs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: primaryColor,
          ),
        ),
        const Spacer(),
        AssetImageButton(
            onTap: () {},
            width: 20,
            height: 20,
            imageUrl: 'assets/images/ic_play.png',
            color: primaryColor),
        const SizedBox(
          width: 16,
        ),
        AssetImageButton(
            onTap: () {},
            width: 20,
            height: 20,
            imageUrl: 'assets/images/ic_shuffle.png',
            color: primaryColor),
      ],
    );
  }
}
