import 'package:flutter/material.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:provider/provider.dart';

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
          child: Selector<PlayerBloc, List<SongVO>>(
            selector: (_, playerBloc) => playerBloc.queueState,
            builder: (_, queueState, __) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => context.read<PlayerBloc>().skipTo(index),
                    child: SongItemView(
                      queueState[index],
                      isUpNext: true,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemCount: queueState.length,
              );
            },
          ),
        )
      ],
    );
  }
}
