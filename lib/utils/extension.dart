import 'package:flutter/material.dart';

extension NavigationUtil on Widget{
  void navigateToNextPageWithNavBar(BuildContext context,Widget page){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=>page)
    );
  }
}