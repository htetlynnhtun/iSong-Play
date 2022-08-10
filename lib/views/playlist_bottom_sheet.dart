import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/vos/playlist_vo.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:provider/provider.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:music_app/utils/extension.dart';

import '../widgets/add_rename_playlist_dialog.dart';
import '../widgets/asset_image_button.dart';
import '../widgets/title_text.dart';

class PlaylistBottomSheet extends StatelessWidget {
  final SongVO songVO;
  const PlaylistBottomSheet(this.songVO, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bottomSheetBackgroundColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      margin: const EdgeInsets.fromLTRB(25, 0, 25, 25),
      padding: const EdgeInsets.fromLTRB(32, 15, 32, 15),
      child: SingleChildScrollView(
        child: Selector<LibraryBloc, List<PlaylistVo>>(
            selector: (_, libraryBloc) => libraryBloc.playlists,
            builder: (_, playlists, __) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(
                    height: 22.h,
                  ),
                  const AddToPlaylistView(),
                  if (playlists.isEmpty)
                     SizedBox(
                      height: 43.h,
                    ),
                  PlayListsView(
                    songVO: songVO,
                    playlists: playlists,
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class PlayListsView extends StatelessWidget {
  final SongVO songVO;
  final List<PlaylistVo> playlists;
  const PlayListsView({
    required this.songVO,
    required this.playlists,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
       SizedBox(
        height: 22.h,
      ),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final playlistVo = playlists[index];
          return GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              final result = await context.read<LibraryBloc>().onTapAddToPlaylist(playlistVo, songVO);
              switch (result) {
                case AddToPlaylistResult.alreadyInPlaylist:
                  showToast("Song is already in the playlist");
                  break;
                case AddToPlaylistResult.success:
                  showToast("Successfully added to playlist");
                  break;
              }
            },
            child: PlayListItemView(playlistVo),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: playlists.length,
      ),
    ]);
  }
}

class PlayListItemView extends StatelessWidget {
  final PlaylistVo playlistVo;
  const PlayListItemView(this.playlistVo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = playlistVo.thumbnail ?? 'https://img.youtube.com/vi/mNEUkkoUoIA/maxresdefault.jpg';
    return Row(
      children: [
        CustomCachedImage(
          imageUrl: imageUrl,
          cornerRadius: 8.h,
          height: 52.h,
          width: 52.h,
        ),
         SizedBox(
          width: 6.h,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlistVo.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style:  TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.sp,
                  color: primaryColor,
                ),
              ),
               SizedBox(
                height: 4.h,
              ),
              Text(
                '${playlistVo.songList.length} Track'.calculateCountS(playlistVo.songList.length),
                style:  TextStyle(
                  fontSize: 13.sp,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddToPlaylistView extends StatelessWidget {
  const AddToPlaylistView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AddRenamePlaylistDialog(
            onAdd: context.read<LibraryBloc>().onTapAddPlaylist,
            title: "Playlist Name",
            onTapTitle: "Add",
          ),
        );
      },
      child: Row(
        children: [
          const TitleText(
            title: 'Add To Playlist',
          ),
          const Spacer(),
          Image.asset(
            'assets/images/ic_add.png',
            height: 14,
            width: 14,
            color: primaryColor,
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
