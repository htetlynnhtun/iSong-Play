import 'package:flutter/material.dart';
import 'package:music_app/pages/songs_detail_page.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/widgets/library_header_view.dart';

import '../widgets/add_playlist_name_dialog.dart';
import '../widgets/playlist_item_vew.dart';
import '../widgets/title_and_icon_view.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            TitleAndIconButtonView(
              title: 'Library',
              onTap: () {},
              imageUrl: 'assets/images/ic_setting.png',
            ),
            const SizedBox(
              height: 30,
            ),
            const YourSongAndFavouriteHeaderView(),
            const SizedBox(
              height: 28,
            ),
            TitleAndIconButtonView(
              title: 'Playlist',
              onTap: () {
                showDialog(context: context, builder: (context)=>const AddPlaylistNameDialog());
              },
              imageUrl: 'assets/images/ic_add.png',
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => PlaylistItemView(
                        onTap: () {},
                      ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                  itemCount: 10),
            )
          ],
        ),
      ),
    );
  }
}

class YourSongAndFavouriteHeaderView extends StatelessWidget {
  const YourSongAndFavouriteHeaderView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LibraryHeaderView(
          title: 'Your Song',
          songs: 100,
          imageUrl: 'assets/images/ic_library.png',
          onTap: () {
            navigateToNextPageWithNavBar(
                context,
                const SongsDetailPage(
                  title: 'Your Song',
                ));
          },
        ),
        const SizedBox(
          width: 16,
        ),
        LibraryHeaderView(
          title: 'Favorite',
          songs: 100,
          imageUrl: 'assets/images/ic_favorite.png',
          onTap: () {
            navigateToNextPageWithNavBar(
                context,
                const SongsDetailPage(
                  title: 'Favorite',
                ));
          },
        ),
      ],
    );
  }
}
