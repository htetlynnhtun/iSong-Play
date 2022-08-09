// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_app/persistance/song_dao.dart';
import 'package:music_app/services/recent_track_service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:music_app/services/audio_player_handler.dart';
import 'package:music_app/services/youtube_service.dart';
import 'package:music_app/vos/song_vo.dart';

class PlayerBloc extends ChangeNotifier {
  late AudioPlayerHandler _playerHandler;
  late YoutubeService _youtubeService;
  late RecentTrackService _recentTrackService;
  final _songDao = SongDao();

  // ========================= States =========================
  String? currentSongTitle;
  String? currentSongThumbnail;
  String? currentSongArtist;
  SongVO? nowPlayingSong;
  List<Color?> dominantColor = [];
  var queueState = <SongVO>[];
  var nowPlayingIndex = 0;
  var currentSongID = "";
  var progressBarState = const ProgressBarState(
    buffered: Duration.zero,
    current: Duration.zero,
    total: Duration.zero,
  );
  var circularProgressPercentage = 0.0;
  var buttonState = ButtonState.paused;
  var repeatState = RepeatState.off;
  var isFirstSong = true;
  var isLastSong = true;
  var isShuffleModeEnabled = false;

  /// If song is longer than 10 minutes.
  bool? isLongDuration;

  var isLoadingSong = false;

  final _internalNowPlayingSubject = BehaviorSubject<SongVO>();
  final _isLongDurationSubject = BehaviorSubject<bool?>();

  static var songsList = <SongVO>[];

  PlayerBloc() {
    _init();
    _songDao.watchItems().listen((_) => notifyListeners());
    _loadRecentTrack();
  }

  void _init() async {
    _youtubeService = YoutubeService();
    _recentTrackService = RecentTrackServiceImpl();
    _playerHandler = await AudioService.init(builder: () => AudioPlayerHandlerImpl());

    _listenToQueue();
    _listenToMediaItemAndQueue();
    _listenToProgress();
    _listenToPlaybackState();

    _listenToMediaItemForDetectingLongDurationSong();

    _internalNowPlayingSubject.distinct((p, n) => p.id == n.id).listen((song) {
      _recentTrackService.addToRecentTracks(song);
    });

    _isLongDurationSubject.distinct().listen((isLong) {
      isLongDuration = isLong;
      notifyListeners();
    });
  }

  void _loadRecentTrack() async {
    final lastRecentTrack = _recentTrackService.getLastRecentTrack();
    nowPlayingSong = lastRecentTrack;
    notifyListeners();
    if (lastRecentTrack != null) {
      currentSongThumbnail = lastRecentTrack.thumbnail;
      currentSongTitle = lastRecentTrack.title;
      currentSongArtist = lastRecentTrack.artist;
      currentSongID = lastRecentTrack.id;
      notifyListeners();

      final mediaItem = (await _songsToMediaItems([lastRecentTrack])).first;
      _playerHandler.addQueueItem(mediaItem);
    }
  }

  @override
  void dispose() {
    _youtubeService.dispose();
    super.dispose();
  }
}

// ========================= UIEvent extensions =========================
extension UIEvent on PlayerBloc {
  void onTapSong(int index, List<SongVO> songs) async {
    _playerHandler.stop();
    await _playerHandler.setShuffleMode(AudioServiceShuffleMode.none);
    isShuffleModeEnabled = false;

    notifyListeners();

    // check if songs is the same with current queue
    // var theSame = songs.every((song) => queueState.any((e) => e.id == song.id));
    // if (songs.length != queueState.length || !theSame) {
    //   print("new queue");
    //   List<MediaItem> mediaItems = await _songsToMediaItems(songs);
    //   await _playerHandler.updateQueue(mediaItems);
    // }
    if (PlayerBloc.songsList.isNotEmpty && (PlayerBloc.songsList.first == songs.first)) {
      await _playerHandler.skipToQueueItem(index);
    } else {
      PlayerBloc.songsList = [];
      PlayerBloc.songsList.addAll(songs);
      isLoadingSong = true;
      currentSongID = songs[index].id;
      buttonState = ButtonState.loading;
      notifyListeners();
      final mediaItems = await _songsToMediaItems(songs);
      // await _playerHandler.updateQueue(mediaItems);
      await _playerHandler.setQueue(index, mediaItems);
      isLoadingSong = false;
      notifyListeners();
    }

    await _playerHandler.play();
  }

  void onTapMusicList(String id) async {
    final songs = await _youtubeService.getSongsOfMusicList(id);
    onTapSong(0, songs);
  }

  void onTapShufflePlay(List<SongVO> songs) async {
    List<MediaItem> mediaItems = await _songsToMediaItems(songs);
    isShuffleModeEnabled = true;
    notifyListeners();

    await _playerHandler.setShuffleMode(AudioServiceShuffleMode.all);
    await _playerHandler.updateQueue(mediaItems);
    await _playerHandler.play();
  }

