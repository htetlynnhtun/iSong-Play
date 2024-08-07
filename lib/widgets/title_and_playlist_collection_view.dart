// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/pages/music_list_detail_page.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:music_app/vos/music_section_vo.dart';
import 'package:music_app/widgets/title_text.dart';
import 'package:provider/provider.dart';
import '../resources/dimens.dart';
import 'custom_cached_image.dart';
import '../utils/extension.dart';

class MusicSectionView extends StatelessWidget {
  final MusicSectionVO musicSectionVO;
  const MusicSectionView({
    required this.musicSectionVO,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleText(title: musicSectionVO.title),
        SizedBox(
          height: 8.h,
        ),
        SizedBox(
          height: 135.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final musicList = musicSectionVO.musicLists[index];
              return GestureDetector(
                onTap: () async {
                  try {
                    final songs = await context.read<PlayerBloc>().onTapMusicList(musicList.playlistId);
                      navigateToNextPageWithNavBar(
                        context,
                        MusicListDetailPage(
                          songs: songs,
                          musicListVO: musicList,
                        ),
                      );
                  } catch (error) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(error as String),
                          actions: [
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () {
                                context.read<PlayerBloc>().onDismissNetworkErrorDialog();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: PlayListImageView(
                  musicListVO: musicList,
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              width: 14.w,
            ),
            itemCount: musicSectionVO.musicLists.length,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

class PlayListImageView extends StatelessWidget {
  final MusicListVO musicListVO;
  const PlayListImageView({
    required this.musicListVO,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCachedImage(
      havePlaceHolderImage: true,
      imageUrl: musicListVO.thumbnail,
      width: 135.h,
      height: 135.h,
      cornerRadius: cornerRadius,
    );
  }
}
