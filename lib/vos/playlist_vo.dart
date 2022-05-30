import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/persistance/song_dao.dart';
import 'package:music_app/vos/song_vo.dart';

part 'playlist_vo.g.dart';

@HiveType(typeId: playlistTypeId)
class PlaylistVo extends HiveObject {
  @HiveField(0)
  DateTime createdAt;

  @HiveField(1)
  String name;

  @HiveField(2)
  String thumbnail;

  @HiveField(3)
  HiveList<SongVO> songList = HiveList(SongDao().getBox());

  PlaylistVo({
    required this.createdAt,
    required this.name,
    required this.thumbnail,
  });
}