  // void onTapOneSong(SongVO songVO) async {
  //   print("wtbug: onTapOneSong");
  //   final link = await _youtubeService.getLink(songVO.id);
  //   final mediaItem = MediaItem(
  //     id: songVO.id,
  //     title: songVO.title,
  //     duration: songVO.duration,
  //     extras: {"url": link.toString()},
  //   );
  //   await _playerHandler.playMediaItem(mediaItem);
  // }

  void onSeek(Duration position) {
    _playerHandler.seek(position);
  }

  void play() => _playerHandler.play();

  void pause() => _playerHandler.pause();

  void skipToPrevious() => _playerHandler.skipToPrevious();

  void skipToNext() => _playerHandler.skipToNext();

  void skipTo(int index) => _playerHandler.skipToQueueItem(index);

  void repeat() {
    final next = (repeatState.index + 1) % RepeatState.values.length;
    repeatState = RepeatState.values[next];

    switch (repeatState) {
      case RepeatState.off:
        _playerHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.one:
        _playerHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.playlist:
        _playerHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }

    notifyListeners();
  }

  void shuffle() {
    isShuffleModeEnabled = !isShuffleModeEnabled;

    if (isShuffleModeEnabled) {
      _playerHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _playerHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }

    notifyListeners();
  }

  void onTapAddToQueue(SongVO songVO) async {
    print("wtbug: onTapAddToQueue");
    MediaItem mediaItem;

    if (songVO.isDownloadFinished) {
      mediaItem = MediaItem(
        id: songVO.id,
        title: songVO.title,
        artist: songVO.artist,
        duration: songVO.duration,
        artUri: Uri.parse(songVO.thumbnail),
        extras: {
          "isOffline": true,
          "filePath": songVO.filePath,
          // if color is null, provide default color
          "beginColor": songVO.dominantColor[0]?.value ?? 0,
          "endColor": songVO.dominantColor[1]?.value ?? 0
        },
      );
    } else {
      final link = await _youtubeService.getLink(songVO.id);
      mediaItem = MediaItem(
        id: songVO.id,
        title: songVO.title,
        artist: songVO.artist,
        duration: songVO.duration,
        artUri: Uri.parse(songVO.thumbnail),
        extras: {
          "isOffline": false,
          "url": link.toString(),
          // if color is null, provide default color
          "beginColor": songVO.dominantColor[0]?.value ?? 0,
          "endColor": songVO.dominantColor[1]?.value ?? 0
        },
      );
    }
    await _playerHandler.addQueueItem(mediaItem);
    play();
  }

  void onTapSkipForLongDurationSong() {
    _isLongDurationSubject.add(false);
    if (nowPlayingIndex == PlayerBloc.songsList.length - 1) {
      /*
       1) keep looping 
       2) stop player
      */
      // onTapSong(0, songsList);
      _playerHandler.stop();
    } else {
      onTapSong(nowPlayingIndex + 1, PlayerBloc.songsList);
    }
  }

  void onTapAddToLibraryForLongDurationSong(Function(SongVO) cb) {
    _isLongDurationSubject.add(false);

    cb(nowPlayingSong!);

    if (nowPlayingIndex == PlayerBloc.songsList.length - 1) {
      /*
       1) keep looping 
       2) stop player
      */
      // onTapSong(0, songsList);
      _playerHandler.stop();
    } else {
      onTapSong(nowPlayingIndex + 1, PlayerBloc.songsList);
    }
  }

  void onDialogDismissed() {
    // isLongDuration = null;
    _isLongDurationSubject.add(null);
  }
}

// ========================= Internal Logic extensions =========================
extension InternalLogic on PlayerBloc {
  Stream<Duration> get _currentPositionStream => AudioService.position;
  Stream<Duration> get _bufferedPositionStream => _playerHandler.playbackState.map((state) => state.bufferedPosition).distinct();
  Stream<Duration?> get _durationStream => _playerHandler.mediaItem.map((item) => item?.duration).distinct();

  void _listenToProgress() {
    Rx.combineLatest3<Duration, Duration, Duration?, ProgressBarState>(
      _currentPositionStream,
      _bufferedPositionStream,
      _durationStream,
      (one, two, three) => ProgressBarState(
        current: one,
        buffered: two,
        total: three ?? Duration.zero,
      ),
    ).listen((event) {
      progressBarState = event;
      final current = progressBarState.current.inSeconds;
      final total = progressBarState.total.inSeconds;
      if (total == 0) {
        circularProgressPercentage = 0;
      } else {
        circularProgressPercentage = current.toDouble() / total.toDouble();
      }

      notifyListeners();
    });
  }

  void _listenToPlaybackState() {
    _playerHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering) {
        buttonState = ButtonState.loading;
      } else if (!isPlaying) {
        buttonState = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        buttonState = ButtonState.playing;
      } else {
        _playerHandler.seek(Duration.zero);
        _playerHandler.pause();
      }

