//domo banner image
import 'package:flutter/cupertino.dart';
import 'package:music_app/views/offline_search_view.dart';
import 'package:music_app/views/online_search_view.dart';

import '../vos/song_vo.dart';

List<String> bannerImage = [
  'https://img.youtube.com/vi/wrh6plP7oU4/maxresdefault.jpg',
  'https://img.youtube.com/vi/mNEUkkoUoIA/maxresdefault.jpg',
  'https://img.youtube.com/vi/O2CIAKVTOrc/maxresdefault.jpg',
  'https://img.youtube.com/vi/e-ORhEE9VVg/maxresdefault.jpg',
  'https://img.youtube.com/vi/tGvhJCkboms/maxresdefault.jpg'
];

List<Widget> searchViewList = [
  const OnlineSearchView(),
  const OfflineSearchView(),
];


///test song vo
var songVO =SongVO(filePath: '', id: '1', title: 'This is fucking long title text',
    thumbnail: 'https://img.youtube.com/vi/tGvhJCkboms/maxresdefault.jpg', artist: 'This is fucking long title text', createdAt:DateTime(2022) , duration: const Duration(days: 0));