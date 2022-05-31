import 'package:flutter/material.dart';
import 'package:music_app/widgets/asset_image_button.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomCachedImage(
            imageUrl:
                'https://img.youtube.com/vi/O2CIAKVTOrc/maxresdefault.jpg',
            cornerRadius: 5,
            width: 46,
            height: 46,
          ),
          const SizedBox(
            width: 16,
          ),
          const Expanded(child: TitleAndArtistView()),
          const SizedBox(width: 16,),
          CircularPercentIndicator(
            radius: 18.0,
            lineWidth: 4.0,
            percent: 0.0,
            center: const Icon(
              Icons.play_arrow,
              size: 20.0,
              color: Colors.white,
            ),
            backgroundColor: const Color.fromRGBO(77,88, 104, 1.0),
            progressColor: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          AssetImageButton(
              onTap: () {},
              width: 28,
              height: 28,
              imageUrl: 'assets/images/ic_next.png',
              color: Colors.white)
        ],
      ),
    );
  }
}

class TitleAndArtistView extends StatelessWidget {
  const TitleAndArtistView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: const [
        MarqueeText(
          title: 'Hello world this is fucking long title',
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          'This is artist name',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
