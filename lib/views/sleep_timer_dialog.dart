import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          children: [
            const SleepTimerHeader(title: 'Set a Duration'),
            SizedBox(
              height: 2.h,
            ),
            const DurationsView(),
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
                    title: 'Cancel',
                    color: Colors.black,
                    onTap: (){},
                  ),
                  DialogTextButton(
                    title: 'Save',
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

class DurationsView extends StatelessWidget {
  const DurationsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
              child: Center(
                child: Text(
                  '5 mins',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: true ? primaryColor : Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: 6);
  }
}
