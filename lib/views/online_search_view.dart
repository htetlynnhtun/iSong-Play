import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/vos/recent_search_vo.dart';
import 'package:music_app/vos/song_vo.dart';
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
    return Selector<SearchBloc, bool>(
        selector: (_, searchBloc) => searchBloc.showSearchingLoadingIndicator,
        builder: (_, showSearchingLoadingIndicator, __) {
          if (showSearchingLoadingIndicator) {
            return const Expanded(
              child: Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 16,
                  color: primaryColor,
                ),
              ),
            );
          }
          return Expanded(
            child: Selector<SearchBloc, List<SongVO>>(
                selector: (_, searchBloc) => searchBloc.searchResults,
                builder: (_, searchResults, __) {
                  return ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => context.read<PlayerBloc>().onTapSong(index, searchResults),
                      child: SongItemView(
                        searchResults[index],
                        menus: const [
                          SongItemPopupMenu.addToQueue,
                          SongItemPopupMenu.addToLibrary,
                          SongItemPopupMenu.addToPlaylist,
                        ],
                        isSearch: true,
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemCount: searchResults.length,
                  );
                }),
          );
        });
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
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  // Todo: Add loading indicator
                  // show loading
                  await context.read<SearchBloc>().onTapRecentOrSuggestion(suggestions[index]);
                  // stop loading
                },
                child: RecentAndSuggestionView(
                  title: suggestions[index],
                  isRecent: false,
                ),
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
            child: Selector<SearchBloc, List<RecentSearchVO>>(
              selector: (_, searchBloc) => searchBloc.recentSearches.reversed.toList(),
              builder: (_, recentSearches, __) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final title = recentSearches[index].query;
                    return GestureDetector(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await context.read<SearchBloc>().onTapRecentOrSuggestion(title);
                      },
                      child: RecentAndSuggestionView(title: title),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
                  itemCount: recentSearches.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
