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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12.h,
            ),
            Row(
              children: [
                const TitleText(title: 'iSong Play'),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.all(0),
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
                SizedBox(width: 16.w,),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Selector<DummyBloc, List<SongVO>>(
              selector: (context, bloc) => bloc.songs,
              builder: (context, songs, _) => songs.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.r),
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
                    )
                  : const ImportSongView(),
            ),
          ],
        ),
      ),
    );
  }
}

class ImportSongView extends StatelessWidget {
  const ImportSongView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: ()async{
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
        child: Container(
          margin: EdgeInsets.only(top: 62.h),
          padding: EdgeInsets.all(22.r),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.r)),
              border: Border.all(color: primaryColor, width: 2)),
          child: Column(
            children: [
              Image.asset(
                'assets/images/ic_import.png',
                scale: 5,
                color: primaryColor,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'Import your songs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
