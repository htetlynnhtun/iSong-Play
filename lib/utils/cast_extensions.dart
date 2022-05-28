import 'package:music_app/services/donminant_color.dart';
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

  Future<SongVO> toSongVO() async {
    final imageUrl = thumbnails[0].url.toString();
    
    return SongVO(
      createdAt: DateTime.now(),
      id: id.toString(),
      title: title,
      artist: author,
      thumbnail: imageUrl,
      duration: _ytDurationToDuration(duration),
      filePath: "",
      dominantColor: await DominantColor.getDominantColor(imageUrl),
    );
  }
}
