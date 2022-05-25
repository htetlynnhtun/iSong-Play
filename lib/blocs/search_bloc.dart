import 'package:flutter/material.dart';

class SearchBloc extends ChangeNotifier{
  // ========================= States =========================
  int slidingValue = 0;


// ========================= UI Callbacks =========================
 void onSlidingValueChange(int value){
   slidingValue = value;
   notifyListeners();
 }

}