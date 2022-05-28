import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/utils/cast_extensions.dart';

class YoutubeService {
  final _dio = Dio();
  final _yt = YoutubeExplode();

  static final _singleton = YoutubeService._internal();
  YoutubeService._internal();
  factory YoutubeService() {
    return _singleton;
  }

  void dispose() {
    _dio.close();
    _yt.close();
  }

  Future<List<String>> getSuggestion(String query) async {
    const baseUrl = "https://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=";
    final endpoint = Uri.parse(baseUrl + query);
    try {
      final response = await _dio.getUri<String>(endpoint);
      if (response.statusCode != 200) {
        return [];
      }
      // final data = response.data!.split(",[")[1];
      // final result = data.substring(0, data.length - 1).split(",").map((e) => e.substring(1, e.length - 1)).toList();
      final result = (jsonDecode(response.data!)[1] as List).map((e) => e as String).toList();
      return result;
    } catch (error) {
      return [];
    }
  }

  Future<List<SongVO>> getSongs(String query) async {
    final searchQuery = await SearchQuery.search(YoutubeHttpClient(), query);
    final searchVideos = searchQuery.content.whereType<SearchVideo>().where((video) => !video.isLive).take(10);
    final songs = <SongVO>[];
    for (var video in searchVideos) {
      final song = await video.toSongVO();
      songs.add(song);
    }

    return songs;
    // return SearchQuery.search(YoutubeHttpClient(), query).then((value) {
    //   return value.content.whereType<SearchVideo>().where((video) => !video.isLive).take(10).map((e) => e.toSongVO()).toList();
    // });
  }
}
