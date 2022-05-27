import 'package:hive/hive.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:uuid/uuid.dart';

class RecentSearchDao {
  final _uuid = const Uuid();

  static final RecentSearchDao _singleton = RecentSearchDao._internal();
  RecentSearchDao._internal();
  factory RecentSearchDao() {
    return _singleton;
  }

  Stream<List<String>> watchItems() {
    return _getBox().watch().map((event) => _getAll());
  }

  Future<void> saveItem(String recent) {
    return _getBox().put(_uuid.v1(), recent);
  }

  String? getItem(String id) {
    return _getBox().get(id);
  }

  Future<void> deleteItem(String id) {
    return _getBox().delete(id);
  }

  Future<void> deleteAll() {
    return _getBox().clear();
  }

  List<String> _getAll() {
    return _getBox().values.toList();
  }

  Box<String> _getBox() {
    return Hive.box<String>(recentSearchBox);
  }
}
