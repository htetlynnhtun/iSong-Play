import 'package:music_app/vos/song_vo.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

extension Casting on SearchVideo {
  Duration _ytDurationToDuration(String duration) {
    int hours = 0;
    int minutes = 0;
    int seconds;
    List<String> parts = duration.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    seconds = int.parse(parts[parts.length - 1]);

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  SongVO toSongVO() {
    return SongVO(
      id: id.toString(),
      title: title,
      artist: author,
      thumbnail: thumbnails[0].url.toString(),
      duration: _ytDurationToDuration(duration),
      filePath: "",
      createdAt: DateTime.now(),
    );
  }
}
