import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          print(innerBoxIsScrolled);
          return [
            SliverAppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: innerBoxIsScrolled
                  ? const AppBarBackIcon()
                  : const AppBarCircleBackIcon(),
              expandedHeight: 240.h,
              floating: false,
              pinned: true,
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
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                             musicDetailGradientEndColor,

                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                title: Text(
                  musicListVO.title,
                  style: TextStyle(
                    color: innerBoxIsScrolled ? primaryColor : Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),

            // SliverPersistentHeader(
            //   pinned: true,
            //   delegate: MyHeaderDelegate(
            //       title: musicListVO.title, imageUrl: musicListVO.thumbnail),
            // ),
          ];
        },
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

class AppBarCircleBackIcon extends StatelessWidget {
  const AppBarCircleBackIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
          color: bannerGradientEndColor, shape: BoxShape.circle),
      child:  const Center(
        child: AppBarBackIcon(color: Colors.white),
      ),
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String imageUrl;
  final String title;
  const MyHeaderDelegate({required this.imageUrl, required this.title});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    print(progress);
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: 1 - progress,
            child: CustomCachedImage(imageUrl: imageUrl, cornerRadius: 0),
          ),
          Positioned.fill(
              child: Opacity(
            opacity: 1 - progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    //Colors.transparent,
                    musicDetailGradientEndColor,
                    musicDetailGradientEndColor,
                  ],
                ),
              ),
            ),
          )),
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: EdgeInsets.lerp(
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              EdgeInsets.only(bottom: 8.h),
              progress,
            ),
            alignment: Alignment.lerp(
              Alignment.bottomCenter,
              Alignment.bottomCenter,
              progress,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: progress == 1 ? primaryColor : Colors.white,
                fontSize: 20.sp,
              ),
            ),
          ),
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: progress == 1
                ? Theme.of(context).appBarTheme.backgroundColor
                : Colors.transparent,
            // leading: Container(
            //   margin: EdgeInsets.only(left: 8.h),
            //   decoration: BoxDecoration(
            //     color: Colors.white.withOpacity(1 - progress),
            //     shape: BoxShape.circle,
            //   ),
            //   child: const Center(child: AppBarBackIcon()),
            // ),
            elevation: 0,
            leading: const AppBarBackIcon(),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 270.h;

  @override
  double get minExtent => 80.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
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
