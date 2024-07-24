import 'package:flutter/material.dart' hide MenuItemButton;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/utils/extension.dart';
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
        automaticallyImplyLeading: false,
        leading: const AppBarBackIcon(),
        title: AppBarTitle(title: title),
        actions: [
          PopupMenuButton<String>(
            padding: context.isMobile() ? EdgeInsets.zero : EdgeInsets.only(right: 16.w),
            icon: Icon(
              Icons.sort,
              size: 24.h,
              color: primaryColor,
            ),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.h),
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
                  icon: Icons.title,
                ),
              ),
              const PopupMenuItem(
                value: "date",
                child: MenuItemButton(
                  title: "By Date",
                  icon: Icons.date_range,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.w),
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
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: context.isMobile() ? 16.w : 12.w),
                  child: SongCountAndPlayShuffleView(songs: songs),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => context.read<PlayerBloc>().onTapSong(index, songs, withBlocking: false),
                      child: SongItemView(
                        songs[index],
                        menus: menus,
                      ),
                    ),
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
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

class SongCountAndPlayShuffleView extends StatelessWidget {
  final List<SongVO> songs;
  const SongCountAndPlayShuffleView({
    required this.songs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${songs.length} Song'.calculateCountS(songs.length),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: primaryColor,
          ),
        ),
        const Spacer(),
        AssetImageButton(
          onTap: () => context.read<PlayerBloc>().onTapSong(0, songs, withBlocking: false),
          width: 16.h,
          height: 16.h,
          imageUrl: 'assets/images/ic_play.png',
          color: primaryColor,
        ),
        SizedBox(
          width: 12.w,
        ),
        AssetImageButton(
          onTap: () => context.read<PlayerBloc>().onTapShufflePlay(songs),
          width: 16.h,
          height: 16.h,
          imageUrl: 'assets/images/ic_shuffle.png',
          color: primaryColor,
        ),
      ],
    );
  }
}
