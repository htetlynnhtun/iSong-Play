import 'package:hive/hive.dart';
import 'package:music_app/vos/recent_track_vo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/vos/song_vo.dart';

class RecentTracksDao {
  static final _singleton = RecentTracksDao._internal();

  factory RecentTracksDao() {
    return _singleton;
  }

  RecentTracksDao._internal();

  Stream<List<RecentTrackVO>> watchItems() {
    return _box.watch().map((_) => getAll()).startWith(getAll());
  }

  void addToRecentTracks(RecentTrackVO recentTrack) async {
    try {
      final trackInHive = _box.values.firstWhere((track) => track.songID == recentTrack.songID);
      await _box.delete(trackInHive.key);
      // ignore: empty_catches
    } catch (error) {}

    _box.put(_timeStamp.toString(), recentTrack);
  }

  RecentTrackVO getLastRecentTrack() {
    return _box.values.last;
  }

  RecentTrackVO? getItem(String key) {
    return _box.get(key);
  }

  void saveItem(RecentTrackVO vo) {
    _box.put(vo.songID, vo);
  }

  List<RecentTrackVO> getAll() {
    return _box.values.toList();
  }

  void deleteAt(int index) {
    _box.deleteAt(index);
  }

  int get _timeStamp {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Box<RecentTrackVO> get _box {
    return Hive.box(recentTracksBox);
  }
}
