import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final bool isSearch;
  final String imageUrl;
  final double? width, height;
  final double cornerRadius;

  const CustomCachedImage(
      {required this.imageUrl,
      this.width,
      this.height,
      required this.cornerRadius,
      this.isSearch = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.3),
          borderRadius: BorderRadius.circular(cornerRadius),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => (isSearch)
          ? LogoImageView(width: width, height: height)
          : const Center(child: CircularProgressIndicator.adaptive()),
      errorWidget: (context, url, error) =>
          Center(child: LogoImageView(width: width, height: height)),
    );
  }
}

class LogoImageView extends StatelessWidget {
  const LogoImageView({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: width,
      height: height,
    );
  }
}
