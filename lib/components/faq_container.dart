import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nosooh/utils/colors.dart';

import '../utils/functions.dart';

class FAQContainer extends StatelessWidget {
  FAQContainer({super.key, required this.qs});

  dynamic qs;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 15),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Flexible(
                // This will make the title text flexible within the available space
                child:

                Html(
                  data:qs['title'],
                  style: {
                    'body': Style(
                      color: kMainColor,
                      fontSize: FontSize(17),
                        fontWeight: FontWeight.w500
                    ),
                  },
                ),
                // Text(
                //   removeHtmlTags(qs['title']),
                //   overflow: TextOverflow
                //       .ellipsis, // This will show "..." when the text overflows
                //   style: TextStyle(
                //       color: kMainColor,
                //       fontSize: 17,
                //       fontWeight: FontWeight.w500),
                // ),
              ),
            ],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
            child:

            Html(
              data:qs['content'],
              style: {
                'body': Style(
                    color: kMainColor,
                    fontSize: FontSize(15),
                    fontWeight: FontWeight.w500
                ),
              },
            ),
            // Text(
            //
            //   removeHtmlTags(qs['content']),
            //   textAlign: TextAlign.start,
            //   style: TextStyle(
            //       color: kSecondColor,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w500),
            // ),
          ),
        ],
      ),
    );
  }
}
