import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/asset_image_button.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../views/playback_timer_dialog.dart';
import '../views/sleep_timer_dialog.dart';
import '../views/up_next_view.dart';
import '../widgets/app_bar_back_icon.dart';
import '../widgets/marquee_text.dart';
import '../widgets/menu_item_button.dart';
import '../widgets/up_next_button.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PlayerBloc, SongVO?>(
      selector: (context, playerBloc) => playerBloc.nowPlayingSong,
      builder: (context, nowPlayingSong, _) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  nowPlayingSong?.dominantColor.first?.withOpacity(0.9) ?? defaultPlayerColor.withOpacity(0.5),
                  nowPlayingSong?.dominantColor.last?.withOpacity(0.5) ?? defaultPlayerColor.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 1],
                tileMode: TileMode.decal),
          ),
          child: const PlayerDetailView()),
    );
  }
}

class PlayerDetailView extends StatelessWidget {
  const PlayerDetailView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarBackIcon(
          color: Colors.white,
        ),
        title: Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.isMobile() ? 20.h : 54.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Selector<PlayerBloc, String?>(
                  selector: (_, playerBloc) => playerBloc.currentSongThumbnail,
                  builder: (_, imageUrl, __) {
                    return CustomCachedImage(
                      imageUrl: imageUrl.toString(),
                      width: 340.w,
                      height: 170.h,
                      cornerRadius: cornerRadius,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 42.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Selector<PlayerBloc, List<String?>>(
                  selector: (_, playerBloc) => [
                    playerBloc.currentSongTitle,
                    playerBloc.currentSongArtist,
                  ],
                  builder: (_, titleAndArtist, __) {
                    final title = titleAndArtist[0] ?? "Title";
                    final artist = titleAndArtist[1] ?? "Artist";
                    return TitleArtistAndDownloadButtonView(
                      title: title,
                      artist: artist,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 42.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: const SongSeekBarAndDurationView(),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: const PlayerIconsCollectionView(),
              ),
              const SizedBox(
                height: 42,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: const FavoriteAndTimerView(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(backgroundColor: Colors.transparent, context: context, builder: (context) => const UpNextView());
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 38.h),
                  child: const UpNextButton(
                    iconUrl: 'assets/images/ic_up_next.png',
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class FavoriteAndTimerView extends StatelessWidget {
  const FavoriteAndTimerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Selector<PlayerBloc, SongVO?>(
            selector: (_, playerBloc) => playerBloc.nowPlayingSong,
            shouldRebuild: (_, __) => true,
            builder: (_, nowPlayingSong, __) {
              if (nowPlayingSong?.isDownloadFinished ?? false) {
                return AssetImageButton(
                  onTap: () => context.read<LibraryBloc>().onTapFavorite(nowPlayingSong!),
                  width: 26.h,
                  height: 26.h,
                  imageUrl: nowPlayingSong!.isFavorite ? 'assets/images/ic_favorite_done.png' : 'assets/images/ic_favorite.png',
                  color: nowPlayingSong.isFavorite ? null : Colors.white.withOpacity(0.9),
                );
              }
              return Container();
            }),
        const Spacer(),
        Selector<PlayerBloc, bool>(
            selector: (_, playerBloc) => playerBloc.isTimerActive,
            builder: (_, isTimerActive, __) {
              return AssetImageButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => isTimerActive ? const PlaybackTimerDialog() : const SleepTimerDialog(),
                  );
                },
                width: 26.h,
                height: 26.h,
                imageUrl: isTimerActive ? 'assets/images/ic_timer_done.png' : 'assets/images/ic_timer.png',
                color: isTimerActive ? null : Colors.white.withOpacity(0.9),
              );
            }),
      ],
    );
  }
}

class PlayerIconsCollectionView extends StatelessWidget {
  const PlayerIconsCollectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Selector<PlayerBloc, bool>(
          selector: (_, playerBloc) => playerBloc.isShuffleModeEnabled,
          builder: (_, isShuffleModeEnabled, __) {
            return AssetImageButton(
              onTap: context.read<PlayerBloc>().shuffle,
              width: 26.h,
              height: 26.h,
              imageUrl: 'assets/images/ic_shuffle.png',
              color: isShuffleModeEnabled ? primaryColor : Colors.white,
            );
          },
        ),
        const Spacer(),
        Row(
          children: [
            Selector<PlayerBloc, bool>(
                selector: (_, playerBloc) => playerBloc.isFirstSong,
                builder: (_, isFirstSong, __) {
                  return AssetImageButton(
                    onTap: () {
                      if (!isFirstSong) {
                        context.read<PlayerBloc>().skipToPrevious();
                      }
                    },
                    width: 38.h,
                    height: 38.h,
                    imageUrl: 'assets/images/ic_previous.png',
                    color: Colors.white,
                  );
                }),
            SizedBox(
              width: 32.w,
            ),
            Selector<PlayerBloc, ButtonState>(
              selector: (_, playerBloc) => playerBloc.buttonState,
              builder: (_, buttonState, __) {
                VoidCallback onTap;
                String imageUrl;

                if (buttonState == ButtonState.loading) {
                  return SizedBox(
                    width: 64.h,
                    height: 64.h,
                    child: CupertinoActivityIndicator(
                      color: primaryColor,
                      radius: 16.h,
                    ),
                  );
                }

                switch (buttonState) {
                  case ButtonState.loading:
                    onTap = () {};
                    // Todo: Swap with loading icon
                    imageUrl = 'assets/images/ic_pause_circle.png';
                    break;
                  case ButtonState.playing:
                    onTap = context.read<PlayerBloc>().pause;
                    imageUrl = "assets/images/ic_pause_circle.png";
                    break;
                  case ButtonState.paused:
                    onTap = context.read<PlayerBloc>().play;
                    imageUrl = "assets/images/ic_play_circle.png";
                    break;
                }
                return AssetImageButton(
                  onTap: onTap,
                  width: 62.h,
                  height: 62.h,
                  imageUrl: imageUrl,
                  color: Colors.white,
                );
              },
            ),
            SizedBox(
              width: 32.w,
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
                  width: 38.h,
                  height: 38.h,
                  imageUrl: 'assets/images/ic_next.png',
                  color: Colors.white,
                );
              },
            ),
          ],
        ),
        const Spacer(),
        Selector<PlayerBloc, RepeatState>(
            selector: (_, playerBloc) => playerBloc.repeatState,
            builder: (_, repeatState, __) {
              String imageUrl;
              Color? color;
              switch (repeatState) {
                case RepeatState.off:
                  // Todo: Swap with repeat off image
                  imageUrl = "assets/images/ic_repeat.png";
                  color = Colors.white;
                  break;
                case RepeatState.one:
                  // Todo: Swap with repeat one image
                  imageUrl = "assets/images/ic_repeat_one.png";
                  color = primaryColor;
                  break;
                case RepeatState.playlist:
                  imageUrl = "assets/images/ic_repeat.png";
                  color = primaryColor;
                  break;
              }
              return AssetImageButton(
                onTap: context.read<PlayerBloc>().repeat,
                width: 26.h,
                height: 26.h,
                imageUrl: imageUrl,
                color: color,
                // color: (true) ? primaryColor : Colors.white,
              );
            }),
      ],
    );
  }
}

