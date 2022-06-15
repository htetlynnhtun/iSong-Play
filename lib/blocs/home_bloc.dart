import 'package:flutter/material.dart';
import 'package:music_app/persistance/music_section_dao.dart';
import 'package:music_app/persistance/trending_songs_dao.dart';
import 'package:music_app/resources/constants.dart';
import 'package:music_app/services/donminant_color.dart';
import 'package:music_app/services/youtube_service.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:music_app/vos/music_section_vo.dart';
import 'package:music_app/vos/song_vo.dart';

class HomeBloc extends ChangeNotifier {
  final _ytService = YoutubeService();
  final _trendingSongsDao = TrendingSongsDao();
  final _musicSectionDao = MusicSectionDao();
  // ========================= States =========================
  int pageIndex = 0;
  Color? beginColor, endColor;

  /// For carousel section
  var trendingSongs = <SongVO>[];
  var musicSections = <MusicSectionVO>[];

  HomeBloc() {
    _trendingSongsDao.watchItems().listen((data) {
      trendingSongs = data;
      notifyListeners();
    });

    _musicSectionDao.watchItems().listen((data) {
      musicSections = data;
      notifyListeners();
    });

    DominantColor.getDominantColor(bannerImage[2]).then((value) {
      beginColor = value.first;
      endColor = value.last;
      notifyListeners();
    });

    fetchTrendingData();
  }

  // ========================= UI Callbacks =========================
  void onBannerPageChanged(int index) {
    pageIndex = index;
    notifyListeners();
  }

  void fetchTrendingData() async {
    final data = await _ytService.getTrendingData();

    final sectionData = data["body"]!;
    final musicSectionItems = sectionData
        .map((e) {
          final title = e["title"];
          final playlistRaw = e["playlists"] as List;

          final musicLists = playlistRaw.where((e) => e["type"] == "playlist").map((e) {
            final title = e["title"] as String;
            final playlistID = e["playlistId"] as String;
            final image = e["imageStandard"] as String;
            final songCount = int.parse(e["count"]);

            return MusicListVO(
              title: title,
              playlistId: playlistID,
              thumbnail: image,
              songCount: songCount,
            );
          }).toList();

          return MusicSectionVO(title, musicLists);
        })
        .where((e) => e.musicLists.isNotEmpty)
        .toList();
    _musicSectionDao.saveAll(musicSectionItems);

    final trendingSongsIDs = data["head"] as List<String>;
    _trendingSongsDao.saveAll(await _ytService.getSongsByID(trendingSongsIDs));
  }
}
