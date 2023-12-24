import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

import '../../utils/functions.dart';

class AboutAppDetails extends StatefulWidget {
  const AboutAppDetails({super.key});

  @override
  State<AboutAppDetails> createState() => _AboutAppDetailsState();
}

class _AboutAppDetailsState extends State<AboutAppDetails> {
  late final Future _getContent =
      Provider.of<ServiceProvider>(context).getContent2(key: 'about-us');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.aboutApp,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: kMainColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: SizeUtility(context).width,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FutureBuilder(
                    future: _getContent,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        if (snapshot.data['data'] != null) {
                          return  Html(
                            data:snapshot.data['data'],
                            style: {
                              'body': Style(
                                  color: const Color.fromRGBO(
                                    81,
                                    81,
                                    81,
                                    1,
                                  ),

                              ),
                            },
                          );/*Text(
                            removeHtmlTags(snapshot.data['data'],),
                           style: const TextStyle(
                                color: Color.fromRGBO(
                              81,
                              81,
                              81,
                              1,
                            ),
                           ),
                          );*/
                        }
                        return const Text('لم تتم إضافة البيانات من الخادم');
                      }
                      return SizedBox();
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
