import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/asset_image_button.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:music_app/widgets/playlist_default_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import 'marquee_text.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PlayerBloc, SongVO?>(
      selector: (context, playerBloc) => playerBloc.nowPlayingSong,
      builder: (context, nowPlayingSong, _) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                nowPlayingSong?.dominantColor.first?.withOpacity(0.7) ??
                    searchIconColor,
                nowPlayingSong?.dominantColor.first?.withOpacity(0.9) ??
                    searchIconColor,
              ],
            ),
          ),
          child: const MiniPlayerView()),
    );
  }
}

class MiniPlayerView extends StatelessWidget {
  const MiniPlayerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      color: Colors.transparent,
      child: Selector<PlayerBloc, SongVO?>(
          selector: (_, playerBloc) => playerBloc.nowPlayingSong,
          builder: (_, nowPlayingSong, __) {
            final imageUrl = nowPlayingSong?.thumbnail;
            final title = nowPlayingSong?.title ?? "Title";
            final artist = nowPlayingSong?.artist ?? "Artist";

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageUrl != null
                    ? CustomCachedImage(
                        imageUrl: imageUrl,
                        cornerRadius: 5.h,
                        width: 44.h,
                        height: 44.h,
                      )
                    : PlaylistDefaultView(
                        width: 44.h, cornerRadius: 5.h, scale: 15, height: 44.h),
                SizedBox(
                  width: 14.w,
                ),
                Expanded(
                  child: TitleAndArtistView(
                    title: title,
                    artist: artist,
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Selector<PlayerBloc, double>(
                    selector: (_, playerBloc) =>
                        playerBloc.circularProgressPercentage,
                    builder: (_, percent, __) {
                      return CircularPercentIndicator(
                        radius: 18.h,
                        lineWidth: 4.h,
                        percent: percent,
                        center: Selector<PlayerBloc, ButtonState>(
                          selector: (_, playerBloc) => playerBloc.buttonState,
                          builder: (_, buttonState, __) {
                            final currentSongID =
                                context.read<PlayerBloc>().currentSongID;
                            switch (buttonState) {
                              case ButtonState.loading:
                                if (currentSongID == nowPlayingSong?.id) {
                                  return CupertinoActivityIndicator(
                                    radius: 9.r,
                                    animating: true,
                                    color: homePlaylistPlayerCircleColor,
                                  );
                                } else {
                                  return PlayPauseButton(
                                    icon: Icons.play_arrow,
                                    onTap: context.read<PlayerBloc>().play,
                                  );
                                }

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
                        backgroundColor: homePlaylistPlayerCircleColor,
                        progressColor: primaryColor,
                      );
                    }),
                SizedBox(
                  width: 18.w,
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
                        width: 24.h,
                        height: 24.h,
                        imageUrl: 'assets/images/ic_next.png',
                        color: homePlaylistPlayerCircleColor,
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
        size: 18.h,
        color: homePlaylistPlayerCircleColor,
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
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
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
          style: TextStyle(
            fontSize: 9.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
