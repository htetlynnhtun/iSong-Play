import 'package:flutter/material.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/pages/playlist_detail_page.dart';
import 'package:music_app/pages/songs_detail_page.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/vos/playlist_vo.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/library_header_view.dart';
import 'package:provider/provider.dart';

import '../views/playlist_bottom_sheet.dart';
import '../widgets/add_rename_playlist_dialog.dart';
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
            TitleAndSettingIconButtonView(
              title: 'Library',
              onTap: () {
                // showModalBottomSheet(
                //   isDismissible: true,
                //   backgroundColor: Colors.transparent,
                //   useRootNavigator: true,
                //   context: context,
                //   builder: (context) => const PlaylistBottomSheet(),
                // );
              },
              imageUrl: 'assets/images/ic_setting.png',
            ),
            const SizedBox(
              height: 30,
            ),
            const YourSongAndFavouriteHeaderView(),
            const SizedBox(
              height: 28,
            ),
            TitleAndSettingIconButtonView(
              title: 'Playlist',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddRenamePlaylistDialog(
                    onAdd: context.read<LibraryBloc>().onTapAddPlaylist,
                    title: "Playlist Name",
                    onTapTitle: "Add",
                  ),
                );
              },
              imageUrl: 'assets/images/ic_add.png',
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: Selector<LibraryBloc, List<PlaylistVo>>(
                selector: (_, libraryBloc) => libraryBloc.playlists,
                shouldRebuild: (_, __) => true,
                builder: (_, playlists, __) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final playlistVo = playlists[index];
                        return PlaylistItemView(
                          playlistVO: playlistVo,
                          onTap: () {
                            context.read<LibraryBloc>().onViewPlaylistDetail(playlistVo);
                            navigateToNextPageWithNavBar(
                              context,
                              const PlaylistDetailPage(),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemCount: playlists.length);
                },
              ),
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
    return Selector<LibraryBloc, List<SongVO>>(
      selector: (_, libraryBloc) => libraryBloc.songs,
      shouldRebuild: (_, __) => true,
      builder: (_, songs, __) {
        return Row(
          children: [
            LibraryHeaderView(
              title: 'Your Song',
              songs: songs.length,
              imageUrl: 'assets/images/ic_library.png',
              onTap: () {
                navigateToNextPageWithNavBar(
                  context,
                  const SongsDetailPage(
                    title: 'Your Song',
                    isFavorite: false,
                  ),
                );
              },
            ),
            const SizedBox(
              width: 16,
            ),
            LibraryHeaderView(
              title: 'Favorite',
              songs: songs.where((e) => e.isFavorite).length,
              imageUrl: 'assets/images/ic_library_favorite.png',
              onTap: () {
                navigateToNextPageWithNavBar(
                  context,
                  const SongsDetailPage(
                    title: 'Favorite',
                    isFavorite: true,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
