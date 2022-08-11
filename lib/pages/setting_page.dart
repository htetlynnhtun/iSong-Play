import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/theme_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:provider/provider.dart';

import '../widgets/app_bar_back_icon.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarBackIcon(
          color: primaryColor,
        ),
        title: Text(
          'Setting',
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: const [
              ThemeRadioButton(
                title: 'Light',
                value: ThemeMode.light,
              ),
              ThemeRadioButton(
                title: 'Dark',
                value: ThemeMode.dark,
              ),
              ThemeRadioButton(
                title: 'Auto',
                value: ThemeMode.system,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThemeRadioButton extends StatelessWidget {
  final ThemeMode value;
  final String title;

  const ThemeRadioButton({
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<ThemeMode>(
            value: value,
            groupValue: context.watch<ThemeBloc>().themeMode,
            onChanged: (ThemeMode? themeMode) {
              context.read<ThemeBloc>().onTapRadio(themeMode);
            }),
        Text(title),
      ],
    );
  }
}
