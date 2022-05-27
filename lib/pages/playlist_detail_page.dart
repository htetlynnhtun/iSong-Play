import 'package:flutter/material.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/widgets/custom_cached_image.dart';

import '../resources/colors.dart';
import '../resources/constants.dart';
import '../widgets/app_bar_back_icon.dart';
import '../widgets/app_bar_title.dart';
import '../widgets/menu_item_button.dart';
import '../widgets/song_item_view.dart';

class PlaylistDetailPage extends StatelessWidget {
  const PlaylistDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: const AppBarBackIcon(),
        title: const AppBarTitle(title: 'Playlist'),
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: const [
            SizedBox(
              height: 16,
            ),
            PlaylistHeaderView(),
            SizedBox(height: 32,),
            SongsCollectionView()
          ],
        ),
      ),
    );
  }
}

class PlaylistHeaderView extends StatelessWidget {
  const PlaylistHeaderView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.45;
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child:  CustomCachedImage(
              imageUrl:
                  'https://img.youtube.com/vi/mNEUkkoUoIA/maxresdefault.jpg',
              cornerRadius: cornerRadius,
              width: _width,
            ),
          ),
          const SizedBox(width: 16,),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Girl Selection',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  '20 Tracks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                PlayAndShuffleView(),

              ],
            ),
          )
        ],
      ),
    );
  }
}

class SongsCollectionView extends StatelessWidget {
  const SongsCollectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) => SongItemView(
              songVO,
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 12,
          ),
          itemCount: 10),
    );
  }
}

class PlayAndShuffleView extends StatelessWidget {
  const PlayAndShuffleView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        PlaylistButton(
          isSelected: true,
          title: 'Play All',
          imageUrl: 'assets/images/ic_play.png',
        ),
        Spacer(),
        PlaylistButton(
          isSelected: true,
          title: 'Play All',
          imageUrl: 'assets/images/ic_shuffle.png',
        )
      ],
    );
  }
}

class PlaylistButton extends StatelessWidget {
  final String title, imageUrl;
  final bool isSelected;
  const PlaylistButton({
    this.isSelected = false,
    required this.title,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 28,
      decoration: BoxDecoration(
        color: (isSelected) ? primaryColor : playlistButtonUnselectedColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imageUrl,
              width: 14,
              height: 14,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
