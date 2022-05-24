import 'package:flutter/material.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/widgets/library_header_view.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: const [
            SizedBox(
              height: 8,
            ),
            YourSongAndFavouriteHeaderView()
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
      children:  [
        LibraryHeaderView(
          title: 'Your Song',
          songs: 100,
          imageUrl: 'assets/images/ic_library.png',
          onTap: (){},
        ),
        const SizedBox(
          width: 16,
        ),
        LibraryHeaderView(
          title: 'Favourite',
          songs: 100,
          imageUrl: 'assets/images/ic_favourite.png',
          onTap: (){},
        ),
      ],
    );
  }
}
