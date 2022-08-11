import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/utils/extension.dart';
import 'package:provider/provider.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/vos/playlist_vo.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/add_rename_playlist_dialog.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import '../resources/colors.dart';
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: const AppBarBackIcon(),
              title: const AppBarTitle(title: 'Playlist'),
              actions: [
                PopupMenuButton(
                  padding: context.isMobile()?EdgeInsets.zero:EdgeInsets.only(right: 16.w),
                  icon:  Icon(
                    Icons.more_horiz,
                    color: primaryColor,
                    size:24.h
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.h),
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
                      showDialog<bool>(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text("Are you sure?"),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context, true);
                                context.read<LibraryBloc>().onTapDeletePlaylist(playlistVo);
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      ).then((shouldPopParentPage) {
                        if (shouldPopParentPage == true) {
                          Navigator.pop(context);
                        }
                      });
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
              padding: EdgeInsets.only(left: 16.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 12.h,
                  ),
                  Padding(
                    padding: context.isMobile()? EdgeInsets.only(right: 14.w):EdgeInsets.only(right: 10.w),
                    child: PlaylistHeaderView(playlistVo: playlistVo),
                  ),
                  SizedBox(
                    height: 30.h,
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
    final width = MediaQuery.of(context).size.width * 0.45;
    final imageUrl = playlistVo.thumbnail ?? 'https://img.youtube.com/vi/mNEUkkoUoIA/maxresdefault.jpg';
    return SizedBox(
      height: 90.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: CustomCachedImage(
              imageUrl: imageUrl,
              cornerRadius: cornerRadius,
              width: width,
            ),
          ),
          SizedBox(
            width: 14.w,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  playlistVo.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  "${playlistVo.songList.length} Track".calculateCountS(playlistVo.songList.length),
                  style: TextStyle(
                    fontSize: 14.sp,
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
            imageUrl: 'assets/images/ic_play.png',
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => context.read<PlayerBloc>().onTapShufflePlay(playlistVo.songList),
          child: const PlaylistButton(
            imageUrl: 'assets/images/ic_shuffle.png',
          ),
        )
      ],
    );
  }
}

class PlaylistButton extends StatelessWidget {
  final String imageUrl;

  const PlaylistButton({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(7.h),
      ),
      child: Center(
        child: Image.asset(
          imageUrl,
          width: 18.w,
          height: 18.h,
        ),
      ),
    );
  }
}
