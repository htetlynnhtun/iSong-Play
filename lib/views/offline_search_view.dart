import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:provider/provider.dart';

import '../widgets/song_item_view.dart';

class OfflineSearchView extends StatelessWidget {
  const OfflineSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SearchBloc, List<SongVO>>(
      selector: (_, searchBloc) => searchBloc.offlineSearchResults,
      builder: (_, songs, __) {
        return Expanded(
          child: ListView.separated(
            padding:  EdgeInsets.only(left: 16.w),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => context.read<PlayerBloc>().onTapSong(index, songs),
              child: SongItemView(
                songs[index],
                menus: const [
                  SongItemPopupMenu.addToQueue,
                  SongItemPopupMenu.addToPlaylist,
                ],
                havePlaceHolderImage: true,
              ),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: songs.length,
          ),
        );
      },
    );
  }
}
