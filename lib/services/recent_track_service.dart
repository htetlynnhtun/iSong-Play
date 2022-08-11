import 'package:music_app/persistance/online_song_dao.dart';
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
  final _onlineSongDao = OnlineSongDao();

  @override
  void addToRecentTracks(SongVO songVO) async {
    final trackInHive = _recentTrackDao.getItem(songVO.id);

    if (trackInHive == null) {
      final track = RecentTrackVO(songVO.id, songVO.isDownloadFinished);
      _recentTrackDao.saveItem(track);
    } else {
      trackInHive.updatedAt = DateTime.now();
      trackInHive.isDownloaded = songVO.isDownloadFinished;
      trackInHive.save();
    }

    if (!songVO.isDownloadFinished) {
      _onlineSongDao.saveItem(songVO);
    }

    if (_recentTrackDao.getAll().length > 20) {
      _recentTrackDao.deleteAt(0);
    }
  }

  @override
  Stream<List<SongVO>> getRecentTracks() {
    return _recentTrackDao.watchItems().map((items) {
      items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return items.map(_mapTrackToSong).toList();
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

  SongVO _mapTrackToSong(RecentTrackVO track) {
    if (track.isDownloaded) {
      return _songDao.getItem(track.songID)!;
    } else {
      return _onlineSongDao.getItem(track.songID)!;
    }
  }
}
