import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/home_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/pages/setting_page.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/vos/music_section_vo.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/title_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../resources/dimens.dart';
import '../widgets/custom_cached_image.dart';
import '../widgets/title_and_icon_view.dart';
import '../widgets/title_and_playlist_collection_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 16.w,
              ),
              child: TitleAndSettingIconButtonView(
                title: 'Home',
                onTap: () {
                  navigateToNextPageWithNavBar(context,const SettingPage());
                },
                imageUrl: 'assets/images/ic_setting.png',
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            const BannerView(),
            SizedBox(
              height: 8.h,
            ),
            Selector<HomeBloc, List<SongVO>>(
              selector: (_, homeBloc) => homeBloc.recentTracks,
              builder: (_, recentTracks, __) {
                if (recentTracks.isEmpty) {
                  return const SizedBox();
                } else {
                  return RecentTracksView(recentTracks);
                }
              },
            ),
            Visibility(
              // ToDo : handle later with location
              visible: false,
              child: SizedBox(
                height: 8.h,
              ),
            ),
            Visibility(
              // ToDo : handle later with location
              visible: false,
              child: MusicSectionView(
                musicSectionVO: MusicSectionVO("Editor Choice", []),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Selector<HomeBloc, List<MusicSectionVO>>(
              selector: (_, homeBloc) => homeBloc.musicSections,
              builder: (_, sections, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sections
                      .map((section) =>
                          MusicSectionView(musicSectionVO: section))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BannerView extends StatelessWidget {
  const BannerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<HomeBloc, int>(
      selector: (context, bloc) => bloc.pageIndex,
      builder: (_, pageIndex, __) => SizedBox(
        height: 180.h,
        width: double.infinity,
        child: Selector<HomeBloc, List<SongVO>>(
            selector: (_, homeBloc) => homeBloc.trendingSongs,
            builder: (_, songs, __) {
              return Stack(
                children: [
                  if (songs.isNotEmpty)
                    Positioned.fill(
                      child: CarouselSlider.builder(
                        itemCount: songs.length,
                        itemBuilder: (_, itemIndex, __) => GestureDetector(
                          onTap: () {
                            // if offline, show alert
                            context
                                .read<PlayerBloc>()
                                .onTapSong(itemIndex, songs);
                          },
                          child: BannerImageAndSongNameView(
                            songVO: songs[itemIndex],
                          ),
                        ),
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              context
                                  .read<HomeBloc>()
                                  .onBannerPageChanged(index);
                            }),
                      ),
                    ),
                  if (songs.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h, right: 20.w),
                        child: DotsIndicator(
                          dotsCount: songs.length,
                          position: pageIndex.toDouble(),
                          decorator: DotsDecorator(
                            color: Colors.white
                                .withOpacity(0.38), // Inactive color
                            activeColor: primaryColor,
                            size: Size(6.h, 6.h),
                            activeSize: Size(6.h, 6.h),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
      ),
    );
  }
}

class BannerImageAndSongNameView extends StatelessWidget {
  final SongVO songVO;
  const BannerImageAndSongNameView({
    required this.songVO,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: CustomCachedImage(
              imageUrl: songVO.thumbnail,
              cornerRadius: cornerRadius,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(cornerRadius),
                bottomRight: Radius.circular(cornerRadius),
              ),
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  bannerGradientEndColor,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: BannerTitleAndArtistView(songVO),
        ),
      ],
    );
  }
}

class BannerTitleAndArtistView extends StatelessWidget {
  final SongVO songVO;

  const BannerTitleAndArtistView(
    this.songVO, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, bottom: 22.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: Text(
              songVO.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            songVO.artist,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentTracksView extends StatelessWidget {
  final List<SongVO> recentTracks;
  const RecentTracksView(this.recentTracks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleText(title: 'Recent Tracks'),
        SizedBox(
          height: 8.h,
        ),
        SizedBox(
          height: 115.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => GestureDetector(
              onTap: () =>
                  context.read<PlayerBloc>().onTapSong(index, recentTracks),
              child: TracksAndTitleView(recentTracks[index]),
            ),
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemCount: recentTracks.length,
          ),
        ),
      ],
    );
  }
}

class TracksAndTitleView extends StatelessWidget {
  final SongVO track;
  const TracksAndTitleView(this.track, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCachedImage(
          imageUrl: track.thumbnail,
          width: 80.h,
          height: 80.h,
          cornerRadius: recentTracksCornerRadius,
        ),
        SizedBox(
          height: 6.h,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 90),
          child: Text(
            track.title,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}
