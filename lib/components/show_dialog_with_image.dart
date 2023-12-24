import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/service_provider.dart';
import 'custom_button.dart';

void showCustomDialogWithImage(
    {required BuildContext context,
    String? title = "اضف تعليقك لنا",
    required ServiceProvider provider,
    required int opinionId,
    String? body = "لا تتردد في ارسال تعليقاتك وملاحظاتك لنا",
    String? hintText = "ما تعليقك؟",
    String? buttonText = "ارسال",
    String? imagePath = 'assets/videos/comment_animation.json'}) {
  final TextEditingController _commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (imagePath != null)
                Lottie.asset(imagePath), // Change the asset path to your image
              if (title != null)
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 10.0),
              if (body != null) Text(body),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _commentController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: hintText,
                    filled: true,
                    fillColor: const Color.fromRGBO(249, 249, 249, 1),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(242, 242, 242, 1)))),
              ),
              const SizedBox(height: 10.0),
              CustomButton(
                  title: buttonText ?? '',
                  onPressed: () {
                    provider
                        .commentOpinion(opinionId, _commentController.text)
                        .then((value) {
                      Navigator.pop(context);
                    }
                    );
                  }),

            ],
          ),
        ),
      );
    },
  );
}
