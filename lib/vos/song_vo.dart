// import 'package:hive/hive.dart';

// part 'song_vo.g.dart';

// @HiveType(typeId: 1, adapterName: 'SongVOAdapter')
class SongVO {
  // @HiveField(0)
  String id;

  // @HiveField(1)
  String title;

  // @HiveField(2)
  String artist;

  // @HiveField(3)
  String thumbnail;

  // @HiveField(4)
  bool isDownloadFinished = false;

  // @HiveField(5)
  Duration duration;

  // @HiveField(6)
  String filePath;

  // @HiveField(7)
  DateTime createdAt;

  double percent = 0.0;
  bool isDownloadStarted = false;
  bool isDownloading = false;

  SongVO({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.duration,
    required this.filePath,
    required this.createdAt,
  });

  static SongVO dummySong() {
    return SongVO(
      id: "asdf",
      title: "Shake it off",
      artist: "Taylor Swift",
      thumbnail: "https://img.youtube.com/vi/e-ORhEE9VVg/maxresdefault.jpg",
      duration: Duration.zero,
      filePath: "",
      createdAt: DateTime.now(),
    );
  }
}
