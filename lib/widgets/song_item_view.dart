import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_app/blocs/library_bloc.dart';
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
  const SongItemView(this.songVO,
      {this.isSearch = false, this.isUpNext = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCachedImage(width: 56, height: 56, imageUrl: songVO.thumbnail, isSearch: isSearch, cornerRadius: 10),
        const SizedBox(
          width: 8,
        ),

        Expanded(
            child: TitleArtistAndDownloadStatusView(
          title: songVO.title,
          artist: songVO.artist,
              isUpNext: isUpNext,
        )),
        if (true)
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
            switch (value) {
              case "library":
                final result = await context.read<LibraryBloc>().onTapAddToLibrary(songVO);
                switch (result) {
                  case AddToLibraryResult.success:
                    showToast("Successfully added to Library");
                    break;
                  case AddToLibraryResult.alreadyInLibrary:
                    showToast("Already in Library");
                }
                break;
              case "queue":
                print("add to queue");
                break;
              case "playlist":
                showModalBottomSheet(
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: true,
                  context: context,
                  builder: (context) => PlaylistBottomSheet(songVO),
                );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "library",
              child: MenuItemButton(
                title: 'Add to Library',
                icon: Icons.add,
              ),
            ),
            const PopupMenuItem(
              value: "queue",
              child: MenuItemButton(
                title: 'Add to Queue',
                icon: Icons.queue_music,
              ),
            ),
            const PopupMenuItem(
              value: "playlist",
              child: MenuItemButton(
                title: 'Add to Playlist',
                icon: Icons.playlist_add,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TitleArtistAndDownloadStatusView extends StatelessWidget {
  final bool isUpNext;
  const TitleArtistAndDownloadStatusView({
    Key? key,
    this.isUpNext = false,
    required this.title,
    required this.artist,
  }) : super(key: key);

  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
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
            (false)
                ? const CupertinoActivityIndicator(
                    radius: 6,
                  )
                : Image.asset(
                    'assets/images/ic_downloaded.png',
                    color: primaryColor,
                    scale: 4,
                  ),
            const SizedBox(
              width: 2,
            ),
            Expanded(
              child: Text(
                artist,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(
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
