import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:music_app/blocs/library_bloc.dart';
import 'package:music_app/utils/callback_typedefs.dart';
import 'package:music_app/utils/extension.dart';
import '../resources/colors.dart';

class AddRenamePlaylistDialog extends StatelessWidget {
  final String? initialText;
  final OnAddPlayListName? onAdd;
  final OnRenamePlayListName? onRename;
  final String title;
  final String onTapTitle;

  const AddRenamePlaylistDialog({
    this.initialText,
    this.onAdd,
    this.onRename,
    required this.title,
    required this.onTapTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.h))),
      child: Container(
        width: width * 0.8,
        height: height * (context.isMobile() ? 0.27 : 0.4),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(14.h)),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 18.h,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                  alignment: Alignment.center,
                  child: EditTextField(initialText)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: width * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(14.h),
                  bottomLeft: Radius.circular(14.h),
                )),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          context
                              .read<LibraryBloc>()
                              .onTapCancelAddRenamePlaylist();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () async {
                          SavePlaylistResult result;

                          if (initialText == null) {
                            result = await onAdd!();
                          } else {
                            result = await onRename!(initialText!);
                          }
                          switch (result) {
                            case SavePlaylistResult.emptyName:
                              showToast("Playlist name must not be empty");
                              break;
                            case SavePlaylistResult.sameName:
                              showToast("A playlist exists with that name");
                              break;
                            case SavePlaylistResult.success:
                              Navigator.pop(context);
                              break;
                          }
                        },
                        child: Text(
                          onTapTitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditTextField extends StatelessWidget {
  final String? initialText;
  const EditTextField(
    this.initialText, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialText,
      onChanged: (value) {
        context.read<LibraryBloc>().onPlaylistNameChanged(value);
      },
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.normal,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
      ],
      textAlignVertical: TextAlignVertical.center,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.h), // Added this
        isCollapsed: true,
        filled: true,

        hintText: 'Type your Playlist Name',
        hintStyle: TextStyle(
          color: searchIconColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
