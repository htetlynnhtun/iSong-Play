import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/pages/library_page.dart';
import 'package:music_app/pages/player_page.dart';
import 'package:music_app/pages/search_page.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/widgets/loading_view.dart';
import 'package:music_app/widgets/mini_player.dart';
import 'package:provider/provider.dart';

import '../utils/animate_route.dart';
import 'home_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 1;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  @override
  Widget build(BuildContext context) {
    return Selector<PlayerBloc, bool>(
      selector: (_, playerBloc) => playerBloc.isShowingBlockingIndicator,
      builder: (_, isShowingBlockingIndicator, child) {
        return Stack(
          children: [
            child!,
            if (isShowingBlockingIndicator) const LoadingView(),
          ],
        );
      },
      child: WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[currentIndex].currentState!.maybePop();

          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: Selector<PlayerBloc, bool?>(
              selector: (_, playerBloc) => playerBloc.isLongDuration,
              builder: (context, isLongDuration, __) {
                if (isLongDuration == true) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        content: const Text(
                            "Songs longer than 10 minutes need to be added to Library first."),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: TextButton(
                              child: const Text("Add To Library"),
                              onPressed: () async {
                                context
                                    .read<PlayerBloc>()
                                    .onTapAddToLibraryForLongDurationSong(
                                        (songVO) async {
                                  final result = await context
                                      .read<LibraryBloc>()
                                      .onTapAddToLibrary(songVO);
                                  switch (result) {
                                    case AddToLibraryResult.success:
                                      widget.showToast(
                                          "Successfully added to library");
                                      break;
                                    case AddToLibraryResult.alreadyInLibrary:
                                      widget.showToast(
                                          "Song is already in library");
                                      break;
                                  }
                                });

                                // Navigator.pop(context);
                              },
                            ),
                          ),
                          CupertinoDialogAction(
                            child: TextButton(
                              child: const Text("Skip"),
                              onPressed: () {
                                print("Skip long duration song");
                                context
                                    .read<PlayerBloc>()
                                    .onTapSkipForLongDurationSong();
                                // Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                }

                if (isLongDuration == false) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pop(context);
                    context.read<PlayerBloc>().onDialogDismissed();
                  });
                }

                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: Stack(
                    children: [
                      _buildOffstageNavigator(0),
                      _buildOffstageNavigator(1),
                      _buildOffstageNavigator(2),
                    ],
                  ),
                );
              }),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, SlideRightRoute(page: const PlayerPage()));
                  },
                  child: const MiniPlayer()),
              SizedBox(
                height: 70.h,
                child: BottomNavigationBar(
                  iconSize: 18.h,
                  selectedFontSize: 12.sp,
                  unselectedFontSize: 10.sp,
                  selectedItemColor: primaryColor,
                  unselectedItemColor: navbarUnselectedItemColor,
                  items: const [
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/images/ic_library.png'),
                      ),
                      label: 'Library',
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/images/ic_home.png'),
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/images/ic_search.png'),
                      ),
                      label: 'Search',
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
        ),
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
          const LibraryPage(),
          const HomePage(),
          const SearchPage(),
        ].elementAt(index);
      },
    };
  }
}
