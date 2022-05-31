import 'package:flutter/material.dart';

import '../vos/song_vo.dart';
import '../widgets/song_item_view.dart';
import '../widgets/up_next_button.dart';

class UpNextView extends StatelessWidget {
  const UpNextView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const UpNextButton(
            iconUrl: 'assets/images/ic_up_next_close.png',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) => SongItemView(
                    SongVO.dummySong(),
                    isUpNext: true,
                  ),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
              itemCount: 10),
        )
      ],
    );
  }
}
