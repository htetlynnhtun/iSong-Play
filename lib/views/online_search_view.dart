import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/vos/recent_search_vo.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/widgets/ads/inline_banner_ad_widget.dart';
import 'package:music_app/widgets/song_item_view.dart';
import 'package:provider/provider.dart';

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
      builder: (_, showSearchingLoadingIndicator, child) {
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

        return child!;
      },
      child: Selector<SearchBloc, String?>(
        selector: (_, bloc) => bloc.errorMessage,
        builder: (_, errorMessage, child) {
          if (errorMessage != null) {
            Future.delayed(Duration.zero, () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(errorMessage),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          context.read<SearchBloc>().onDismissErrorDialog();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  );
                },
              );
            });
          }

          return child!;
        },
        child: Expanded(
          child: Selector<SearchBloc, List<SongVO>>(
              selector: (_, searchBloc) => searchBloc.searchResults,
              shouldRebuild: (p, n) => listEquals(p, n),
              builder: (_, searchResults, __) {
                return ListView.separated(
                  padding: EdgeInsets.only(left: 16.w, bottom: 10.h),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => context.read<PlayerBloc>().onTapSong(index, searchResults),
                    child: Selector<PlayerBloc, ButtonState>(
                        selector: (_, playerBloc) => playerBloc.buttonState,
                        builder: (context, buttonState, __) {
                          final songVO = searchResults[index];
                          final currentSongID = context.read<PlayerBloc>().currentSongID;
                          final isLoading = (songVO.id == currentSongID) && buttonState == ButtonState.loading;

                          return SongItemView(
                            songVO,
                            menus: const [
                              SongItemPopupMenu.addToQueue,
                              SongItemPopupMenu.addToLibrary,
                              SongItemPopupMenu.addToPlaylist,
                            ],
                            havePlaceHolderImage: true,
                            isLoading: isLoading,
                          );
                        }),
                  ),
                  separatorBuilder: (context, index) {
                    if (index == 4) {
                      return const InlineBannerAdWidget();
                    }
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                  itemCount: searchResults.length,
                );
              }),
        ),
      ),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
              separatorBuilder: (context, index) => SizedBox(
                height: 10.h,
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Recent searches ',
                  style: TextStyle(
                    fontSize: 13.sp,
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
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
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
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10.h,
                    ),
                    itemCount: recentSearches.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
