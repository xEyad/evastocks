import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/loading_indicator.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/size_utility.dart';

showHelpNosoohBottomSheet(BuildContext context) {
  final Future _getHelpNosooh =
      Provider.of<ServiceProvider>(context, listen: false).getIntro();
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      // <-- SEE HERE
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) => SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 6,
            width: 70,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(112, 112, 112, 1),
            ),
          ),
          FutureBuilder(
            future: _getHelpNosooh,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 25, left: 20, right: 20, bottom: 10),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.help,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.forGettingBenefits,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kMainColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      /*InkWell(onTap: (){
                      launchUrl(Uri.parse('${snapshot.data['data'].first['value']}'));
                   },
                     child: Container(
                       width: SizeUtility(context).width,
                       decoration: BoxDecoration(
                           color: kMainColor,
                           borderRadius: BorderRadius.circular(20)
                       ),
                       alignment: Alignment.center,
                       child: const ImageIcon(AssetImage('assets/icons/play.png',),color: Colors.white,size: 60),
                     ),
                   ),*/

                      SizedBox(
                        height: 230,
                        child: YoutubePlayer(
                          width: SizeUtility(context).width,
                          controller: YoutubePlayerController(
                            initialVideoId:
                                '${snapshot.data['data'].toString().substring(30)}',
                            flags: YoutubePlayerFlags(
                              autoPlay: true,
                              mute: true,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                          bufferIndicator: const LoadingIndicator(),

                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          whatsapp(context);
                        },
                        child: Row(
                          children: [
                            ImageIcon(AssetImage('assets/icons/whatsapp.png'),
                                color: HexColor('#305CD5'), size: 20),
                            SizedBox(
                              width: 10,
                            ),
                            Text(AppLocalizations.of(context)!.contactWhatsApp,
                                style: TextStyle(
                                    color: HexColor('#305CD5'),
                                    decoration: TextDecoration.underline))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        title: AppLocalizations.of(context)!.close,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              }
             return SizedBox();
            },
          )
        ],
      ),
    ),
  );
}
