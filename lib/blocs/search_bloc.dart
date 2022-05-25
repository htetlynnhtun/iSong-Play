import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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
  var currentContentView = SearchContent.recent;
  var showClearButton = false;
  final _querySubject = BehaviorSubject.seeded("");
  final _notEmptyQuerySubject = PublishSubject();

  SearchBloc() {
    _listenQuerySubject();
    _listenNotEmptyQuerySubject();
  }

  void _listenQuerySubject() {
    _querySubject.listen((query) {
      if (query.isEmpty) {
        currentContentView = SearchContent.recent;
        showClearButton = false;
        notifyListeners();
      } else {
        _notEmptyQuerySubject.add(query);
      }
    });
  }

  void _listenNotEmptyQuerySubject() {
    _notEmptyQuerySubject.debounceTime(const Duration(seconds: 1)).listen((query) {
      currentContentView = SearchContent.suggestion;
      showClearButton = true;
      // Todo: call suggestionAPI
      print("Calling suggestionAPI for: $query");
      notifyListeners();
    });
  }

  // ========================= UI Callbacks =========================
  void onSlidingValueChange(int value) {
    slidingValue = value;
    notifyListeners();
  }

  void onSearchQueryChange(String query) {
    _querySubject.add(query);
  }

  void onSearchSubmitted() {
    final query = _querySubject.value;
    if (query.isNotEmpty) {
      currentContentView = SearchContent.result;
      recentSearches.add(query);
      // Todo: call searchAPI
      print("Calling searchAPI for: $query");
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
    _querySubject.add("");
  }
}

enum SearchContent {
  recent,
  suggestion,
  result,
}