      notifyListeners();
    });
  }

  void _listenToMediaItemAndQueue() {
    Rx.combineLatest2<MediaItem?, List<MediaItem>, void>(
      _playerHandler.mediaItem.distinct(),
      _playerHandler.queue.distinct(),
      (mediaItem, queue) {
        if (mediaItem == null) return;

        currentSongTitle = mediaItem.title;
        currentSongThumbnail = mediaItem.artUri.toString();
        currentSongArtist = mediaItem.artist!;
        dominantColor = [
          Color(mediaItem.extras!["beginColor"] as int),
          Color(mediaItem.extras!["endColor"] as int),
        ];

        if (queue.length < 2) {
          isFirstSong = true;
          isLastSong = true;
        } else {
          isFirstSong = queue.first == mediaItem;
          isLastSong = queue.last == mediaItem;
        }

        notifyListeners();
      },
    ).listen((_) => _);
  }

  void _listenToMediaItemForDetectingLongDurationSong() {
    _playerHandler.mediaItem.distinct((old, now) => old?.id == now?.id).listen((mediaItem) {
      if (mediaItem == null) return;

      var isInNewSongsList = PlayerBloc.songsList.any((song) => song.id == mediaItem.id);
      if (!isInNewSongsList) return;

      nowPlayingSong = _getNowPlayingSong(mediaItem);
      currentSongID = nowPlayingSong!.id;
      nowPlayingIndex = queueState.indexWhere((element) => element.id == nowPlayingSong!.id);
      final duration = nowPlayingSong!.duration;

      if (duration.inMinutes > 10 && !nowPlayingSong!.isDownloadFinished) {
        _playerHandler.pause();

        _isLongDurationSubject.add(true);
      } else {
        _internalNowPlayingSubject.add(nowPlayingSong!);
      }
    });
  }

  void _listenToQueue() {
    _playerHandler.queue.distinct().map(_mediaItemsToSongs).listen((queue) {
      queueState = queue;
      notifyListeners();
    });
  }

  Future<List<MediaItem>> _songsToMediaItems(List<SongVO> songs) async {
    final List<MediaItem> mediaItems = [];
    final List<String> urls = [];

    for (var song in songs) {
      if (song.isDownloadFinished) {
        urls.add(song.filePath);
      } else {
        final url = await _youtubeService.getLink(song.id);
        urls.add(url.toString());
      }
    }

    songs.asMap().forEach((i, song) {
      MediaItem mediaItem;

      if (song.isDownloadFinished) {
        mediaItem = MediaItem(
          id: song.id,
          title: song.title,
          artist: song.artist,
          duration: song.duration,
          artUri: Uri.parse(song.thumbnail),
          extras: {
            "isOffline": true,
            "filePath": urls[i],
            // if color is null, provide default color
            "beginColor": song.dominantColor[0]?.value ?? 0,
            "endColor": song.dominantColor[1]?.value ?? 0
          },
        );
      } else {
        mediaItem = MediaItem(
          id: song.id,
          title: song.title,
          artist: song.artist,
          duration: song.duration,
          artUri: Uri.parse(song.thumbnail),
          extras: {
            "isOffline": false,
            "url": urls[i],
            // if color is null, provide default color
            "beginColor": song.dominantColor[0]?.value ?? 0,
            "endColor": song.dominantColor[1]?.value ?? 0
          },
        );
      }

      mediaItems.add(mediaItem);
    });
    return mediaItems;
  }

  void _logNowPlaying(MediaItem mediaItem) {
    String nowPlaying;
    if (mediaItem.extras!["isOffline"] as bool) {
      nowPlaying = mediaItem.extras!["filePath"];
    } else {
      nowPlaying = mediaItem.extras!["url"];
    }
    print("wtbug: Now playing: $nowPlaying");
  }

  SongVO _getNowPlayingSong(MediaItem mediaItem) {
    final songInHive = _songDao.getItem(mediaItem.id);
    if (songInHive != null) {
      return songInHive;
    } else {
      return _mediaItemsToSongs([mediaItem]).first;
    }
  }
}

List<SongVO> _mediaItemsToSongs(List<MediaItem> mediaItems) {
  return mediaItems.map((mediaItem) {
    final isOffline = mediaItem.extras!["isOffline"] as bool;
    SongVO songVO;

    if (isOffline) {
      songVO = SongVO(
        createdAt: DateTime.now(),
        id: mediaItem.id,
        title: mediaItem.title,
        artist: mediaItem.artist ?? "Test Author",
        thumbnail: mediaItem.artUri?.toString() ?? "",
        duration: mediaItem.duration ?? Duration.zero,
        filePath: mediaItem.extras!["filePath"] as String,
        dominantColor: [
          Color(mediaItem.extras!["beginColor"] as int),
          Color(mediaItem.extras!["endColor"] as int),
        ],
        isFavorite: false,
      );
      songVO.isDownloadFinished = true;
    } else {
      songVO = SongVO(
        createdAt: DateTime.now(),
        id: mediaItem.id,
        title: mediaItem.title,
        artist: mediaItem.artist ?? "Test Author",
        thumbnail: mediaItem.artUri?.toString() ?? "",
        duration: mediaItem.duration ?? Duration.zero,
        filePath: "",
        dominantColor: [
          Color(mediaItem.extras!["beginColor"] as int),
          Color(mediaItem.extras!["endColor"] as int),
        ],
        isFavorite: false,
      );
    }
    return songVO;
  }).toList();
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { loading, playing, paused }

enum RepeatState { off, one, playlist }
