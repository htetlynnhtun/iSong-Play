import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/home_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/pages/trend_detail.dart';
import 'package:music_app/resources/constants.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:music_app/vos/music_section_vo.dart';
import 'package:music_app/widgets/asset_image_button.dart';
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
          height: 155.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final musicList = musicSectionVO.musicLists[index];
              return GestureDetector(
                onTap: () async {
                  final songs = await context.read<PlayerBloc>().onTapMusicList(musicList.playlistId);
                  final data = {
                    "songs": songs,
                    "title": musicList.title,
                    "thumbnail": musicList.thumbnail,
                  };
                  // Todo: Route to MusicList page.
                  navigateToNextPageWithNavBar(context, TrendDetailPage(data: data));
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
      width: 145.h,
      height: 145.h,
      cornerRadius: cornerRadius,
    );
  }
}
