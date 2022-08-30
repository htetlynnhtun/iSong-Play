import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/theme_bloc.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/widgets/ads/banner_ad_widget.dart';
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
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: primaryColor),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              const DarkLightAutomaticView(),
              SizedBox(
                height: 16.h,
              ),
              const Center(child: BannerAdWidget()),
              SizedBox(
                height: 18.h,
              ),
              IconAndTextButton(
                imageUrl: 'assets/images/ic_privacy.png',
                title: 'Privacy',
                onTap: () {},
              ),
              SizedBox(
                height: 14.h,
              ),
              IconAndTextButton(
                imageUrl: 'assets/images/ic_privacy.png',
                title: 'Terms and Conditions',
                onTap: () {},
              ),
              SizedBox(
                height: 14.h,
              ),
              IconAndTextButton(
                imageUrl: 'assets/images/ic_rate_us.png',
                title: 'Rate Us',
                onTap: () {},
              ),
              SizedBox(
                height: 14.h,
              ),
              IconAndTextButton(
                imageUrl: 'assets/images/ic_about.png',
                title: 'Version',
                onTap: () {},
              ),
              SizedBox(
                height: 14.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IconAndTextButton extends StatelessWidget {
  final String imageUrl, title;
  final Function onTap;
  const IconAndTextButton({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        onTap();
      },
      child: Row(
        children: [
          Container(
            width: 30.h,
            height: 30.h,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(7.h),
            ),
            child: Center(
              child: Image.asset(
                imageUrl,
                scale: 4,
              ),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DarkLightAutomaticView extends StatelessWidget {
  const DarkLightAutomaticView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.h),
        color: context.isDarkMode(context) ? darkModeContainerBackgroundColor : containerBackgroundColor,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LightDarkRadioButton(
                title: 'Light',
                color: Colors.white,
                onTap: () {
                  context.read<ThemeBloc>().onTapRadio(ThemeMode.light);
                },
                isSelected: !context.isDarkMode(context) && !context.watch<ThemeBloc>().isAutomatic(),
              ),
              LightDarkRadioButton(
                title: 'Dark',
                color: darkModeContainerBackgroundColor,
                onTap: () {
                  context.read<ThemeBloc>().onTapRadio(ThemeMode.dark);
                },
                isSelected: context.isDarkMode(context) && !context.watch<ThemeBloc>().isAutomatic(),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          const Divider(
            color: searchIconColor,
          ),
          SizedBox(
            height: 14.h,
          ),
          AutomaticCheckBox(
            isSelected: context.watch<ThemeBloc>().isAutomatic(),
            onTap: () {
              context.read<ThemeBloc>().onTapRadio(ThemeMode.system);
            },
          ),
          SizedBox(
            height: 14.h,
          ),
        ],
      ),
    );
  }
}

class AutomaticCheckBox extends StatelessWidget {
  final Function onTap;
  final bool isSelected;
  const AutomaticCheckBox({
    Key? key,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        onTap();
      },
      child: Row(
        children: [
          const Text(
            'Automatic',
            style: TextStyle(
              fontSize: 16,
              color: primaryColor,
            ),
          ),
          const Spacer(),
          Image.asset(
            isSelected ? 'assets/images/ic_checkbox_selected.png' : 'assets/images/ic_checkbox.png',
            scale: 4,
          ),
        ],
      ),
    );
  }
}

class LightDarkRadioButton extends StatelessWidget {
  final String title;
  final Color color;
  final bool isSelected;
  final Function onTap;
  const LightDarkRadioButton({
    Key? key,
    required this.title,
    required this.color,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10.h, right: 10.h, left: 10.h, bottom: 30.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.h),
              color: color,
              border: isSelected
                  ? Border.all(
                      color: primaryColor,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Image.asset(
              'assets/images/ic_light_dark.png',
              scale: 3,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
