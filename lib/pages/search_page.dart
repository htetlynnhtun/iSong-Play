import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            SearchAndCancelView(),
            const SizedBox(
              height: 8,
            ),
            const OnlineAndOfflineSlidingView(),
          ],
        ),
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
            SizedBox(
              width: double.infinity,
              height: 36,
              child: CupertinoSlidingSegmentedControl<int>(
                backgroundColor: searchBackgroundColor,
                thumbColor: CupertinoColors.white,
                groupValue: slidingValue,
                onValueChanged: (value) {
                  context.read<SearchBloc>().onSlidingValueChange(value!);
                },
                children: const {
                  0: Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
                  1: Text(
                    'Offline',
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
                },
              ),
            ),
            const SizedBox(
              height: 20,
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
            height: 36,
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                context.read<SearchBloc>().onSearchSubmitted();
              },
              onChanged: (value) {
                context.read<SearchBloc>().onSearchQueryChange(value);
              },
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
              textAlignVertical: TextAlignVertical.center,
              // autofocus: true,
              decoration: InputDecoration(
                isCollapsed: true,
                filled: true,
                fillColor: searchBackgroundColor,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 32,
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
                    width: 20,
                    height: 20,
                    imageUrl: 'assets/images/ic_clear.png',
                    color: null,
                  ),
                ),
                hintText: 'Artist, Song and more',
                hintStyle: const TextStyle(
                  color: searchIconColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        TextButton(
            onPressed: () {
              searchController.clear();
              FocusManager.instance.primaryFocus?.unfocus();
              context.read<SearchBloc>().clearQuery();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 17,
                color: primaryColor,
              ),
            )),
      ],
    );
  }
}
