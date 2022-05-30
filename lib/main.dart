import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/persistance/color_adapter.dart';
import 'package:music_app/persistance/duration_adapter.dart';
import 'package:music_app/vos/recent_search_vo.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/blocs/home_bloc.dart';
import 'package:music_app/blocs/search_bloc.dart';
import 'package:music_app/pages/index_page.dart';
import 'package:music_app/persistance/box_names.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(RecentSearchVOAdapter());
  Hive.registerAdapter(SongVOAdapter());
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(DurationAdapter());

  await Hive.openBox<RecentSearchVO>(recentSearchBox);
  await Hive.openBox<SongVO>(songBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LibraryBloc()),
        ChangeNotifierProvider(create: (_) => HomeBloc()),
        ChangeNotifierProvider(create: (_) => SearchBloc()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          title: 'Music App',
          home: child,
        ),
        child: const IndexPage(),
      ),
    );
  }
}
