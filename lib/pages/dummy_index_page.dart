import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/pages/dummy_page.dart';
import 'package:music_app/pages/player_page.dart';
import 'package:music_app/pages/setting_page.dart';
import 'package:music_app/utils/extension.dart';

import '../resources/colors.dart';
import '../utils/animate_route.dart';
import '../widgets/mini_player.dart';

class DummyIndexPage extends StatefulWidget {
  const DummyIndexPage({Key? key}) : super(key: key);

  @override
  State<DummyIndexPage> createState() => _DummyIndexPageState();
}

class _DummyIndexPageState extends State<DummyIndexPage> {
  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
              onTap: (){
                Navigator.push(context, SlideRightRoute(page: const PlayerPage()));
              },
              child: const MiniPlayer()),
          SizedBox(
            height: context.isMobile() ? 75.h : 70.h,
            child: BottomNavigationBar(
              iconSize: 18.h,
              selectedFontSize: 12.sp,
              unselectedFontSize: 10.sp,
              selectedItemColor: primaryColor,
              unselectedItemColor: navbarUnselectedItemColor,
              items: const [
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/images/ic_home.png'),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/images/ic_library.png'),
                  ),
                  label: 'Library',
                ),
              ],
              currentIndex: currentIndex,
              onTap: (index) {
                setState(
                  () {
                    currentIndex = index;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const DummyView(),
          const SettingPage(),
        ].elementAt(index);
      },
    };
  }
}
