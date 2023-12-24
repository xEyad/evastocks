import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nosooh/components/network_image_viewer.dart';
import 'package:nosooh/utils/size_utility.dart';



void showCustomDialog(
    {required BuildContext context,
    required String title,
    required String body,
      bool isHtml = false,
    List<String>? images}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.8),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 2,sigmaX: 2),
        child: AlertDialog(
          elevation: 30,
          contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
          titlePadding: EdgeInsets.only(top: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
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
          content: Container(
            constraints: BoxConstraints(
              maxHeight: 500,
            ),
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  isHtml ? HtmlWidget(
                    body,
                    customStylesBuilder: (element) {
                      return null;
                    },

                    customWidgetBuilder: (element) {

                      return null;
                    },

                    // this callback will be triggered when user taps a link
                    onTapUrl: (p0) {
                      return true;
                    },


                    renderMode: RenderMode.column,

                    // set the default styling for text
                    textStyle: TextStyle(fontSize: 14),
                  ) : Text(
                    body,
                  ),
                  if(images!= null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images.map<Widget>((img) =>GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NetworkPictureViewer(
                                  imagePath: img),
                            ));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                img,

                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(),
                              ))),).toList()
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );


}

