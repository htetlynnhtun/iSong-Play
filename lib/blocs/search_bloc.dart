// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:music_app/persistance/recent_search_dao.dart';
import 'package:music_app/persistance/song_dao.dart';
import 'package:music_app/services/youtube_service.dart';
import 'package:music_app/vos/recent_search_vo.dart';
import 'package:music_app/vos/song_vo.dart';

class SearchBloc extends ChangeNotifier {
  final _youtubeService = YoutubeService();
  final _recentSearchDao = RecentSearchDao();
  final _songDao = SongDao();

  SearchBloc() {
    _recentSearchDao.watchItems().listen((data) {
      recentSearches = data;
      recentSearches.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notifyListeners();
    });

    _songDao.watchItems().listen((_) {
      _syncResultsWithLibrary();
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
  var offlineSearchResults = <SongVO>[];
  String? errorMessage;

  // ========================= UI Callbacks =========================
  void onSlidingValueChange(int value) {
    slidingValue = value;
    notifyListeners();
  }

  void onSearchQueryChange(String query) async {
    searchQuery = query;
    if (searchQuery.isEmpty) {
      // For offline search
      offlineSearchResults = [];
      // For online search
      currentContentView = SearchContent.recent;
      showClearButton = false;
    } else {
      // for offline search
      offlineSearchResults = _songDao.getBox().values.where((song) => song.title.toLowerCase().contains(query.toLowerCase())).toList();
      // For online search
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
      await _startSearching(searchQuery);
      showSearchingLoadingIndicator = false;
      notifyListeners();
    }
  }

  Future<void> onTapRecentOrSuggestion(String query) async {
    tappedQuery = query;
    await _cacheRecentSearch(query);
    searchResults = [];
    currentContentView = SearchContent.result;
    showClearButton = true;
    showSearchingLoadingIndicator = true;
    notifyListeners();
    await _startSearching(query);
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
    tappedQuery = "";
    showClearButton = false;
    offlineSearchResults = [];
    currentContentView = SearchContent.recent;
    notifyListeners();
  }

  void onDismissErrorDialog() {
    errorMessage = null;
    clearQuery();
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

  Future<void> _startSearching(String query) async {
    // searchResults = await _youtubeService.getSongs(query);
    (await _youtubeService.getSongs(query)).when(
      (error) {
        errorMessage = error;
        searchResults = [];
        notifyListeners();
      },
      (songs) {
        searchResults = songs;
      },
    );
    _syncResultsWithLibrary();
  }

  void _syncResultsWithLibrary() {
    searchResults.asMap().forEach((index, resultSong) {
      final songInHive = _songDao.getItem(resultSong.id);
      if (songInHive != null) {
        searchResults[index] = songInHive;
      }
    });
  }
}

enum SearchContent {
  recent,
  suggestion,
  result,
}
