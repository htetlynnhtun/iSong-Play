import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/blocs/music_list_detail_bloc.dart';
import 'package:music_app/blocs/network_connection_bloc.dart';
import 'package:music_app/blocs/player_bloc.dart';
import 'package:music_app/blocs/theme_bloc.dart';
import 'package:music_app/persistance/color_adapter.dart';
import 'package:music_app/persistance/duration_adapter.dart';
import 'package:music_app/theme/app_theme.dart';
import 'package:music_app/vos/music_list_vo.dart';
import 'package:music_app/vos/music_section_vo.dart';
import 'package:music_app/vos/playlist_vo.dart';
import 'package:music_app/vos/recent_search_vo.dart';
import 'package:music_app/vos/recent_track_vo.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/blocs/home_bloc.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:music_app/pages/index_page.dart';
import 'package:music_app/persistance/box_names.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await MobileAds.instance.initialize();

  prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();

  Hive.registerAdapter(RecentSearchVOAdapter());
  Hive.registerAdapter(SongVOAdapter());
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(PlaylistVoAdapter());
  Hive.registerAdapter(MusicListVOAdapter());
  Hive.registerAdapter(MusicSectionVOAdapter());
  Hive.registerAdapter(RecentTrackVOAdapter());

  await Hive.openBox<SongVO>(trendingSongsBox);
  await Hive.openBox<RecentSearchVO>(recentSearchBox);
  await Hive.openBox<SongVO>(songBox);
  await Hive.openBox<PlaylistVo>(playlistBox);
  await Hive.openBox<MusicSectionVO>(musicSectionBox);
  await Hive.openBox<RecentTrackVO>(recentTracksBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NetworkConnectionBloc>(
          create: (_) => NetworkConnectionBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        ChangeNotifierProvider(create: (_) => PlayerBloc()),
        ChangeNotifierProvider(create: (_) => LibraryBloc()),
        ChangeNotifierProvider(create: (_) => HomeBloc()),
        ChangeNotifierProvider(create: (_) => SearchBloc()),
        ChangeNotifierProvider(create: (_) => ThemeBloc()),
        ChangeNotifierProvider(create: (_) => MusicListDetailBloc()),
      ],
      child: Selector<ThemeBloc, ThemeMode?>(
        selector: (context, bloc) => bloc.themeMode,
        builder: (context, themeMode, _) => ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme(context),
            darkTheme: AppTheme.darkTheme(context),
            title: 'Music App',
            home: child,
          ),
          child: const IndexPage(),
        ),
      ),
    );
  }
}
