import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_app/pages/setting_page.dart';
import 'package:music_app/resources/colors.dart';
import 'package:music_app/utils/extension.dart';
import 'package:music_app/vos/song_vo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../blocs/dummy_bloc.dart';
import '../blocs/player_bloc.dart';
import '../widgets/song_item_view.dart';
import '../widgets/title_and_icon_view.dart';
import '../widgets/title_text.dart';

class DummyView extends StatelessWidget {
  const DummyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DummyBloc>(
      builder: (context, bloc, _) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 12.h,
            ),
            Row(
              children: [
                const TitleText(title: 'iSong Play'),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              allowMultiple: true,
                              type: FileType.custom,
                              allowedExtensions: ['mp3', 'm4a'],
                              withData: true);

                      if (result != null) {
                        context.read<DummyBloc>().onTapPlus(result);
                      } else {
                        // User canceled the picker
                      }
                    },
                    icon: Icon(
                      Icons.add_circle,
                      size: 28.r,
                      color: primaryColor,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings,
                      size: 28.r,
                      color: primaryColor,
                    )),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Selector<DummyBloc, List<SongVO>>(
              selector: (context, bloc) => bloc.songs,
              builder: (context, songs, _) => Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () {
                      context
                          .read<PlayerBloc>()
                          .onTapSong(index, songs, withBlocking: false);
                    },
                    child: SongItemView(
                      songs[index],
                      menus: const [
                        SongItemPopupMenu.addToQueue,
                        SongItemPopupMenu.addToPlaylist,
                        SongItemPopupMenu.deleteFromPlaylist,
                        SongItemPopupMenu.deleteFromLibrary,
                      ],
                    ),
                  ),
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 10.h);
                  },
                  itemCount: songs.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
