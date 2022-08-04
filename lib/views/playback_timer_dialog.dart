import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors.dart';
import '../resources/dimens.dart';
import '../widgets/dialog_text_button.dart';
import '../widgets/sleep_timer_header.dart';

class PlaybackTimerDialog extends StatelessWidget {
  const PlaybackTimerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.h)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          shrinkWrap: true,
          children: [
            const SleepTimerHeader(title: 'Playback Timer'),
            SizedBox(
              height: 2.h,
            ),
            Container(
              height: 90.h,
              child: Center(
                child: Text('29:59',style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32.sp,
                  color: primaryColor,
                ),),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              color: Colors.black12,
              height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DialogTextButton(
                    title: 'Stop',
                    color: Colors.black,
                    onTap: (){},
                  ),
                  DialogTextButton(
                    title: 'Ok',
                    color: primaryColor,
                    onTap: (){},
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
