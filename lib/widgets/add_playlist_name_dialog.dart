import 'package:flutter/material.dart';

import '../resources/colors.dart';

class AddPlaylistNameDialog extends StatelessWidget {
  const AddPlaylistNameDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
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
            const Text(
              'Playlist Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: EditTextField(),
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
                      onPressed: () {},
                      child: const Text(
                        'Add',
                        style: TextStyle(
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
  const EditTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        //  bloc.onTextChane(value);
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