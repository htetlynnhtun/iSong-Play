import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/persistance/box_names.dart';

part 'music_list_vo.g.dart';

@HiveType(typeId: musicListTypeId)
class MusicListVO extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String playlistId;

  @HiveField(2)
  final String thumbnail;

  @HiveField(3)
  final int songCount;

  MusicListVO({
    required this.title,
    required this.playlistId,
    required this.thumbnail,
    required this.songCount,
  });

  @override
  String toString() {
    return "Title - $title | ID - $playlistId";
  }
}
