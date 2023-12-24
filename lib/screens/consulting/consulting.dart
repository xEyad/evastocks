import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/screens/notifications/notifications.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Consulting extends StatefulWidget {
  const Consulting({super.key});

  @override
  State<Consulting> createState() => _ConsultingState();
}

class _ConsultingState extends State<Consulting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.consultations,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: kMainColor),),
        actions: [
          GestureDetector(onTap: () {
            showHelpNosoohBottomSheet(context);

          },child: Image.asset('assets/icons/help.png',height: 40,width: 40)),
          GestureDetector(onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Notifications(),));
          },child: Image.asset('assets/icons/notification.png',height: 26,width: 26)),

          const SizedBox(width: 20,)
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: SizeUtility(context).height * .10,),
            Lottie.asset('assets/videos/04.json',width: SizeUtility(context).width * 90 /100,),
            Center(child: Text(AppLocalizations.of(context)!.waitForUsSoon,style: TextStyle(fontSize: 27,fontWeight: FontWeight.w700,color: kMainColor),)),


          ],
        ),
      ),
    );
  }
}
