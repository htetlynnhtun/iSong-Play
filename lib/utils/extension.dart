import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_app/resources/colors.dart';
import 'package:url_launcher/url_launcher.dart';

extension NavigationUtil on Widget {
  void navigateToNextPageWithNavBar(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  Future<void> launchWebUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }
}

extension StringUtil on String {
  String calculateCountS(int count) {
    if (count != 0) {
      return '${this}s';
    }
    return this;
  }
}

extension SizeUtil on BuildContext {
  bool isMobile() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550;
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
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
