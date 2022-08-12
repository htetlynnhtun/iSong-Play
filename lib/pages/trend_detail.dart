import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/widgets/custom_cached_image.dart';

import '../widgets/app_bar_back_icon.dart';

class TrendDetailPage extends StatelessWidget {
  const TrendDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: const AppBarBackIcon(),
            expandedHeight: 150.h,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "This is music title",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16.sp,
                ),
              ),
              background: const CustomCachedImage(
                  imageUrl:
                      'https://i.pinimg.com/originals/c9/89/19/c98919abf17fd86146255f74d04ec113.jpg',
                  cornerRadius: 0),
            ),
          ),
        ],
        body: ListView.separated(
            itemBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 50.h,
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                ),
            separatorBuilder: (context, index) => SizedBox(
                  height: 16.h,
                ),
            itemCount: 100),
      ),
    );
  }
}
