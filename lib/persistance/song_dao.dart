import 'package:hive/hive.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/persistance/box_names.dart';

class SongDao {
  static final SongDao _singleton = SongDao._internal();

  SongDao._internal();
  factory SongDao() {
    return _singleton;
  }

  Stream<List<SongVO>> watchItems() {
    return getBox().watch().map((event) => _getAll()).startWith(_getAll());
  }

  Future<void> saveItem(SongVO song) {
    return getBox().put(song.id, song);
  }

  SongVO? getItem(String id) {
    return getBox().get(id);
  }

  Future<void> deleteItem(String id) {
    return getBox().delete(id);
  }

  Future<void> deleteAll() {
    return getBox().clear();
  }

  List<SongVO> _getAll() {
    return getBox().values.toList();
  }

  Box<SongVO> getBox() {
    return Hive.box<SongVO>(songBox);
  }
}
