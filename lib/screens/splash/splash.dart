import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:nosooh/screens/tabs/tabs.dart';
import 'package:nosooh/screens/walkthrough/select_app_language.dart';
import 'package:nosooh/services/api_service.dart';
import 'package:nosooh/services/token_manager.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future<Widget> futureCall() async {
    late final _getLoggedInStatus = Provider.of<APIService>(context,listen: false).getJWTToken();


    final res = await _getLoggedInStatus.then((token) async {
       if(token != null){
         return  Tabs();
       }else{
         return  const SelectAppLanguage();
       }
      });

    return Future.value(res);
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/logos/logo.png'),
      logoWidth: SizeUtility(context).width * 20/100,
      backgroundColor: Colors.white,
      showLoader: false,
      futureNavigator: futureCall(),
      durationInSeconds: 5,
    );
  }
}
