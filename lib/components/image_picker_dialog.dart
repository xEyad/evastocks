import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


Future<PickedFile?> showImagePickerDialog(BuildContext context) async {
  final picker = ImagePicker();
  PickedFile? pickedImage;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("قم بإرفاق صورة"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("التقاط باستخدام الكاميرا"),
              onTap: () async {
                pickedImage = await picker.getImage(source: ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("التقاط من المعرض"),
              onTap: () async {
                pickedImage = await picker.getImage(source: ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );

  return pickedImage;
}