class SongSeekBarAndDurationView extends StatelessWidget {
  const SongSeekBarAndDurationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PlayerBloc, ProgressBarState>(
        selector: (_, playerBloc) => playerBloc.progressBarState,
        builder: (_, progressBarState, __) {
          return ProgressBar(
            progress: progressBarState.current,
            buffered: progressBarState.buffered,
            total: progressBarState.total,
            progressBarColor: primaryColor,
            baseBarColor: seekBarBackgroundColor,
            bufferedBarColor: Colors.grey,
            thumbColor: primaryColor,
            thumbGlowRadius: 0,
            barHeight: 5.0,
            thumbRadius: 6.0,
            onSeek: context.read<PlayerBloc>().onSeek,
            timeLabelTextStyle: TextStyle(
              color: seekBarBackgroundColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          );
        });
  }
}

class TitleArtistAndDownloadButtonView extends StatelessWidget {
  final String title;
  final String artist;

  const TitleArtistAndDownloadButtonView({
    required this.title,
    required this.artist,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MarqueeText(
                title: title,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 40.w,
        ),
        const Visibility(
          visible: false,
          child: DownloadProcessView(),
        ),
      ],
    );
  }
}

class DownloadProcessView extends StatelessWidget {
  const DownloadProcessView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PlayerBloc, SongVO?>(
      selector: (_, playerBloc) => playerBloc.nowPlayingSong,
      shouldRebuild: (_, __) => true,
      builder: (_, nowPlayingSong, __) {
        if (nowPlayingSong == null) {
          return const SizedBox();
        }

        if (nowPlayingSong.isDownloadFinished) {
          return AssetImageButton(
            width: 30.h,
            height: 30.h,
            imageUrl: 'assets/images/ic_downloaded.png',
            onTap: () {},
            color: Colors.white.withOpacity(0.9),
          );
        }

        return Selector<LibraryBloc, String?>(
          selector: (_, libraryBloc) => libraryBloc.activeDownloadIDs.firstWhere((element) => element == nowPlayingSong.id, orElse: () => null),
          builder: (_, id, __) {
            if (id == null) {
              return AssetImageButton(
                onTap: () => context.read<LibraryBloc>().onTapDownload(nowPlayingSong),
                width: 30.h,
                height: 30.h,
                imageUrl: 'assets/images/ic_download.png',
                color: Colors.white.withOpacity(0.9),
              );
            } else {
              if (nowPlayingSong.percent == 0) {
                return const CupertinoActivityIndicator(radius: 6);
              } else {
                return CircularPercentIndicator(
                  radius: 22.0,
                  lineWidth: 4.5,
                  percent: nowPlayingSong.percent,
                  center: Text(
                    '${(nowPlayingSong.percent * 100).toStringAsFixed(0)} %',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 10.sp,
                    ),
                  ),
                  backgroundColor: searchIconColor,
                  progressColor: primaryColor,
                );
              }
            }
          },
        );
      },
    );
  }
}
