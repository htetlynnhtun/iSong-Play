import 'package:flutter/material.dart';

import '../resources/colors.dart';
import '../resources/dimens.dart';

class LibraryHeaderView extends StatelessWidget {
  final String title;
  final int songs;
  final String imageUrl;
  final Function onTap;
  const LibraryHeaderView(
      {required this.title,
      required this.songs,
      required this.imageUrl,
      required this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 2 - 24;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        child: Stack(
          children: [
            SizedBox(
                height: size * 0.7,
                width: size,
                child: Center(
                  child: Container(
                    width: size * 0.4,
                    height: size * 0.4,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: libraryHeadCircleColor,
                    ),
                    child: Center(
                      child: Image.asset(
                        imageUrl,
                        width: size*0.25,
                        height:  size*0.25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child:
                  TittleAndTracksView(size: size, title: title, songs: songs),
            )
          ],
        ),
      ),
    );
  }
}

class TittleAndTracksView extends StatelessWidget {
  final String title;
  final int songs;
  const TittleAndTracksView({
    Key? key,
    required this.size,
    required this.title,
    required this.songs,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.3,
      decoration:  BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(cornerRadius),
            bottomLeft: Radius.circular(cornerRadius),
          )),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '$songs Tracks',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
