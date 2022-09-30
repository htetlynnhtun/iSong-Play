import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';

part 'recent_track_vo.g.dart';

@HiveType(typeId: recentTrackTypeId)
class RecentTrackVO extends HiveObject {
  @HiveField(0)
  DateTime updatedAt;

  /// Key for Hive
  @HiveField(1)
  final String songID;

  @HiveField(2)
  bool isDownloaded;

  RecentTrackVO(this.songID, this.isDownloaded) : updatedAt = DateTime.now();
}
