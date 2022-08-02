import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_app/resources/colors.dart';

extension NavigationUtil on Widget {
  void navigateToNextPageWithNavBar(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
  String calculateCountS(int count){
    if(count!=0){
      return 's';
    }
    return '';

  }
}

extension ToastMessage on Widget {
  // Todo: Customize toast message ui.
  Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      backgroundColor: primaryColor,
    );
  }
}
