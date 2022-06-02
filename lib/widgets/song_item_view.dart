import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/utils/callback_typedefs.dart';
import 'package:music_app/views/playlist_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:music_app/resources/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/utils/extension.dart';
import 'custom_cached_image.dart';
import 'menu_item_button.dart';

class SongItemView extends StatelessWidget {
  final SongVO songVO;
  final bool isSearch;
  final bool isUpNext;
  final List<SongItemPopupMenu> menus;
  const SongItemView(
    this.songVO, {
    this.menus = const [],
    this.isSearch = false,
    this.isUpNext = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PlayerBloc, SongVO?>(
        selector: (_, playerBloc) => playerBloc.nowPlayingSong,
        builder: (_, nowPlayingSong, __) {
          return Row(
            children: [
              CustomCachedImage(width: 56, height: 56, imageUrl: songVO.thumbnail, isSearch: isSearch, cornerRadius: 10),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: TitleArtistAndDownloadStatusView(
                songVO: songVO,
                isUpNext: isUpNext,
              )),
              if (nowPlayingSong?.id == songVO.id)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    Lottie.asset(
                      'assets/animation.json',
                      width: 32,
                      height: 32,
                    ),
                  ],
                ),
              const SizedBox(
                width: 14,
              ),
              PopupMenuButton<SongItemPopupMenu>(
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
                  switch (value) {
                    case SongItemPopupMenu.addToLibrary:
                      final result = await context.read<LibraryBloc>().onTapAddToLibrary(songVO);
                      switch (result) {
                        case AddToLibraryResult.success:
                          showToast("Successfully added to library");
                          break;
                        case AddToLibraryResult.alreadyInLibrary:
                          showToast("Song is already in library");
                          break;
                      }
                      break;
                    case SongItemPopupMenu.deleteFromLibrary:
                      context.read<LibraryBloc>().onTapDelete(songVO);
                      break;
                    // case SongItemPopupMenu.addToFavorite:
                    //   print("add fav");
                    //   break;
                    case SongItemPopupMenu.deleteFromFavorite:
                      context.read<LibraryBloc>().onTapDeleteFromFavorite(songVO);
                      break;
                    case SongItemPopupMenu.addToQueue:
                      context.read<PlayerBloc>().onTapAddToQueue(songVO);
                      break;
                    case SongItemPopupMenu.addToPlaylist:
                      showModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        useRootNavigator: true,
                        context: context,
                        builder: (context) => PlaylistBottomSheet(songVO),
                      );
                      break;
                    case SongItemPopupMenu.deleteFromPlaylist:
                      final playlistVO = context.read<LibraryBloc>().currentPlaylistDetail!;
                      print("delete song from playlist ${playlistVO.name}");
                      break;
                  }
                },
                itemBuilder: (context) => menus
                    .map((menu) => PopupMenuItem(
                          value: menu,
                          child: MenuItemButton(
                            title: menu.title,
                            icon: menu.icon,
                          ),
                        ))
                    .toList(),
              ),
            ],
          );
        });
  }
}

class TitleArtistAndDownloadStatusView extends StatelessWidget {
  final SongVO songVO;
  final bool isUpNext;
  const TitleArtistAndDownloadStatusView({
    Key? key,
    this.isUpNext = false,
    required this.songVO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          songVO.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            fontSize: 18,
            color: (isUpNext) ? Colors.white : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<LibraryBloc, String?>(
              selector: (_, libraryBloc) => libraryBloc.activeDownloadIDs.firstWhere((element) => element == songVO.id, orElse: () => null),
              builder: (_, id, __) {
                print("builder download status");
                if (id != null) {
                  return const CupertinoActivityIndicator(radius: 6);
                }
                if (songVO.isDownloadFinished) {
                  return Image.asset(
                    'assets/images/ic_downloaded.png',
                    color: primaryColor,
                    scale: 4,
                  );
                }
                return Container();
              },
            ),
            const SizedBox(
              width: 2,
            ),
            Expanded(
              child: Text(
                songVO.artist,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: (isUpNext) ? Colors.white : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum SongItemPopupMenu {
  addToLibrary,
  deleteFromLibrary,
  // addToFavorite,
  deleteFromFavorite,
  addToQueue,
  addToPlaylist,
  deleteFromPlaylist,
}

extension MenuName on SongItemPopupMenu {
  String get title {
    switch (this) {
      case SongItemPopupMenu.addToLibrary:
        return "Add To Library";
      case SongItemPopupMenu.deleteFromLibrary:
        return "Delete";
      // case SongItemPopupMenu.addToFavorite:
      //   return "Add To Favorite";
      case SongItemPopupMenu.deleteFromFavorite:
        return "Delete From Favorite";
      case SongItemPopupMenu.addToQueue:
        return "Add To Queue";
      case SongItemPopupMenu.addToPlaylist:
        return "Add To Playlist";
      case SongItemPopupMenu.deleteFromPlaylist:
        return "Delete From Playlist";
    }
  }

  IconData get icon {
    switch (this) {
      case SongItemPopupMenu.addToLibrary:
        return Icons.add;
      case SongItemPopupMenu.deleteFromLibrary:
        return Icons.delete;
      // case SongItemPopupMenu.addToFavorite:
      case SongItemPopupMenu.deleteFromFavorite:
        return Icons.favorite;
      case SongItemPopupMenu.addToQueue:
        return Icons.queue;
      case SongItemPopupMenu.addToPlaylist:
        return Icons.playlist_add;
      case SongItemPopupMenu.deleteFromPlaylist:
        return Icons.playlist_remove;
    }
  }
}
