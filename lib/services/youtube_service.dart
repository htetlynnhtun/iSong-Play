import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:music_app/vos/music_list_vo.dart';
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

  Future<List<SongVO>> getSongsByID(List<String> ids) async {
    final videos = await Future.wait(ids.map((id) => _yt.videos.get(id)));
    final songs = await Future.wait(videos.where((video) => !video.isLive).map((video) => video.toSongVO()));

    return songs;
  }

  Future<Result<String, Uri>> getLink(String id) async {
    try {
      final manifest = await _yt.videos.streams.getManifest(id).timeout(const Duration(seconds: 10));
      final url = manifest.audioOnly.firstWhere((audio) => audio.tag == 140).url;

      return Success(url);
    } on SocketException catch (_) {
      return const Error("Your device is offline");
    } on TimeoutException catch (_) {
      return const Error("Please check your internet connection and try again.");
    }
  }

  Future<MusicListVO> getMusicList(String playlistID) async {
    final videos = await _yt.playlists.getVideos(playlistID).take(10).toList();
    final metadata = await _yt.playlists.get(playlistID);
    // await for (var video in _yt.playlists.getVideos(playlistID)) {
    //   videos.add(video);
    // }
    final songs = await Future.wait(videos.where((video) => !video.isLive).map((video) => video.toSongVO()));

    return MusicListVO(
      title: metadata.title,
      playlistId: playlistID,
      thumbnail: metadata.thumbnails.standardResUrl,
      songCount: songs.length,
    );
  }

  Future<Result<String, List<SongVO>>> getSongsOfMusicList(String id) async {
    try {
      final videos = await _yt.playlists.getVideos(id).take(10).toList().timeout(const Duration(seconds: 10));
      final songs = await Future.wait(videos.where((video) => !video.isLive).map((video) => video.toSongVO())).timeout(const Duration(seconds: 10));

      return Success(songs);
    } on SocketException catch (_) {
      return const Error("Your device is offline");
    } on TimeoutException catch (_) {
      return const Error("Please check your internet connection and try again.");
    }
  }

  Future<Map<String, List>> getTrendingData() async {
    final Uri link = Uri.https(
      "www.youtube.com",
      "/music",
    );
    try {
      final response = await _dio.getUri(link);
      if (response.statusCode != 200) {
        return {};
      }
      final String searchResults = RegExp(r'(\"contents\":{.*?}),\"metadata\"', dotAll: true).firstMatch(response.data)![1]!;
      final Map data = json.decode('{$searchResults}') as Map;

      final List result =
          data['contents']['twoColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'] as List;

      final List headResult = data['header']['carouselHeaderRenderer']['contents'][0]['carouselItemRenderer']['carouselItems'] as List;

      final List shelfRenderer = result.map((element) {
        return element['itemSectionRenderer']['contents'][0]['shelfRenderer'];
      }).toList();

      final List finalResult = shelfRenderer.map((element) {
        if (element['title']['runs'][0]['text'].trim() != 'Highlights from Global Citizen Live') {
          return {
            'title': element['title']['runs'][0]['text'],
            'playlists': element['title']['runs'][0]['text'].trim() == 'Charts'
                ? formatChartItems(
                    element['content']['horizontalListRenderer']['items'] as List,
                  )
                : element['title']['runs'][0]['text'].toString().contains('Music Videos')
                    ? formatVideoItems(
                        element['content']['horizontalListRenderer']['items'] as List,
                      )
                    : formatItems(
                        element['content']['horizontalListRenderer']['items'] as List,
                      ),
          };
        } else {
          return null;
        }
      }).toList();

      final finalHeadResult = formatHeadItems(headResult);
      finalResult.removeWhere((element) => element == null);

      return {'body': finalResult, 'head': finalHeadResult};
    } catch (e) {
      return {};
    }
  }

  List formatVideoItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['gridVideoRenderer']['title']['simpleText'],
          'type': 'video',
          'description': e['gridVideoRenderer']['shortBylineText']['runs'][0]['text'],
          'count': e['gridVideoRenderer']['shortViewCountText']['simpleText'],
          'videoId': e['gridVideoRenderer']['videoId'],
          'firstItemId': e['gridVideoRenderer']['videoId'],
          'image': e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
          'imageMin': e['gridVideoRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageMedium': e['gridVideoRenderer']['thumbnail']['thumbnails'][1]['url'],
          'imageStandard': e['gridVideoRenderer']['thumbnail']['thumbnails'][2]['url'],
          'imageMax': e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List formatChartItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['gridPlaylistRenderer']['title']['runs'][0]['text'],
          'type': 'chart',
          'description': e['gridPlaylistRenderer']['shortBylineText']['runs'][0]['text'],
          'count': e['gridPlaylistRenderer']['videoCountText']['runs'][0]['text'],
          'playlistId': e['gridPlaylistRenderer']['navigationEndpoint']['watchEndpoint']['playlistId'],
          'firstItemId': e['gridPlaylistRenderer']['navigationEndpoint']['watchEndpoint']['videoId'],
          'image': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageMedium': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageStandard': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageMax': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List formatItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['compactStationRenderer']['title']['simpleText'],
          'type': 'playlist',
          'description': e['compactStationRenderer']['description']['simpleText'],
          'count': e['compactStationRenderer']['videoCountText']['runs'][0]['text'],
          'playlistId': e['compactStationRenderer']['navigationEndpoint']['watchEndpoint']['playlistId'],
          'firstItemId': e['compactStationRenderer']['navigationEndpoint']['watchEndpoint']['videoId'],
          'image': e['compactStationRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageMedium': e['compactStationRenderer']['thumbnail']['thumbnails'][0]['url'],
          'imageStandard': e['compactStationRenderer']['thumbnail']['thumbnails'][1]['url'],
          'imageMax': e['compactStationRenderer']['thumbnail']['thumbnails'][2]['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List<String> formatHeadItems(List itemsList) {
    try {
      return itemsList.map((e) => e['defaultPromoPanelRenderer']['navigationEndpoint']['watchEndpoint']['videoId'] as String).toList();
    } catch (e) {
      return List.empty();
    }
  }
}
