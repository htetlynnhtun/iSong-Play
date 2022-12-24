import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:media_info/media_info.dart';
import 'package:mp3_info/mp3_info.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/persistance/dummy_dao.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:path_provider/path_provider.dart';

import '../persistance/song_dao.dart';

class DummyBloc extends ChangeNotifier {
  final DummyDAO _songDao = DummyDAO();
  List<SongVO> songs = [];

  DummyBloc() {
    _songDao.watchItems().listen((event) {
      songs = event;
      notifyListeners();
    });
  }

  void onTapPlus(FilePickerResult result) async {
    List<PlatformFile> files = result.files.map((file) => file).toList();
    _writeSong(files).then((value) {
      _songDao.saveItems(value);
    });
  }

  Future<List<SongVO>> _writeSong(List<PlatformFile> files) async {
    final directory = await getApplicationSupportDirectory();
    return files.map((songFile) {
      var file = File("${directory.path}/${songFile.name}");
      file.writeAsBytesSync(songFile.bytes!);
      MP3Info mp3 = MP3Processor.fromFile(file);
      String id = songFile.size.toString();
      return SongVO(
          createdAt: DateTime.now(),
          id: id,
          title: songFile.name,
          artist: 'local',
          thumbnail: '',
          duration: mp3.duration,
          filePath: "file://${file.path}",
          dominantColor: [primaryColor, primaryColor],
          isFavorite: true)
        ..isDownloadFinished = true;
    }).toList();
  }
}
