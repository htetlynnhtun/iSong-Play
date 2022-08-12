// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:music_app/services/youtube_service.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:music_app/vos/song_vo.dart';

class MusicListDetailBloc extends ChangeNotifier {
  final _youtubeService = YoutubeService();

  // ========================= Statees =========================
  var selectedMusicList = MusicListVO.empty();
  var songs = <SongVO>[];
  var isLoadingSongs = false;
}

extension UICallbacks on MusicListDetailBloc {
  void onTapMusicList(MusicListVO musicListVO) {
    selectedMusicList = musicListVO;
    isLoadingSongs = true;

    notifyListeners();

    _youtubeService.getSongsOfMusicList(selectedMusicList.playlistId).then((value) {
      songs = value;
      isLoadingSongs = false;
      notifyListeners();
    });
  }
}
