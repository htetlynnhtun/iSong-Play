import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_app/blocs/home_bloc.dart';
import 'package:music_app/resources/constants.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:music_app/vos/music_section_vo.dart';
import 'package:music_app/widgets/asset_image_button.dart';
import 'package:music_app/widgets/title_text.dart';
import 'package:provider/provider.dart';
import '../resources/dimens.dart';
import 'custom_cached_image.dart';

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
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => PlaylistAndPlayerView(
              musicListVO: musicSectionVO.musicLists[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(
              width: 16,
            ),
            itemCount: musicSectionVO.musicLists.length,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class PlaylistAndPlayerView extends StatelessWidget {
  final MusicListVO musicListVO;
  const PlaylistAndPlayerView({
    required this.musicListVO,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomCachedImage(
            imageUrl: musicListVO.thumbnail,
            width: 175,
            height: 175,
            cornerRadius: cornerRadius,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8, left: 8),
          child: BackgroundBlurAndTracksView(),
        ),
        const Align(alignment: Alignment.bottomCenter, child: GradientBackgroundAndPlayerView()),
        const Align(
          alignment: Alignment.bottomCenter,
          child: SongTitleAndPlayerIconView(),
        ),
      ],
    );
  }
}

class SongTitleAndPlayerIconView extends StatelessWidget {
  const SongTitleAndPlayerIconView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 175,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'This is fucking long song Title ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'This is fucking long song Artist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AssetImageButton(
            onTap: () {},
            imageUrl: (true) ? 'assets/images/ic_play_circle.png' : 'assets/images/ic_pause_circle.png',
            color: null,
            height: 48,
            width: 48,
          )
        ],
      ),
    );
  }
}

class GradientBackgroundAndPlayerView extends StatelessWidget {
  const GradientBackgroundAndPlayerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bloc, _) => Container(
        height: 60,
        width: 175,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(cornerRadius),
            bottomLeft: Radius.circular(cornerRadius),
          ),
          gradient: LinearGradient(
              colors: [
                bloc.beginColor?.withOpacity(1) ?? const Color(0xffd283ff),
                bloc.endColor?.withOpacity(1) ?? const Color(0xffdeb2f5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 1],
              tileMode: TileMode.decal),
        ),
      ),
    );
  }
}

class BackgroundBlurAndTracksView extends StatelessWidget {
  const BackgroundBlurAndTracksView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          width: 70,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 12,
                  height: 12,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  '10 Tracks',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
