import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

void showSnackBar(BuildContext context, String text, bool showError) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(showError
        ? SnackBar(
            content: Text(text),
            backgroundColor: Pallete.redPinkColor,
          )
        : SnackBar(
            content: Text(text),
          ));
}

Future<FilePickerResult?> pickImage() {
  return FilePicker.platform.pickFiles(type: FileType.image);
}
