import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:music_app/main.dart';
import 'package:music_app/utils/ad_mob_helper.dart';

class InterstitialAdBloc {
  InterstitialAd? _interstitialAd;
  late VoidCallback _onDone;
  static const _interstitialCounter = "InterstitialCounter";

  InterstitialAdBloc() {
    _init();
    _loadAd();
  }

  void _init() async {
    final savedCounter = prefs.getInt(InterstitialAdBloc._interstitialCounter);
    if (savedCounter == null) {
      await prefs.setInt(InterstitialAdBloc._interstitialCounter, 0);
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }

  int get _counter {
    return prefs.getInt(InterstitialAdBloc._interstitialCounter) ?? 0;
  }

  set _counter(int value) {
    prefs.setInt(InterstitialAdBloc._interstitialCounter, value);
  }

  void onNewPageTransition() {
    _counter = _counter + 1;
  }

  void showAd({required VoidCallback onDone}) {
    _onDone = onDone;
    if (_counter > 3 && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      _onDone();

      // If device come back online, try loaidng new ad
      if (_interstitialAd == null) {
        _loadAd();
      }
    }
  }

  void _loadAd() {
    InterstitialAd.load(
      adUnitId: AdMobHelper.interUnitId,
      // adUnitId: AdMobHelper.interVideoUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _setCallBack(ad);
        },
        onAdFailedToLoad: (error) {
          print("Interstitial ad failed to load $error");
        },
      ),
    );
  }

  void _setCallBack(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => print('%ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _interstitialAd = null;
        _counter = 0;
        _onDone();
        _loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _interstitialAd = null;
        _onDone();
        _loadAd();
      },
      onAdImpression: (ad) => print('$ad impression occurred.'),
    );
  }
}
