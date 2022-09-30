import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'music_section_vo.g.dart';

@HiveType(typeId: musicSectionTypeId)
class MusicSectionVO extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final List<MusicListVO> musicLists;

  MusicSectionVO(this.title, this.musicLists);

  @override
  String toString() {
    return "Title - $title | lists - $musicLists";
  }
}
