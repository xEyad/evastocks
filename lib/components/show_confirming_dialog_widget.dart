import 'package:flutter/material.dart';

import 'custom_button.dart';

void showConfirmingDialog(
    {required BuildContext context,
    required String title,
    required String body}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Colors.white,
        alignment: Alignment.center,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title),
          ],
        ),
        content: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(body),
          ],
        ),
        actions: [
          CustomButton(
              title: 'موافق'
              ,onPressed: (){Navigator.of(context).pop();
              },
              ),
        ],
      );
    },
  );
}
