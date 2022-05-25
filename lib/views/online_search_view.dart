import 'package:flutter/material.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/widgets/custom_cached_image.dart';
import 'package:music_app/widgets/song_item_view.dart';
import 'package:provider/provider.dart';

import '../widgets/asset_image_button.dart';
import '../widgets/receint_and_suggestion_view.dart';

class OnlineSearchView extends StatelessWidget {
  const OnlineSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SearchBloc, SearchContent>(
        selector: (_, searchBloc) => searchBloc.currentContentView,
        builder: (_, searchContent, __) {
          switch (searchContent) {
            case SearchContent.recent:
              return const RecentSearchesView();
            case SearchContent.suggestion:
              return const SearchSuggestionsView();
            case SearchContent.result:
              return const SearchResultsView();
          }
        });
    //return const SearchSuggestionsView();
    //return const SearchResultsView();
  }
}

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) => SongItemView(
                title: 'This is fucking long song title text $index',
                artist: 'This is fucking long artist text name $index',
              ),
          separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
          itemCount: 10),
    );
  }
}

class SearchSuggestionsView extends StatelessWidget {
  const SearchSuggestionsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<SearchBloc, List<String>>(
          selector: (_, searchBloc) => searchBloc.suggestions,
          builder: (_, suggestions, __) {
            return ListView.separated(
              itemBuilder: (context, index) => RecentAndSuggestionView(
                title: suggestions[index],
                isRecent: false,
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
              itemCount: suggestions.length,
            );
          }),
    );
  }
}

class RecentSearchesView extends StatelessWidget {
  const RecentSearchesView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Recent searches ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: context.read<SearchBloc>().onTapClearAllRecent,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: Selector<SearchBloc, List<String>>(
                selector: (_, searchBloc) => searchBloc.recentSearches.reversed.toList(),
                builder: (_, recentSearches, __) {
                  return ListView.separated(
                    itemBuilder: (context, index) => RecentAndSuggestionView(
                      title: recentSearches[index],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemCount: recentSearches.length,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
