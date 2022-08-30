import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/utils/extension.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:provider/provider.dart';

import '../resources/colors.dart';
import '../resources/dimens.dart';
import '../widgets/dialog_text_button.dart';
import '../widgets/sleep_timer_header.dart';

class SleepTimerDialog extends StatelessWidget {
  const SleepTimerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.h)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const SleepTimerHeader(title: 'Set a Duration'),
            Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: context.isDarkMode(context)
                    ? darkScaffoldBackgroundColor
                    : Colors.white,
              ),
            ),
            Container(
              color: context.isDarkMode(context)
                  ? darkScaffoldBackgroundColor
                  : Colors.white,
              child: const DurationsView(),
            ),
            Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: context.isDarkMode(context)
                    ? darkScaffoldBackgroundColor
                    : Colors.white,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: context.isDarkMode(context)
                      ? darkModeContainerBackgroundColor.withOpacity(0.5)
                      : containerBackgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.h),
                    bottomRight: Radius.circular(16.h),
                  )),
              height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DialogTextButton(
                    title: 'Cancel',
                    color: context.isDarkMode(context)
                        ? Colors.white
                        : Colors.black,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DialogTextButton(
                    title: 'Save',
                    color: primaryColor,
                    onTap: () {
                      context.read<PlayerBloc>().onTapSetTimer();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DurationsView extends StatelessWidget {
  const DurationsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final minute = (index + 1) * 5;
        return Padding(
          padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
          child: Center(
            child: GestureDetector(
              onTap: () {
                context.read<PlayerBloc>().onSelectTimerMinute(minute);
              },
              child: Selector<PlayerBloc, int>(
                  selector: (_, playerBloc) => playerBloc.timerMinute,
                  builder: (_, timerMinute, __) {
                    final isSelected = minute == timerMinute;
                    return Text(
                      '$minute mins',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color:
                            isSelected ? primaryColor : const Color(0xff707070),
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    );
                  }),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: context.isDarkMode(context)
            ? const Color(0xff505050)
            : searchIconColor,
      ),
      itemCount: 12,
    );
  }
}
