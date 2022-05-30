import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/persistance/song_dao.dart';
import 'package:music_app/services/downloader_service.dart';
import 'package:music_app/vos/song_vo.dart';

class LibraryBloc extends ChangeNotifier {
  final _songDao = SongDao();
  final _downloader = DownloaderService();

  LibraryBloc() {
    _songDao.watchItems().listen((data) {
      songs = data;
      songs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notifyListeners();
    });
  }

  // ========================= States =========================
  var songs = <SongVO>[];

  // ========================= UI Callbacks =========================
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
          print("wtbug: Download finished: filePath: ${songVO.filePath}");
          // notifyListeners();
          completer.complete(AddToLibraryResult.success);
        },
      );
    } else {
      completer.complete(AddToLibraryResult.alreadyInLibrary);
    }

    return completer.future;
  }
}

enum AddToLibraryResult {
  success,
  alreadyInLibrary,
}
