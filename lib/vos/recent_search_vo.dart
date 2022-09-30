import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';

part 'recent_search_vo.g.dart';

@HiveType(typeId: recentSearchTypeId)
class RecentSearchVO extends HiveObject {
  @HiveField(0)
  DateTime createdAt;

  // id
  @HiveField(1)
  String query;

  RecentSearchVO({
    required this.createdAt,
    required this.query,
  });
}
