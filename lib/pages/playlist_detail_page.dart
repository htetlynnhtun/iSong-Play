import 'package:flutter/material.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:provider/provider.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/vos/playlist_vo.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/add_rename_playlist_dialog.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:music_app/utils/extension.dart';

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
    return Selector<LibraryBloc, PlaylistVo>(
        selector: (_, libraryBloc) => libraryBloc.currentPlaylistDetail!,
        shouldRebuild: (_, __) => true,
        builder: (_, playlistVo, __) {
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
                  onSelected: (value) async {
                    if (value == "rename") {
                      showDialog(
                        context: context,
                        builder: (context) => AddRenamePlaylistDialog(
                          initialText: playlistVo.name,
                          onRename: (oldName) => context.read<LibraryBloc>().onTapRenamePlaylist(oldName),
                          title: "Playlist Name",
                          onTapTitle: "Rename",
                        ),
                      );
                    } else if (value == "delete") {
                      await context.read<LibraryBloc>().onTapDeletePlaylist(playlistVo);
                      Navigator.pop(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "rename",
                      child: MenuItemButton(
                        title: "Rename",
                        icon: Icons.edit,
                      ),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: MenuItemButton(
                        title: "Delete",
                        icon: Icons.delete,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  PlaylistHeaderView(playlistVo: playlistVo),
                  const SizedBox(
                    height: 32,
                  ),
                  SongsCollectionView(songs: playlistVo.songList),
                ],
              ),
            ),
          );
        });
  }
}

class PlaylistHeaderView extends StatelessWidget {
  final PlaylistVo playlistVo;
  const PlaylistHeaderView({
    required this.playlistVo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.45;
    final imageUrl = playlistVo.thumbnail ?? 'https://img.youtube.com/vi/mNEUkkoUoIA/maxresdefault.jpg';
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: CustomCachedImage(
              imageUrl: imageUrl,
              cornerRadius: cornerRadius,
              width: _width,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlistVo.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  "${playlistVo.songList.length} Tracks",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                PlayAndShuffleView(playlistVo),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SongsCollectionView extends StatelessWidget {
  final List<SongVO> songs;
  const SongsCollectionView({
    required this.songs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (_, index) => GestureDetector(
          onTap: () => context.read<PlayerBloc>().onTapSong(index, songs),
          child: SongItemView(
            songs[index],
            menus: const [
              SongItemPopupMenu.addToQueue,
              SongItemPopupMenu.addToPlaylist,
              SongItemPopupMenu.deleteFromPlaylist,
              SongItemPopupMenu.deleteFromLibrary,
            ],
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: songs.length,
      ),
    );
  }
}

class PlayAndShuffleView extends StatelessWidget {
  final PlaylistVo playlistVo;
  const PlayAndShuffleView(this.playlistVo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.read<PlayerBloc>().onTapSong(0, playlistVo.songList),
          child: const PlaylistButton(
            isSelected: true,
            title: 'Play All',
            imageUrl: 'assets/images/ic_play.png',
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => context.read<PlayerBloc>().onTapShufflePlay(playlistVo.songList),
          child: const PlaylistButton(
            isSelected: true,
            title: 'Play All',
            imageUrl: 'assets/images/ic_shuffle.png',
          ),
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
              style: const TextStyle(
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
