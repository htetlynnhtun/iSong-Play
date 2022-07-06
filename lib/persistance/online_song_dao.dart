import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/vos/song_vo.dart';

class OnlineSongDao {
  static final _singleton = OnlineSongDao._internal();
  OnlineSongDao._internal();
  factory OnlineSongDao() => _singleton;

  SongVO? getItem(String key) {
    return _box.get(key);
  }

  void saveItem(SongVO vo) {
    _box.put(vo.id, vo);
  }

  void deleteItem(SongVO vo) {
    _box.delete(vo.id);
  }

  Box<SongVO> get _box {
    return Hive.box(onlineSongBox);
  }
}
