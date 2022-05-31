import 'package:flutter/material.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/widgets/app_bar_back_icon.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:provider/provider.dart';

import '../widgets/app_bar_title.dart';
import '../widgets/asset_image_button.dart';
import '../widgets/menu_item_button.dart';
import '../widgets/song_item_view.dart';

class SongsDetailPage extends StatelessWidget {
  final String title;
  final bool isFavorite;
  const SongsDetailPage({
    required this.title,
    required this.isFavorite,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: const AppBarBackIcon(),
        title: AppBarTitle(title: title),
        actions: [
          PopupMenuButton<String>(
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
              if (value == "title") {
                context.read<LibraryBloc>().sortAllSongsByTitle();
              } else if (value == "date") {
                context.read<LibraryBloc>().sortAllSongsByDate();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "title",
                child: MenuItemButton(
                  title: "By Title",
                  icon: Icons.add,
                ),
              ),
              const PopupMenuItem(
                value: "date",
                child: MenuItemButton(
                  title: "By Date",
                  icon: Icons.add,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Selector<LibraryBloc, List<SongVO>>(
          selector: (_, libraryBloc) {
            if (isFavorite) {
              return libraryBloc.songs.where((e) => e.isFavorite).toList();
            }
            return libraryBloc.songs;
          },
          shouldRebuild: (_, __) => true,
          builder: (_, songs, __) {
            List<SongItemPopupMenu> menus;
            if (isFavorite) {
              menus = [
                SongItemPopupMenu.addToQueue,
                SongItemPopupMenu.addToPlaylist,
                SongItemPopupMenu.deleteFromFavorite,
                SongItemPopupMenu.deleteFromLibrary,
              ];
            } else {
              menus = [
                SongItemPopupMenu.addToQueue,
                SongItemPopupMenu.addToPlaylist,
                SongItemPopupMenu.deleteFromLibrary,
              ];
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                SongCountPlayShuffleView(songCount: songs.length),
                const SizedBox(
                  height: 22,
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => SongItemView(
                      songs[index],
                      menus: menus,
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemCount: songs.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SongCountPlayShuffleView extends StatelessWidget {
  final int songCount;
  const SongCountPlayShuffleView({
    required this.songCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$songCount Songs',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: primaryColor,
          ),
        ),
        const Spacer(),
        AssetImageButton(onTap: () {}, width: 20, height: 20, imageUrl: 'assets/images/ic_play.png', color: primaryColor),
        const SizedBox(
          width: 16,
        ),
        AssetImageButton(onTap: () {}, width: 20, height: 20, imageUrl: 'assets/images/ic_shuffle.png', color: primaryColor),
      ],
    );
  }
}
