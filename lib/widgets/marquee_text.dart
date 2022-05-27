import 'dart:core';
import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String title;
  const MarqueeText({Key? key, required this.title}) : super(key: key);

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late ScrollController scrollController;
  Duration animationDuration = const Duration(milliseconds: 3000);
  Duration backDuration = const Duration(milliseconds: 800);
  Duration pauseDuration = const Duration(milliseconds: 800);
  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: animationDuration,
            curve: Curves.ease);
      }
      await Future.delayed(pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(0.0,
            duration: backDuration, curve: Curves.easeOut);
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Text(widget.title,style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      ),),
    );
  }
}
