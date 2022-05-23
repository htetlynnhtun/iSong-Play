import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_app/blocs/home_bloc.dart';
import 'package:music_app/resources/constants.dart';
import 'package:music_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../resources/dimens.dart';
import 'custom_cached_image.dart';

class TitleAndPlayListCollectionView extends StatelessWidget {
  const TitleAndPlayListCollectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const TitleText(title: 'Trending'),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => PlaylistAndPlayerView(
                    imageUrl: bannerImage[index],
                  ),
              separatorBuilder: (context, index) => const SizedBox(
                    width: 8,
                  ),
              itemCount: bannerImage.length),
        )
      ],
    );
  }
}

class PlaylistAndPlayerView extends StatelessWidget {
  final String imageUrl;
  const PlaylistAndPlayerView({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomCachedImage(
            imageUrl: imageUrl,
            width: 175,
            height: 175,
            cornerRadius: cornerRadius,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8, left: 8),
          child: BackgroundBlurAndTracksView(),
        ),
        const Align(
            alignment: Alignment.bottomCenter,
            child: GradientBackgroundAndPlayerView()),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SongTitleAndPlayerIconView(),
          ),
        )
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: const [
        //     Text(
        //       'This is Title',
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //     SizedBox(height: 8,),
        //     Text(
        //       'This is Artist',
        //       style: TextStyle(
        //         fontSize: 12,
        //       ),
        //     ),
        //   ],
        // ),
        // Spacer(),
      ],
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
