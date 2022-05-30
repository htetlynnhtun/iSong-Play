import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:queue/queue.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:music_app/utils/callback_typedefs.dart';

class DownloaderService {
  static final _singleton = DownloaderService._internal();

  factory DownloaderService() {
    return _singleton;
  }
  DownloaderService._internal();

  final _yt = YoutubeExplode();
  final _queue = Queue();

  Future<void> requestDownload(
    SongVO songVO, {
    required OnProgress onProgress,
    required OnDownloadFinished onDownloadFinished,
  }) async {
    _queue.add(() => _startDownload(songVO, onProgress, onDownloadFinished));
  }

  Future<void> _startDownload(
    SongVO songVO,
    OnProgress onProgress,
    OnDownloadFinished onDownloadFinished,
  ) async {
    final streamManifest = await _yt.videos.streamsClient.getManifest(songVO.id);
    final streamInfo = streamManifest.audioOnly.firstWhere((element) => element.tag == 140);
    final stream = _yt.videos.streamsClient.get(streamInfo);
    final dir = (await getApplicationSupportDirectory()).path;
    var file = File("$dir/${songVO.id}.mp4");
    var fileStream = file.openWrite();

    var totalBytes = streamInfo.size.totalBytes;
    var receivedBytes = 0;

    await for (final data in stream) {
      receivedBytes += data.length;
      fileStream.add(data);
      onProgress(receivedBytes, totalBytes);
    }

    await fileStream.flush();
    await fileStream.close();
    onDownloadFinished("file://${file.path}");
  }

  void dispose() {
    _yt.close();
  }
}