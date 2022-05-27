import 'package:flutter/material.dart';
import 'package:music_app/services/youtube_service.dart';
import 'package:music_app/vos/song_vo.dart';

class SearchBloc extends ChangeNotifier {
  final _youtubeService = YoutubeService();
  // ========================= States =========================
  int slidingValue = 0;
  // Todo: Just dummy, real data will come from hive.
  var recentSearches = [
    "Search one this is fucking long text for recent search",
    "Search two",
    "Search three",
    "Search four",
    "Search five",
  ];
  var suggestions = <String>[];
  var searchResults = <SongVO>[];
  var searchQuery = "";
  var currentContentView = SearchContent.recent;
  var showClearButton = false;
  var tappedQuery = "";
  var showSearchingLoadingIndicator = false;

  // ========================= UI Callbacks =========================
  void onSlidingValueChange(int value) {
    slidingValue = value;
    notifyListeners();
  }

  void onSearchQueryChange(String query) async {
    searchQuery = query;
    if (searchQuery.isEmpty) {
      currentContentView = SearchContent.recent;
      showClearButton = false;
    } else {
      currentContentView = SearchContent.suggestion;
      showClearButton = true;
      suggestions = await _youtubeService.getSuggestion(query);
    }
    notifyListeners();
  }

  Future<void> onSearchSubmitted() async {
    if (searchQuery.isNotEmpty) {
      currentContentView = SearchContent.result;
      recentSearches.add(searchQuery);
      showSearchingLoadingIndicator = true;
      notifyListeners();
      searchResults = await _youtubeService.getSongs(searchQuery);
      showSearchingLoadingIndicator = false;
      notifyListeners();
    }
  }

  Future<void> onTapRecentOrSuggestion(String query) async {
    tappedQuery = query;
    searchResults = [];
    currentContentView = SearchContent.result;
    recentSearches.add(query);
    showSearchingLoadingIndicator = true;
    notifyListeners();
    searchResults = await _youtubeService.getSongs(query);
    showSearchingLoadingIndicator = false;
    notifyListeners();
  }

  void onTapClearAllRecent() {
    // Todo: delete from hive
    recentSearches.clear();
    notifyListeners();
  }

  void onTapDeleteRecent(String recent) {
    // Todo: delete from hive
    final index = recentSearches.indexOf(recent);
    recentSearches.removeAt(index);
    notifyListeners();
  }

  void clearQuery() {
    searchQuery = "";
    showClearButton = false;
    currentContentView = SearchContent.recent;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _youtubeService.dispose();
  }
}

enum SearchContent {
  recent,
  suggestion,
  result,
}
