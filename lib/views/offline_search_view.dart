import 'package:flutter/material.dart';
import 'package:music_app/vos/song_vo.dart';

import '../widgets/song_item_view.dart';

class OfflineSearchView extends StatelessWidget {
  const OfflineSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) => SongItemView(SongVO.dummySong()),
          separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
          itemCount: 10),
    );
  }
}
