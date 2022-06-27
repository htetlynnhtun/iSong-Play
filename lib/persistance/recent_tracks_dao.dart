import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/vos/song_vo.dart';

class RecentTracksDao {
  static final _singleton = RecentTracksDao._internal();

  factory RecentTracksDao() {
    return _singleton;
  }

  RecentTracksDao._internal();

  Stream<List<SongVO>> watchItems() {
    return _box.watch().map((_) {
      if (_box.values.length > 20) {
        _box.deleteAt(0);
      }
      return _box.values.toList();
    }).startWith(_box.values.toList());
  }

  void addToRecentTracks(SongVO songVO) async {
    try {
      final songInHive = _box.values.firstWhere((song) => song.id == songVO.id);
      await _box.delete(songInHive.key);
      // ignore: empty_catches
    } catch (error) {}

    _box.put(_timeStamp.toString(), songVO);
  }

  int get _timeStamp {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Box<SongVO> get _box {
    return Hive.box(recentTracksBox);
  }

}
