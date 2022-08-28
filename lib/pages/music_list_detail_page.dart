import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:music_app/widgets/ads/native_ad_widget.dart';
import 'package:music_app/widgets/song_item_view.dart';
import 'package:provider/provider.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/custom_cached_image.dart';

import '../widgets/app_bar_back_icon.dart';

class MusicListDetailPage extends StatelessWidget {
  final List<SongVO> songs;
  final MusicListVO musicListVO;
  const MusicListDetailPage(
      {Key? key, required this.songs, required this.musicListVO})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: const AppBarBackIcon(),
            expandedHeight: 150.h,
            floating: false,
            pinned: true,
            title: Text(
              musicListVO.title,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18.sp,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Stack(
                children: [
                  CustomCachedImage(
                      imageUrl: musicListVO.thumbnail, cornerRadius: 0),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            musicListDetailImageColor,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
        body: ListView.separated(
          padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => context.read<PlayerBloc>().onTapSong(index, songs),
              child: Selector<PlayerBloc, ButtonState>(
                selector: (_, playerBloc) => playerBloc.buttonState,
                builder: (context, buttonState, __) {
                  final songVO = songs[index];
                  final currentSongID =
                      context.read<PlayerBloc>().currentSongID;
                  final isLoading = (songVO.id == currentSongID) &&
                      buttonState == ButtonState.loading;

                  return SongItemView(
                    songVO,
                    menus: const [
                      SongItemPopupMenu.addToQueue,
                      SongItemPopupMenu.addToLibrary,
                      SongItemPopupMenu.addToPlaylist,
                    ],
                    havePlaceHolderImage: true,
                    isLoading: isLoading,
                  );
                },
              ),
            );
          },
          separatorBuilder: (context, index) {
            if (index == 1) {
              return const NativeAdWidget();
            }
            return SizedBox(height: 10.h);
          },
          itemCount: songs.length,
        ),
      ),
    );
  }
}

// final songVO = searchResults[index];
// final isLoading = (songVO.id == currentSongID) && buttonState == ButtonState.loading;

// return SongItemView(
//   songVO,
//   menus: const [
//     SongItemPopupMenu.addToQueue,
//     SongItemPopupMenu.addToLibrary,
//     SongItemPopupMenu.addToPlaylist,
//   ],
//   havePlaceHolderImage: true,
//   isLoading: isLoading,
// );
