import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:music_app/views/offline_search_view.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../resources/constants.dart';
import '../widgets/clear_button.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: const [
            SizedBox(
              height: 8,
            ),
            SearchAndCancelView(),
            SizedBox(
              height: 8,
            ),
            OnlineAndOfflineSlidingView(),
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
                  _getBloc(context).onSlidingValueChange(value!);
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

SearchBloc _getBloc(BuildContext context) {
  return Provider.of<SearchBloc>(context, listen: false);
}

class SearchAndCancelView extends StatelessWidget {
  const SearchAndCancelView({
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
              onSubmitted: (value) {
                // bloc.onSubmitted(value);
              },
              onChanged: (value) {
                //  bloc.onTextChane(value);
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
                suffixIcon: Visibility(
                  visible: true,
                  child: ClearButton(
                    onTap: () {},
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
            onPressed: () {},
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
