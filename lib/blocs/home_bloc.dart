import 'package:flutter/material.dart';

class HomeBloc extends ChangeNotifier{
  // ========================= States =========================
  int pageIndex =0;

  // ========================= UI Callbacks =========================
  void onBannerPageChanged(int index){
    pageIndex = index;
    notifyListeners();
  }
}