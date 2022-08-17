import 'package:flutter/material.dart';
import 'package:music_app/utils/app_lifecycle_reactor.dart';
import 'package:music_app/utils/app_open_ads_manager.dart';

class AppOpenAdWidget extends StatefulWidget {
  final Widget child;
  const AppOpenAdWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<AppOpenAdWidget> createState() => _AppOpenAdWidgetState();
}

class _AppOpenAdWidgetState extends State<AppOpenAdWidget> {
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();

    final appOpenAdsManager = AppOpenAdsManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdsManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
