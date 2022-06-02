import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/asset_image_button.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import 'marquee_text.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      color: searchIconColor,
      child: Selector<PlayerBloc, SongVO?>(
          selector: (_, playerBloc) => playerBloc.nowPlayingSong,
          shouldRebuild: (_, __) => true,
          builder: (_, nowPlayingSong, __) {
            final imageUrl = nowPlayingSong?.thumbnail ?? "https://img.youtube.com/vi/O2CIAKVTOrc/maxresdefault.jpg";
            final title = nowPlayingSong?.title ?? "Title";
            final artist = nowPlayingSong?.artist ?? "Artist";

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomCachedImage(
                  imageUrl: imageUrl,
                  cornerRadius: 5,
                  width: 46,
                  height: 46,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: TitleAndArtistView(
                    title: title,
                    artist: artist,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                CircularPercentIndicator(
                  radius: 18.0,
                  lineWidth: 4.0,
                  percent: 0.0,
                  center: Selector<PlayerBloc, ButtonState>(
                    selector: (_, playerBloc) => playerBloc.buttonState,
                    builder: (_, buttonState, __) {
                      switch (buttonState) {
                        case ButtonState.loading:
                          return const CupertinoActivityIndicator(
                            radius: 10,
                            animating: true,
                            color: primaryColor,
                          );
                        case ButtonState.playing:
                          return PlayPauseButton(
                            icon: Icons.pause,
                            onTap: context.read<PlayerBloc>().pause,
                          );
                        case ButtonState.paused:
                          return PlayPauseButton(
                            icon: Icons.play_arrow,
                            onTap: context.read<PlayerBloc>().play,
                          );
                      }
                    },
                  ),
                  backgroundColor: const Color.fromRGBO(77, 88, 104, 1.0),
                  progressColor: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                Selector<PlayerBloc, bool>(
                    selector: (_, playerBloc) => playerBloc.isLastSong,
                    builder: (_, isLastSong, __) {
                      return AssetImageButton(
                        onTap: () {
                          if (!isLastSong) {
                            context.read<PlayerBloc>().skipToNext();
                          }
                        },
                        width: 28,
                        height: 28,
                        imageUrl: 'assets/images/ic_next.png',
                        color: Colors.white,
                      );
                    }),
              ],
            );
          }),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const PlayPauseButton({
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }
}

class TitleAndArtistView extends StatelessWidget {
  final String title;
  final String artist;
  const TitleAndArtistView({
    required this.title,
    required this.artist,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MarqueeText(
          title: title,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
