import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:provider/provider.dart';

import '../vos/song_vo.dart';
import '../widgets/song_item_view.dart';
import '../widgets/up_next_button.dart';
import 'dart:ui' as ui;

class UpNextView extends StatelessWidget {
  const UpNextView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 6.h,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const UpNextButton(
                iconUrl: 'assets/images/ic_up_next_close.png',
              ),
            ),
            SizedBox(
              height: 14.h,
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
                          havePlaceHolderImage: true,
                          showMenuButton: false,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
                    itemCount: queueState.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
