import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../resources/constants.dart';
import '../widgets/asset_image_button.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
           SizedBox(
            height: 8.h,
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: SearchAndCancelView(),
          ),
           SizedBox(
            height: 6.h,
          ),
          const OnlineAndOfflineSlidingView(),
        ],
      ),
    );
  }
}

class OnlineAndOfflineSlidingView extends StatelessWidget {
  const OnlineAndOfflineSlidingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SearchBloc, int>(
      selector: (context, bloc) => bloc.slidingValue,
      builder: (context, slidingValue, _) => Expanded(
        child: Column(
          children: [
            Container(
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              width: double.infinity,
              height: 34.h,
              child: CupertinoSlidingSegmentedControl<int>(
                backgroundColor: searchBackgroundColor,
                thumbColor: CupertinoColors.white,
                groupValue: slidingValue,
                onValueChanged: (value) {
                  context.read<SearchBloc>().onSlidingValueChange(value!);
                },
                children:  {
                  0: Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: primaryColor,
                    ),
                  ),
                  1: Text(
                    'Offline',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: primaryColor,
                    ),
                  ),
                },
              ),
            ),
             SizedBox(
              height: 14.h,
            ),
            searchViewList[slidingValue],
          ],
        ),
      ),
    );
  }
}

class SearchAndCancelView extends StatelessWidget {
  final searchController = TextEditingController();

  SearchAndCancelView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 32.h,
            child: Selector<SearchBloc, String>(
                selector: (_, searchBloc) => searchBloc.tappedQuery,
                builder: (_, tappedQuery, __) {
                  searchController.text = tappedQuery;
                  return TextField(
                    controller: searchController,
                    onSubmitted: (value) {
                      context.read<SearchBloc>().onSearchSubmitted();
                    },
                    onChanged: (value) {
                      context.read<SearchBloc>().onSearchQueryChange(value);
                    },
                    style:  TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    // autofocus: true,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      filled: true,
                      fillColor: searchBackgroundColor,
                      prefixIcon:  Icon(
                        Icons.search,
                        size: 30.h,
                        color: searchIconColor,
                      ),
                      suffixIcon: Selector<SearchBloc, bool>(
                        selector: (_, searchBloc) => searchBloc.showClearButton,
                        builder: (_, showClearButton, child) {
                          return Visibility(
                            visible: showClearButton,
                            child: child!,
                          );
                        },
                        child: AssetImageButton(
                          onTap: () {
                            searchController.clear();
                            context.read<SearchBloc>().clearQuery();
                          },
                          width: 16.h,
                          height: 16.h,
                          imageUrl: 'assets/images/ic_clear.png',
                          color: null,
                        ),
                      ),
                      hintText: 'Artist, Song and more',
                      hintStyle:  TextStyle(
                        color: searchIconColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.h),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
         SizedBox(
          width: 6.w,
        ),
        TextButton(
            onPressed: () {
              searchController.clear();
              FocusManager.instance.primaryFocus?.unfocus();
              context.read<SearchBloc>().clearQuery();
            },
            child:  Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
              ),
            )),
      ],
    );
  }
}
