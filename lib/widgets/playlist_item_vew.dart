import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/utils/extension.dart';
import 'package:provider/provider.dart';
import 'package:music_app/vos/playlist_vo.dart';
import 'package:music_app/widgets/add_rename_playlist_dialog.dart';
import 'package:music_app/widgets/custom_cached_image.dart';

import '../resources/colors.dart';
import 'menu_item_button.dart';

class PlaylistItemView extends StatelessWidget {
  final Function onTap;
  final PlaylistVo playlistVO;
  const PlaylistItemView({
    required this.playlistVO,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Todo: If thumbnail is null, show a default playlist thumbnail.
    final imageUrl = playlistVO.thumbnail ?? 'https://img.youtube.com/vi/e-ORhEE9VVg/maxresdefault.jpg';
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Row(
        children: [
          CustomCachedImage(
            imageUrl: imageUrl,
            cornerRadius: 10.h,
            width: context.isMobile() ? 99.w : 90.w,
            height: context.isMobile() ? 56.h : 65.h,
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
            child: PlaylistTitleAndTracksView(
              title: playlistVO.name,
              songCount: playlistVO.songList.length,
            ),
          ),
          PopupMenuButton<String>(
            padding: context.isMobile() ? EdgeInsets.zero : EdgeInsets.only(right: 20.w),
            icon: Icon(
              Icons.more_horiz,
              color: primaryColor,
              size: 24.h,
            ),
            elevation: 2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            onSelected: (value) async {
              context.read<LibraryBloc>().onStartRenamePlaylist(playlistVO.name);
              if (value == "rename") {
                showDialog(
                  context: context,
                  builder: (context) => AddRenamePlaylistDialog(
                    initialText: playlistVO.name,
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
                          Navigator.pop(context);
                          context.read<LibraryBloc>().onTapDeletePlaylist(playlistVO);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
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
    );
  }
}

class PlaylistTitleAndTracksView extends StatelessWidget {
  final String title;
  final int songCount;
  const PlaylistTitleAndTracksView({
    required this.title,
    required this.songCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          '$songCount Track'.calculateCountS(songCount),
          style: TextStyle(
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }
}
