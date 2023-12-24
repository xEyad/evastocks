import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/custom_text_button.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/notification.mp4')
      ..initialize().then((_) {
        _controller.play();

        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.settings,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: kMainColor),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios,color: kMainColor),
        ) ,      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30,),

            //  Lottie.asset('assets/videos/notifications_settings.json'),
            _controller.value.isInitialized
                ? SizedBox(
              height: 180,
                  child: AspectRatio(
              aspectRatio: 3/3,
              child: VideoPlayer(_controller),
            ),
                )
                : Container(),
            const SizedBox(height: 80,),

            Card(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child: Row(
                children: [
                   ImageIcon(const AssetImage('assets/icons/notifications_settings.png',),color: HexColor('#31D5C8'),size: 20),
                  const SizedBox(width: 15,),
                  Text(AppLocalizations.of(context)!.appNotifications,style: const TextStyle(color: kMainColor,fontSize: 17,fontWeight: FontWeight.w500),),
                  const Spacer(),
                  Switch(value: true, onChanged: (value) {
                    
                  },
                  activeColor: selectedNavIconColor,)

                ],
              ),
            ),),
            const SizedBox(height: 10,),

            GestureDetector(
              onTap: (){
                showDialog(

                  context: context, builder: (context) => AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  title:const Center(child: Text('إرسال إشعار تجريبي',style: TextStyle(color: kMainColor,fontSize: 19,fontWeight: FontWeight.w700),)),
                 content: IntrinsicHeight(
                   child: Column(
                     children: [
                       Center(child: Text(textAlign: TextAlign.center,AppLocalizations.of(context)!.willSendNotification,style: const TextStyle(color: kSecondColor,fontSize: 16,fontWeight: FontWeight.w500),)),
                       const SizedBox(height: 30),
                       CustomButton(title: AppLocalizations.of(context)!.send, onPressed: () {

                       },),
                       const SizedBox(height: 5,),

                       CustomTextButton(title: 'إلغاء', onPressed: () {

                       },)
                     ],
                   ),
                 ),
                ),);
              },
              child:  Card(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                child: Row(
                  children: [
                    ImageIcon(const AssetImage('assets/icons/send_trial_notification.png',),color: HexColor('#31D5C8'),size: 20),
                    const SizedBox(width: 15,),
                    const Text('إرسال إشعار تجريبي',style: TextStyle(color: kMainColor,fontSize: 17,fontWeight: FontWeight.w500),),

                  ],
                ),
              ),),
            ),
            const SizedBox(height: 10,),


          ],
        ),
      ),
    );
  }
}
