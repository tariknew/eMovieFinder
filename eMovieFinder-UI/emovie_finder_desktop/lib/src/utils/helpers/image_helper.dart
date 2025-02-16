import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

import 'dialog.dart';

class ImageHelper {
  static Future<String?> getImage(BuildContext context) async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      compressionQuality: 0
    );

    if (result != null && result.files.single.path != null) {
      var imagePath = result.files.single.path!;
      var image = File(imagePath);

      String fileExtension = imagePath.split('.').last.toLowerCase();
      bool isValidExtension = ['jpg', 'jpeg', 'png'].contains(fileExtension);

      if (isValidExtension) {
        return base64Encode(image.readAsBytesSync());
      } else {
        MyDialogUtils.showErrorDialog(
          context: context,
          message: "Please select a valid image: JPG/JPEG/PNG",
          posActionTitle: "Try Again",
        );
      }
    }

    return null;
  }
}
