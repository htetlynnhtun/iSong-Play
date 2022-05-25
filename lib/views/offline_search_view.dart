import 'package:flutter/material.dart';

import '../widgets/song_item_view.dart';

class OfflineSearchView extends StatelessWidget {
  const OfflineSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) => SongItemView(
                title: 'This is title $index',
                artist: 'This is artist $index',
              ),
          separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
          itemCount: 10),
    );
  }
}
