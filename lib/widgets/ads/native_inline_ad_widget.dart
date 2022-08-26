import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:music_app/utils/ad_mob_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NativeInlineAdWidget extends StatefulWidget {
  const NativeInlineAdWidget({Key? key}) : super(key: key);

  @override
  State<NativeInlineAdWidget> createState() => _NativeInlineAdWidgetState();
}

class _NativeInlineAdWidgetState extends State<NativeInlineAdWidget> {
  NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();

    NativeAd(
      adUnitId: AdMobHelper.nativeUnitId,
      factoryId: "listTileNativeAd",
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('Native Inline Ad loaded.');
          setState(() {
            _nativeAd = ad as NativeAd;
          });
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          setState(() {
            _nativeAd = null;
          });
        },
        onAdImpression: (ad) => print('NativeAd impression.'),
      ),
    ).load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _nativeAd == null
        ? SizedBox(height: 10.h)
        : Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 16.h, top: 10.h, bottom: 10.h),
            width: MediaQuery.of(context).size.width - 32,
            height: 100,
            child: AdWidget(ad: _nativeAd!),
          );
  }
}
