import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide MenuItemButton;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
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
  final bool havePlaceHolderImage;
  final bool isUpNext;
  final bool isLoading;
  final List<SongItemPopupMenu> menus;
  final bool showMenuButton;
  const SongItemView(
    this.songVO, {
    this.menus = const [],
    this.havePlaceHolderImage = false,
    this.isUpNext = false,
    this.isLoading = false,
    this.showMenuButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<PlayerBloc, SongVO?>(
        selector: (_, playerBloc) => playerBloc.nowPlayingSong,
        builder: (_, nowPlayingSong, __) {
          return Row(
            children: [
              CustomCachedImage(
                width: 52.h,
                height: 52.h,
                imageUrl: songVO.thumbnail,
                havePlaceHolderImage: havePlaceHolderImage,
                cornerRadius: 8.h,
              ),
              SizedBox(
                width: 6.h,
              ),
              Expanded(
                child: TitleArtistAndDownloadStatusView(
                  isLoading: isLoading,
                  songVO: songVO,
                  isUpNext: isUpNext,
                ),
              ),
              if (nowPlayingSong?.id == songVO.id)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 6.w,
                    ),
                    Selector<PlayerBloc, ButtonState>(
                        selector: (_, playerBloc) => playerBloc.buttonState,
                        builder: (_, buttonState, __) {
                          final isAnimate = buttonState == ButtonState.playing;

                          return Lottie.asset(
                            'assets/animation.json',
                            width: 32.w,
                            height: 32.w,
                            animate: isAnimate,
                          );
                        }),
                  ],
                ),
              SizedBox(
                width: 16.w,
              ),
              if (showMenuButton)
                PopupMenuButton<SongItemPopupMenu>(
                  padding: context.isMobile()
                      ? EdgeInsets.only(right: 8.w)
                      : EdgeInsets.only(right: 16.w),
                  icon: Icon(
                    Icons.more_horiz,
                    color: primaryColor,
                    size: 24.h,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.h),
                    ),
                  ),
                  onSelected: (value) async {
                    switch (value) {
                      case SongItemPopupMenu.addToLibrary:
                        final result = await context
                            .read<LibraryBloc>()
                            .onTapAddToLibrary(songVO);
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
                        context
                            .read<LibraryBloc>()
                            .onTapDeleteFromFavorite(songVO);
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
                        context
                            .read<LibraryBloc>()
                            .onTapDeleteFromPlaylist(songVO);
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
  final bool isLoading;
  const TitleArtistAndDownloadStatusView({
    Key? key,
    this.isUpNext = false,
    required this.songVO,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isLoading ? "Loading This Song" : songVO.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            fontSize: 16.sp,
            color: (isUpNext) ? Colors.white : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<LibraryBloc, String?>(
              selector: (_, libraryBloc) => libraryBloc.activeDownloadIDs
                  .firstWhere((element) => element == songVO.id,
                      orElse: () => null),
              builder: (_, id, __) {
                // print("builder download status");
                if (id != null) {
                  return const CupertinoActivityIndicator(
                    radius: 6,
                    color: primaryColor,
                  );
                }
                if (songVO.isDownloadFinished) {
                  return Image.asset(
                    'assets/images/ic_downloaded.png',
                    color: primaryColor,
                    scale: context.isMobile() ? 4 : 2.5,
                  );
                }
                return const SizedBox();
              },
            ),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: Text(
                songVO.artist,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
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
