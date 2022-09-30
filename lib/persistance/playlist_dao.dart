import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/vos/playlist_vo.dart';

class PlaylistDao {
  static final PlaylistDao _singleton = PlaylistDao._internal();
  PlaylistDao._internal();
  factory PlaylistDao() {
    return _singleton;
  }

  Stream<List<PlaylistVo>> watchItems() {
    return getBox().watch().map((event) => _getAll()).startWith(_getAll());
  }

  Future<void> saveItem(PlaylistVo playlist) {
    return getBox().put(playlist.id, playlist);
  }

  PlaylistVo? getItem(String id) {
    return getBox().get(id);
  }

  Future<void> deleteItem(String id) {
    return getBox().delete(id);
  }

  Future<void> deleteAll() {
    return getBox().clear();
  }

  List<PlaylistVo> _getAll() {
    return getBox().values.toList();
  }

  Box<PlaylistVo> getBox() {
    return Hive.box<PlaylistVo>(playlistBox);
  }
}
