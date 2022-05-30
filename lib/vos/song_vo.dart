import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';

part 'song_vo.g.dart';

@HiveType(typeId: songTypeId)
class SongVO {
  @HiveField(0)
  DateTime createdAt;

  @HiveField(1)
  String id;

  @HiveField(2)
  String title;

  @HiveField(3)
  String artist;

  @HiveField(4)
  String thumbnail;

  @HiveField(5)
  bool isDownloadFinished = false;

  @HiveField(6)
  Duration duration;

  @HiveField(7)
  String filePath;

  @HiveField(8)
  List<Color?> dominantColor;

  @HiveField(9)
  bool isFavorite;

  double percent = 0.0;
  bool isDownloadStarted = false;
  bool isDownloading = false;

  SongVO({
    required this.createdAt,
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.duration,
    required this.filePath,
    required this.dominantColor,
    required this.isFavorite,
  });

  static SongVO dummySong() {
    return SongVO(
      createdAt: DateTime.now(),
      id: "asdf",
      title: "Shake it off",
      artist: "Taylor Swift",
      thumbnail: "https://img.youtube.com/vi/e-ORhEE9VVg/maxresdefault.jpg",
      duration: Duration.zero,
      filePath: "",
      dominantColor: [],
      isFavorite: false,
    );
  }
}
