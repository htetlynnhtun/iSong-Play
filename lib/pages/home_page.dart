import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:music_app/blocs/home_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/widgets/title_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../resources/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: const [
              SizedBox(
                height: 8,
              ),
              HomeTitleAndSettingIconView(),
              SizedBox(
                height: 16,
              ),
              BannerView(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTitleAndSettingIconView extends StatelessWidget {
  const HomeTitleAndSettingIconView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TitleText(title: 'Home'),
        const Spacer(),
        GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.settings,
              color: primaryColor,
            )),
      ],
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
        height: 200,
        width: double.infinity,
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
                    _getBloc(context).onBannerPageChanged(index);
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
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                stops: [0, 1],
                colors: [
                  Colors.transparent,
                  bannerGradientColor,
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

HomeBloc _getBloc(BuildContext context) {
  return Provider.of<HomeBloc>(context, listen: false);
}
