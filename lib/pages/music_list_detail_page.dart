import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/music_list_detail_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:music_app/widgets/song_item_view.dart';
import 'package:provider/provider.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/custom_cached_image.dart';

import '../widgets/app_bar_back_icon.dart';

class MusicListDetailPage extends StatelessWidget {
  const MusicListDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final thumbnail = data["thumbnail"] as String;
    // final title = data["title"] as String;
    // final songs = data["songs"] as List<SongVO>;

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
            flexibleSpace: Selector<MusicListDetailBloc, MusicListVO>(
                selector: (_, bloc) => bloc.selectedMusicList,
                builder: (_, musicListVO, __) {
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      musicListVO.title,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    background: CustomCachedImage(imageUrl: musicListVO.thumbnail, cornerRadius: 0),
                  );
                }),
          ),
        ],
        body: Selector<MusicListDetailBloc, bool>(
          selector: (_, bloc) => bloc.isLoadingSongs,
          builder: (_, isLoadingSongs, child) {
            if (isLoadingSongs) {
              return const Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 16,
                  color: primaryColor,
                ),
              );
            } else {
              return child!;
            }
          },
          child: Selector<MusicListDetailBloc, List<SongVO>>(
            selector: (_, bloc) => bloc.songs,
            builder: (_, songs, __) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => context.read<PlayerBloc>().onTapSong(index, songs),
                    child: Selector<PlayerBloc, ButtonState>(
                      selector: (_, playerBloc) => playerBloc.buttonState,
                      builder: (context, buttonState, __) {
                        final songVO = songs[index];
                        final currentSongID = context.read<PlayerBloc>().currentSongID;
                        final isLoading = (songVO.id == currentSongID) && buttonState == ButtonState.loading;

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
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemCount: songs.length,
              );
            }
          ),
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
