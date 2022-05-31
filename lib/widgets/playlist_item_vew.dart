import 'package:flutter/material.dart';
import 'package:music_app/blocs/library_bloc.dart';
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
            cornerRadius: 10,
            width: 99,
            height: 56,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: PlaylistTitleAndTracksView(
              title: playlistVO.name,
              songCount: playlistVO.songList.length,
            ),
          ),
          PopupMenuButton<String>(
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
                    initialText: playlistVO.name,
                    onRename: (oldName) => context.read<LibraryBloc>().onTapRenamePlaylist(oldName),
                    title: "Playlist Name",
                    onTapTitle: "Rename",
                  ),
                );
              } else if (value == "delete") {
                await context.read<LibraryBloc>().onTapDeletePlaylist(playlistVO);
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          '$songCount Tracks ',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
