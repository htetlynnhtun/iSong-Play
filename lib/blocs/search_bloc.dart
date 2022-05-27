import 'package:flutter/material.dart';
import 'package:music_app/persistance/recent_search_dao.dart';
import 'package:music_app/services/youtube_service.dart';
import 'package:music_app/vos/recent_search_vo.dart';
import 'package:music_app/vos/song_vo.dart';

class SearchBloc extends ChangeNotifier {
  final _youtubeService = YoutubeService();
  final _recentSearchDao = RecentSearchDao();

  SearchBloc() {
    _recentSearchDao.watchItems().listen((data) {
      recentSearches = data;
      recentSearches.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notifyListeners();
    });
  }

  // ========================= States =========================
  var slidingValue = 0;
  var recentSearches = <RecentSearchVO>[];
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
      await _cacheRecentSearch(searchQuery);
      currentContentView = SearchContent.result;
      showSearchingLoadingIndicator = true;
      notifyListeners();
      searchResults = await _youtubeService.getSongs(searchQuery);
      showSearchingLoadingIndicator = false;
      notifyListeners();
    }
  }

  Future<void> onTapRecentOrSuggestion(String query) async {
    tappedQuery = query;
    await _cacheRecentSearch(query);
    searchResults = [];
    currentContentView = SearchContent.result;
    showSearchingLoadingIndicator = true;
    notifyListeners();
    searchResults = await _youtubeService.getSongs(query);
    showSearchingLoadingIndicator = false;
    notifyListeners();
  }

  Future<void> onTapClearAllRecent() async {
    await _recentSearchDao.deleteAll();
  }

  Future<void> onTapDeleteRecent(String recent) async {
    await _recentSearchDao.deleteItem(recent);
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

// ========================= Internal Logics =========================
extension InternalLogic on SearchBloc {
  Future<void> _cacheRecentSearch(String query) async {
    final savedItem = _recentSearchDao.getItem(query);
    if (savedItem == null) {
      await _recentSearchDao.saveItem(RecentSearchVO(
        createdAt: DateTime.now(),
        query: query,
      ));
    } else {
      savedItem.createdAt = DateTime.now();
      await savedItem.save();
    }
  }
}

enum SearchContent {
  recent,
  suggestion,
  result,
}
