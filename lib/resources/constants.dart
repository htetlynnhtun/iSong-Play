//domo banner image
import 'package:flutter/cupertino.dart';
import 'package:music_app/views/offline_search_view.dart';
import 'package:music_app/views/online_search_view.dart';

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
