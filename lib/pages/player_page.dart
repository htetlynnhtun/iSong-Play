import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/widgets/asset_image_button.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../views/up_next_view.dart';
import '../widgets/app_bar_back_icon.dart';
import '../widgets/marquee_text.dart';
import '../widgets/menu_item_button.dart';
import '../widgets/up_next_button.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarBackIcon(
          color: Colors.white,
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            elevation: 2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            onSelected: (value) {
              // TODO: handle menu button action
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'test',
                child: MenuItemButton(
                  title: 'Add to Library',
                  icon: Icons.add,
                ),
              ),
              const PopupMenuItem(
                value: 'test',
                child: MenuItemButton(
                  title: 'Add to Library',
                  icon: Icons.add,
                ),
              ),
              const PopupMenuItem(
                value: 'test',
                child: MenuItemButton(
                  title: 'Add to Library',
                  icon: Icons.add,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 64,
              ),
              Align(
                alignment: Alignment.center,
                child: Selector<PlayerBloc, String>(
                    selector: (_, playerBloc) => playerBloc.currentSongThumbnail ?? "https://img.youtube.com/vi/O2CIAKVTOrc/maxresdefault.jpg",
                    builder: (_, thumbnail, __) {
                      return CustomCachedImage(
                        imageUrl: thumbnail,
                        width: 360,
                        height: 200,
                        cornerRadius: cornerRadius,
                      );
                    }),
              ),
              const SizedBox(
                height: 48,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: TitleArtistAndDownloadButtonView(),
              ),
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: SongSeekBarAndDurationView(),
              ),
              const SizedBox(
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: PlayerIconsCollectionView(),
              ),
              const SizedBox(
                height: 42,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: FavoriteAndTimerView(),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(backgroundColor: Colors.black, context: context, builder: (context) => const UpNextView());
                },
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 46),
                  child: UpNextButton(
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
        AssetImageButton(
            onTap: () {},
            width: 36,
            height: 36,
            imageUrl: (true) ? 'assets/images/ic_favorite_done.png' : 'assets/images/ic_favorite.png',
            color: null),
        const Spacer(),
        AssetImageButton(
            onTap: () {}, width: 36, height: 36, imageUrl: (true) ? 'assets/images/ic_timer_done.png' : 'assets/images/ic_timer.png', color: null),
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
              width: 32,
              height: 32,
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
                    width: 42,
                    height: 42,
                    imageUrl: 'assets/images/ic_previous.png',
                    color: Colors.white,
                  );
                }),
            const SizedBox(
              width: 42,
            ),
            Selector<PlayerBloc, ButtonState>(
              selector: (_, playerBloc) => playerBloc.buttonState,
              builder: (_, buttonState, __) {
                VoidCallback onTap;
                String imageUrl;
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
                  width: 80,
                  height: 80,
                  imageUrl: imageUrl,
                  color: Colors.white,
                );
              },
            ),
            const SizedBox(
              width: 42,
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
                  width: 42,
                  height: 42,
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
              switch (repeatState) {
                case RepeatState.off:
                  // Todo: Swap with repeat off image
                  imageUrl = "assets/images/ic_add.png";
                  break;
                case RepeatState.one:
                  // Todo: Swap with repeat one image
                  imageUrl = "assets/images/ic_back.png";
                  break;
                case RepeatState.playlist:
                  imageUrl = "assets/images/ic_loop.png";
                  break;
              }
              return AssetImageButton(
                onTap: context.read<PlayerBloc>().repeat,
                width: 32,
                height: 32,
                imageUrl: imageUrl,
                color: (true) ? primaryColor : Colors.white,
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
            timeLabelTextStyle: const TextStyle(
              color: seekBarBackgroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          );
        });
  }
}

class TitleArtistAndDownloadButtonView extends StatelessWidget {
  const TitleArtistAndDownloadButtonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Selector<PlayerBloc, List<String>>(selector: (_, playerBloc) {
            final title = playerBloc.currentSongTitle ?? "Title";
            final artist = playerBloc.currentSongArtist ?? "Artist";
            return [title, artist];
          }, builder: (_, titleAndArtist, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MarqueeText(
                  title: titleAndArtist[0],
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  titleAndArtist[1],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(
          width: 42,
        ),
        const DownloadProcessView()
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
    return (false)
        ? SizedBox(
            width: 36,
            height: 36,
            child: AssetImageButton(onTap: () {}, width: 36, height: 36, imageUrl: 'assets/images/ic_download.png', color: searchIconColor),
          )
        : CircularPercentIndicator(
            radius: 22.0,
            lineWidth: 4.5,
            percent: 0.2,
            center: const Text(
              '100 %',
              style: TextStyle(
                color: primaryColor,
                fontSize: 10,
              ),
            ),
            backgroundColor: searchIconColor,
            progressColor: primaryColor,
          );
  }
}
