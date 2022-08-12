import 'package:music_app/persistance/recent_tracks_dao.dart';
import 'package:music_app/persistance/song_dao.dart';
import 'package:music_app/vos/recent_track_vo.dart';
import 'package:music_app/vos/song_vo.dart';

abstract class RecentTrackService {
  void addToRecentTracks(SongVO songVO);
  Stream<List<SongVO>> getRecentTracks();
  SongVO? getLastRecentTrack();
}

class RecentTrackServiceImpl implements RecentTrackService {
  static final _singleton = RecentTrackServiceImpl._internal();
  RecentTrackServiceImpl._internal();
  factory RecentTrackServiceImpl() => _singleton;

  final _recentTrackDao = RecentTracksDao();
  final _songDao = SongDao();

  @override
  void addToRecentTracks(SongVO songVO) async {
    final songInHive = _songDao.getItem(songVO.id);
    if (songInHive == null) {
      await _songDao.saveItem(songVO);
    }

    final trackInHive = _recentTrackDao.getItem(songVO.id);

    if (trackInHive == null) {
      final track = RecentTrackVO(songVO.id, songVO.isDownloadFinished);
      _recentTrackDao.saveItem(track);
    } else {
      trackInHive.updatedAt = DateTime.now();
      trackInHive.isDownloaded = songVO.isDownloadFinished;
      await trackInHive.save();
    }

    final allTracks = _recentTrackDao.getAll();
    if (allTracks.length > 20) {
      allTracks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      final oldestTrack = allTracks.last;

      final theSong = _songDao.getItem(oldestTrack.songID)!;
      if (!theSong.isDownloadFinished) {
        await theSong.delete();
      }

      await oldestTrack.delete();
    }
  }

  @override
  Stream<List<SongVO>> getRecentTracks() {
    return _recentTrackDao.watchItems().map((items) {
      items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return items.map(_mapTrackToSong).whereType<SongVO>().toList();
    });
  }

  @override
  SongVO? getLastRecentTrack() {
    final allTracks = _recentTrackDao.getAll();

    if (allTracks.isEmpty) {
      return null;
    }

    allTracks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return _mapTrackToSong(allTracks.first);
  }

  SongVO? _mapTrackToSong(RecentTrackVO track) {
    return _songDao.getItem(track.songID);
  }
}
