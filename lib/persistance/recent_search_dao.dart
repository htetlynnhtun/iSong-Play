import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:music_app/vos/recent_search_vo.dart';

class RecentSearchDao {
  static final RecentSearchDao _singleton = RecentSearchDao._internal();
  RecentSearchDao._internal();
  factory RecentSearchDao() {
    return _singleton;
  }

  Stream<List<RecentSearchVO>> watchItems() {
    return _getBox().watch().map((event) => _getAll()).startWith(_getAll());
  }

  Future<void> saveItem(RecentSearchVO recentSearch) {
    return _getBox().put(recentSearch.query, recentSearch);
  }

  RecentSearchVO? getItem(String id) {
    return _getBox().get(id);
  }

  Future<void> deleteItem(String id) {
    return _getBox().delete(id);
  }

  Future<void> deleteAll() {
    return _getBox().clear();
  }

  List<RecentSearchVO> _getAll() {
    return _getBox().values.toList();
  }

  Box<RecentSearchVO> _getBox() {
    return Hive.box<RecentSearchVO>(recentSearchBox);
  }
}
