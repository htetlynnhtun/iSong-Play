import 'package:flutter/material.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:provider/provider.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/widgets/custom_cached_image.dart';

import '../widgets/add_rename_playlist_dialog.dart';
import '../widgets/asset_image_button.dart';
import '../widgets/title_text.dart';

class PlaylistBottomSheet extends StatelessWidget {
  const PlaylistBottomSheet({Key? key}) : super(key: key);

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(
              height: 24,
            ),
            AddToPlaylistView(),
            // TODO : handle if playlist is empty
            if (false)
              SizedBox(
                height: 45,
              ),
            PlayListsView(),
          ],
        ),
      ),
    );
  }
}

class PlayListsView extends StatelessWidget {
  const PlayListsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => const PlayListItemView(),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
            itemCount: 10),
      ],
    );
  }
}

class PlayListItemView extends StatelessWidget {
  const PlayListItemView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomCachedImage(
          imageUrl: 'https://img.youtube.com/vi/mNEUkkoUoIA/maxresdefault.jpg',
          cornerRadius: 10,
          height: 56,
          width: 56,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'This is Playlist fucking long playlist name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                '100 Tracks',
                style: TextStyle(
                  fontSize: 14,
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
        Navigator.pop(context);
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
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
