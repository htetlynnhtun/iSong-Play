import 'package:flutter/material.dart';
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Container(
        width: width * 0.8,
        height: height * 0.25,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Column(
          children: [
            SizedBox(height: width * 0.07),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EditTextField(initialText),
            ),
            const Spacer(),
            Container(
              height: width * 0.14,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  )),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
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
                        style: const TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
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
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
      ),
      textAlignVertical: TextAlignVertical.center,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8), // Added this
        isCollapsed: true,
        filled: true,
        fillColor: Colors.white,
        hintText: 'Type your Playlist Name',
        hintStyle: const TextStyle(
          color: searchIconColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
