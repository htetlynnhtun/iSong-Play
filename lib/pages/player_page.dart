import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/resources/dimens.dart';
import 'package:music_app/widgets/asset_image_button.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
            children: const [
              SizedBox(
                height: 64,
              ),
              Align(
                alignment: Alignment.center,
                child: CustomCachedImage(
                  imageUrl:
                      'https://img.youtube.com/vi/O2CIAKVTOrc/maxresdefault.jpg',
                  width: 360,
                  height: 200,
                  cornerRadius: cornerRadius,
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: TitleArtistAndDownloadButtonView(),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: SongSeekBarAndDurationView(),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: PlayerIconsCollectionView(),
              ),
              SizedBox(
                height: 42,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: FavoriteAndTimerView(),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.black,
                      context: context,
                      builder: (context) => const UpNextView());
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
            imageUrl: (true)
                ? 'assets/images/ic_favorite_done.png'
                : 'assets/images/ic_favorite.png',
            color: null),
        const Spacer(),
        AssetImageButton(
            onTap: () {},
            width: 36,
            height: 36,
            imageUrl: (true)
                ? 'assets/images/ic_timer_done.png'
                : 'assets/images/ic_timer.png',
            color: null),
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
        AssetImageButton(
            onTap: () {},
            width: 32,
            height: 32,
            imageUrl: 'assets/images/ic_shuffle.png',
            color: (true) ? primaryColor : Colors.white),
        const Spacer(),
        Row(
          children: [
            AssetImageButton(
                onTap: () {},
                width: 42,
                height: 42,
                imageUrl: 'assets/images/ic_previous.png',
                color: Colors.white),
            const SizedBox(
              width: 42,
            ),
            AssetImageButton(
                onTap: () {},
                width: 80,
                height: 80,
                imageUrl: (true)
                    ? 'assets/images/ic_play_circle.png'
                    : 'assets/images/ic_pause_circle.png',
                color: Colors.white),
            const SizedBox(
              width: 42,
            ),
            AssetImageButton(
                onTap: () {},
                width: 42,
                height: 42,
                imageUrl: 'assets/images/ic_next.png',
                color: Colors.white),
          ],
        ),
        const Spacer(),
        AssetImageButton(
            onTap: () {},
            width: 32,
            height: 32,
            imageUrl: 'assets/images/ic_loop.png',
            color: (true) ? primaryColor : Colors.white),
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
    return ProgressBar(
      progress: const Duration(minutes: 1),
      buffered: Duration.zero,
      total: const Duration(minutes: 3),
      progressBarColor: primaryColor,
      baseBarColor: seekBarBackgroundColor,
      bufferedBarColor: Colors.grey,
      thumbColor: primaryColor,
      thumbGlowRadius: 0,
      barHeight: 5.0,
      thumbRadius: 6.0,
      onSeek: (duration) {},
      timeLabelTextStyle: const TextStyle(
        color: seekBarBackgroundColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              MarqueeText(
                title:
                    'Hello world this is fucking long title Hello world this is fucking long title',
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'This is artist name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
            child: AssetImageButton(
                onTap: () {},
                width: 36,
                height: 36,
                imageUrl: 'assets/images/ic_download.png',
                color: searchIconColor),
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
