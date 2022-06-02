// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/persistance/playlist_dao.dart';
import 'package:music_app/persistance/song_dao.dart';
import 'package:music_app/services/downloader_service.dart';
import 'package:music_app/vos/playlist_vo.dart';
import 'package:music_app/vos/song_vo.dart';

class LibraryBloc extends ChangeNotifier {
  final _songDao = SongDao();
  final _playlistDao = PlaylistDao();
  final _downloader = DownloaderService();

  LibraryBloc() {
    _songDao.watchItems().listen((data) {
      songs = data;
      songs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    });

    _playlistDao.watchItems().listen((data) {
      playlists = data;
      playlists.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    });
  }

  // ========================= States =========================
  var songs = <SongVO>[];
  var playlists = <PlaylistVo>[];
  var playlistName = "";
  PlaylistVo? currentPlaylistDetail;
}

extension UICallbacks on LibraryBloc {
  Future<AddToLibraryResult> onTapAddToLibrary(SongVO songVO) {
    final completer = Completer<AddToLibraryResult>();
    final songInHive = _songDao.getItem(songVO.id);

    if (songInHive == null) {
      _downloader.requestDownload(
        songVO,
        onProgress: (received, total) {
          if (total != -1) {
            songVO.percent = received / total;
            // notifyListeners();
          }
        },
        onDownloadFinished: (filePath) async {
          songVO.filePath = filePath;
          songVO.isDownloadFinished = true;
          await _songDao.saveItem(songVO);
          // notifyListeners();
          completer.complete(AddToLibraryResult.success);
        },
      );
    } else {
      completer.complete(AddToLibraryResult.alreadyInLibrary);
    }

    return completer.future;
  }

  void onTapFavorite(SongVO songVO) async {
    songVO.isFavorite = !songVO.isFavorite;
    await songVO.save();
  }

  void onPlaylistNameChanged(String name) {
    playlistName = name;
  }

  Future<SavePlaylistResult> onTapAddPlaylist() async {
    playlistName = playlistName.trim();

    if (playlistName.isEmpty) {
      return SavePlaylistResult.emptyName;
    }

    final anySameName = playlists.any((e) => e.name == playlistName);
    if (anySameName) {
      return SavePlaylistResult.sameName;
    } else {
      final newPlaylist = PlaylistVo(
        createdAt: DateTime.now(),
        name: playlistName,
      );
      await _playlistDao.saveItem(newPlaylist);
      playlistName = "";
      return SavePlaylistResult.success;
    }
  }

  void onStartRenamePlaylist(String oldName) {
    playlistName = oldName;
  }

  Future<SavePlaylistResult> onTapRenamePlaylist(String oldName) async {
    playlistName = playlistName.trim();

    if (playlistName.isEmpty) {
      return SavePlaylistResult.emptyName;
    }

    final playlist = playlists.singleWhere((e) => e.name == oldName);
    playlist.name = playlistName;
    await playlist.save();
    playlistName = "";
    return SavePlaylistResult.success;
  }

  void onTapCancelAddRenamePlaylist() {
    playlistName = "";
  }

  Future<void> onTapDeletePlaylist(PlaylistVo playlistVo) {
    return _playlistDao.deleteItem(playlistVo.id);
  }

  Future<AddToPlaylistResult> onTapAddToPlaylist(PlaylistVo playlistVo, SongVO songVO) async {
    final completer = Completer<AddToPlaylistResult>();

    if (playlistVo.songList.any((e) => e.id == songVO.id)) {
      completer.complete(AddToPlaylistResult.alreadyInPlaylist);
    } else {
      var songInHive = _songDao.getItem(songVO.id);
      if (songInHive == null) {
        _downloader.requestDownload(
          songVO,
          onProgress: (received, total) {
            if (total != -1) {
              songVO.percent = received / total;
              // notifyListeners();
            }
          },
          onDownloadFinished: (filePath) async {
            songVO.filePath = filePath;
            songVO.isDownloadFinished = true;
            await _songDao.saveItem(songVO);
            playlistVo.songList.add(songVO);
            playlistVo.thumbnail = songVO.thumbnail;
            await playlistVo.save();
            // notifyListeners();

            completer.complete(AddToPlaylistResult.success);
          },
        );
      } else {
        playlistVo.songList.add(songInHive);
        playlistVo.thumbnail = songInHive.thumbnail;
        await playlistVo.save();
        completer.complete(AddToPlaylistResult.success);
      }
    }

    return completer.future;
  }

  void onViewPlaylistDetail(PlaylistVo selected) {
    currentPlaylistDetail = selected;
    notifyListeners();
  }

  void sortAllSongsByTitle() {
    songs.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  void sortAllSongsByDate() {
    songs.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
    notifyListeners();
  }
}

enum AddToLibraryResult {
  success,
  alreadyInLibrary,
}

enum SavePlaylistResult {
  emptyName,
  sameName,
  success,
}

enum AddToPlaylistResult {
  alreadyInPlaylist,
  success,
}
