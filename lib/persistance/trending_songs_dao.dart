import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/vos/song_vo.dart';

class TrendingSongsDao {
  static final _singleton = TrendingSongsDao._internal();
  TrendingSongsDao._internal();
  factory TrendingSongsDao() {
    return _singleton;
  }

  Stream<List<SongVO>> watchItems() {
    return _getBox().watch().map((event) => _getAll()).startWith(_getAll());
  }

  Future<void> saveAll(List<SongVO> items) async {
    await _getBox().clear();
    await _getBox().addAll(items);
  }

  List<SongVO> _getAll() {
    return _getBox().values.toList();
  }

  Box<SongVO> _getBox() {
    return Hive.box<SongVO>(trendingSongsBox);
  }
}
