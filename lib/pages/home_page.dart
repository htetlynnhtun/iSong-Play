import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/home_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/widgets/title_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../resources/constants.dart';
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
          children:  [
            const SizedBox(
              height: 8,
            ),
           TitleAndSettingIconButtonView(title: 'Home',onTap: (){},
           imageUrl: 'assets/images/ic_setting.png',
           ),
            const SizedBox(
              height: 16,
            ),
            const BannerView(),
            const SizedBox(
              height: 19,
            ),
            const RecentTracksView(),
            const SizedBox(
              height: 19,
            ),
             const TitleAndPlayListCollectionView(title: 'Editor Choice',),
            const SizedBox(
              height: 20,
            ),
            const TitleAndPlayListCollectionView(title: 'Trending',),
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
      builder: (_, pageIndex, __) => Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            CarouselSlider.builder(
              itemCount: bannerImage.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      GestureDetector(
                          onTap: () {
                            // TODO: play song
                          },
                          child: BannerImageAndSongNameView(
                            imageUrl: bannerImage[itemIndex],
                          )),
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    context.read<HomeBloc>().onBannerPageChanged(index);
                  }),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16, right: 14),
                child: DotsIndicator(
                  dotsCount: bannerImage.length,
                  position: pageIndex.toDouble(),
                  decorator: DotsDecorator(
                    color: Colors.white.withOpacity(0.38), // Inactive color
                    activeColor: primaryColor,
                    size: const Size(8, 8),
                    activeSize: const Size(8, 8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BannerImageAndSongNameView extends StatelessWidget {
  final String imageUrl;
  const BannerImageAndSongNameView({
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
            cornerRadius: cornerRadius,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
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
        const Align(
            alignment: Alignment.bottomLeft, child: BannerTitleAndArtistView()),
      ],
    );
  }
}

class BannerTitleAndArtistView extends StatelessWidget {
  const BannerTitleAndArtistView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'This is Title',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'This is Artist',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentTracksView extends StatelessWidget {
  const RecentTracksView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleText(title: 'Recent Tracks'),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 135,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (index, context) => const TractsAndTitleView(),
              separatorBuilder: (index, context) => const SizedBox(
                    width: 20,
                  ),
              itemCount: 20),
        ),
      ],
    );
  }
}

class TractsAndTitleView extends StatelessWidget {
  const TractsAndTitleView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomCachedImage(
          imageUrl: 'https://img.youtube.com/vi/tGvhJCkboms/maxresdefault.jpg',
          width: 90,
          height: 90,
          cornerRadius: cornerRadius,
        ),
        const SizedBox(
          height: 8,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 90),
          child: const Text(
            'သီချင်းခေါင်းစဉ်',
            maxLines: 1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}


