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
import 'package:tuple/tuple.dart';

import '../widgets/app_bar_back_icon.dart';

class MusicListDetailPage extends StatelessWidget {
  const MusicListDetailPage({Key? key}) : super(key: key);

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
          child: Selector<MusicListDetailBloc, Tuple2<List<SongVO>, String?>>(
              selector: (_, bloc) => Tuple2(bloc.songs, bloc.errorMessage),
              builder: (_, tuple, __) {
                if (tuple.item2 != null) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tuple.item2!),
                        ElevatedButton(
                          onPressed: context.read<MusicListDetailBloc>().onTapRetry,
                          style: ElevatedButton.styleFrom(primary: primaryColor),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  itemBuilder: (context, index) {
                    final songs = tuple.item1;
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
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemCount: tuple.item1.length,
                );
              }),
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
