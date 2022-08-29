import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/utils/ad_mob_helper.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({Key? key}) : super(key: key);

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> with AutomaticKeepAliveClientMixin {
  NativeAd? _nativeAd;
  @override
  void initState() {
    super.initState();

    NativeAd(
      adUnitId: AdMobHelper.nativeUnitId,
      factoryId: 'adFactoryExample',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('Native Ad loaded.');
          setState(() {
            _nativeAd = ad as NativeAd;
          });
        },
        onAdFailedToLoad: (ad, _) {
          // Dispose the ad here to free resources.
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _nativeAd == null
        ? SizedBox(height: 10.h)
        : Container(
            padding: EdgeInsets.only(right: 16.h, top: 10.h, bottom: 10.h),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width - 32,
            height: 350,
            child: AdWidget(ad: _nativeAd!),
          );
  }
}
