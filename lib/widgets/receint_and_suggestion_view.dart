import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:provider/provider.dart';

import 'asset_image_button.dart';

class RecentAndSuggestionView extends StatelessWidget {
  final String title;
  final bool isRecent;
  const RecentAndSuggestionView(
      {required this.title, this.isRecent = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/ic_search.png',
          color: Colors.black,
          height: 12.h,
          width: 12.h,
        ),
         SizedBox(
          width: 7.w,
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
        if (isRecent)
          AssetImageButton(
            onTap: () {
              context.read<SearchBloc>().onTapDeleteRecent(title);
            },
            width: 16.h,
            height: 16.h,
            imageUrl: 'assets/images/ic_clear.png',
            color: null,
          ),
      ],
    );
  }
}
