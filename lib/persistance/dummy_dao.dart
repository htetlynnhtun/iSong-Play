import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:rxdart/rxdart.dart';
import '../vos/song_vo.dart';

class DummyDAO {
  static final DummyDAO _singleton = DummyDAO._internal();

  DummyDAO._internal();
  factory DummyDAO() {
    return _singleton;
  }

  Future<void> saveItems(List<SongVO> songs) async {
    Map<String, SongVO> songsMap = {for (var song in songs) song.id: song};
    await getBox().putAll(songsMap);
  }

  Stream<List<SongVO>> watchItems() {
    return getBox().watch().map((event) => _getAll()).startWith(_getAll());
  }

  List<SongVO> _getAll() {
    return getBox().values.toList();
  }

  Future<void> deleteAll() {
    return getBox().clear();
  }

  Box<SongVO> getBox() {
    return Hive.box<SongVO>(dummyBox);
  }
}
