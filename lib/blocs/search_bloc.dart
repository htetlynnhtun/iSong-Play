import 'package:flutter/material.dart';

class SearchBloc extends ChangeNotifier {
  // ========================= States =========================
  int slidingValue = 0;
  // Todo: Just dummy, real data will come from hive.
  var recentSearches = [
    "Search one",
    "Search two",
    "Search three",
    "Search four",
    "Search five",
  ];
  // Todo: Just dummy, real data will come from api call.
  var suggestions = [
    "Sug 1",
    "Sug 2",
    "Sug 3",
    "Sug 4",
    "Sug 5",
  ];
  var searchQuery = "";
  var currentContentView = SearchContent.recent;
  var showClearButton = false;

  // ========================= UI Callbacks =========================
  void onSlidingValueChange(int value) {
    slidingValue = value;
    notifyListeners();
  }

  void onSearchQueryChange(String query) {
    searchQuery = query;
    if (searchQuery.isEmpty) {
      currentContentView = SearchContent.recent;
      showClearButton = false;
    } else {
      currentContentView = SearchContent.suggestion;
      showClearButton = true;
      // Todo: call suggestionAPI
    }
    notifyListeners();
  }

  void onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      searchQuery = query;
      currentContentView = SearchContent.result;
      recentSearches.add(searchQuery);
      // Todo: call searchAPI
      notifyListeners();
    }
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
}

enum SearchContent {
  recent,
  suggestion,
  result,
}
