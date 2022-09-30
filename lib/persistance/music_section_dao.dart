import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/vos/music_section_vo.dart';

class MusicSectionDao {
  static final _singleton = MusicSectionDao._internal();

  MusicSectionDao._internal();

  factory MusicSectionDao() {
    return _singleton;
  }

  Stream<List<MusicSectionVO>> watchItems() {
    return _getBox().watch().map((event) => _getAll()).startWith(_getAll());
  }

  Future<void> saveAll(List<MusicSectionVO> items) async {
    await _getBox().clear();
    await _getBox().addAll(items);
  }

  List<MusicSectionVO> _getAll() {
    return _getBox().values.toList();
  }

  Box<MusicSectionVO> _getBox() {
    return Hive.box<MusicSectionVO>(musicSectionBox);
  }
}
