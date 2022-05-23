import 'package:flutter/material.dart';
import 'package:music_app/resources/constants.dart';
import 'package:music_app/services/donminant_color.dart';

class HomeBloc extends ChangeNotifier {
  // ========================= States =========================
  int pageIndex = 0;
  Color? beginColor, endColor;

  HomeBloc() {
    DominantColor.getDominantColor(bannerImage[2]).then((value) {
      beginColor = value.first;
      endColor = value.last;
      notifyListeners();
    });
  }

  // ========================= UI Callbacks =========================
  void onBannerPageChanged(int index) {
    pageIndex = index;
    notifyListeners();
  }
}
