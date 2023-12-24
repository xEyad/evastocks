import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nosooh/screens/Auth/robot_verification.dart';
import 'package:nosooh/screens/tabs/tabs.dart';
import 'package:nosooh/services/auth_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  int _remainingTime = 60; //initial time in seconds

  late Timer _timer;

  bool _isLoading = false;
  @override
  void initState() {
    _startTimer();

    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color:const Color.fromRGBO(242, 242, 242, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  late final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: const Color.fromRGBO(242, 242, 242, 1)),
    borderRadius: BorderRadius.circular(10),
  );

  late final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration!.copyWith(
      color: const Color.fromRGBO(242, 242, 242, 1)
    ),
  );
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Text(AppLocalizations.of(context)!.login,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: kMainColor),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios,color: kMainColor),
        ) ,      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: SizeUtility(context).width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeUtility(context).height * .10,),
                Image.asset('assets/logos/icon.png',height: 70,fit: BoxFit.cover),
                const SizedBox(height: 30,),

                Text(AppLocalizations.of(context)!.verifyPhoneNumber,style: TextStyle(fontSize: 28,fontWeight: FontWeight.w700,color: kMainColor),),
                const SizedBox(height: 10,),
                 SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.writeTheCode,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400,color: kSecondColor),),
                      const SizedBox(width: 5,),
                      Text(Provider.of<AuthProvider>(context).phoneNumber?? '',style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w400,color:  Color.fromRGBO(206, 150, 84, 1),),),

                    ],
                ),
                 ),
                const SizedBox(height: 40,),

                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Center(
                    child: Pinput(
                      defaultPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: const Color.fromRGBO(234, 239, 243, 1),
                        ),
                      ),
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      keyboardType: TextInputType.number,
                      /*validator: (s) {
                        return s == '2222' ? null : 'Pin is incorrect';
                      },*/
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: onPinComplete,
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                 Row(
                  children: [
                    Text(AppLocalizations.of(context)!.willArriveWithin,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: kSecondColor),),
                    const SizedBox(width: 5,),
                    Text(_remainingTime.toString(),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color:  Color.fromRGBO(206, 150, 84, 1),),),
                  ],
                ),
                const SizedBox(height: 30,),
                GestureDetector(
                  onTap: _remainingTime == 0 ? resendCode : null,
                  child:  Row(
                    children: [
                      ImageIcon(const AssetImage('assets/icons/reloading.png'),size: 20,color: _remainingTime == 0 ? kMainColor : kSecondColor),
                      const SizedBox(width: 5,),
                      Text(AppLocalizations.of(context)!.sendCodeAgain,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: _remainingTime == 0 ? kMainColor :kSecondColor),),
                     ],
                  ),
                ),
                const SizedBox(height: 50,),

                /*CustomButton(title: 'التالي', onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RobotVerification(),));

                },)*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  resendCode()async{
    await Provider.of<AuthProvider>(context,listen: false).login().then((value) {
      if(value['status'] == true){
        setState(() {
          _remainingTime = 10;
        });
        _startTimer();
        showMessage(ctx: context, message: AppLocalizations.of(context)!.codeSent, title: AppLocalizations.of(context)!.success,backgroundColor: Colors.green.shade800);
      }else{
        showMessage(ctx: context, message: AppLocalizations.of(context)!.tryAgainLater, title: AppLocalizations.of(context)!.wrong);
      }
    });
  }
  
  onPinComplete(String otp)async{
    setState(() {
      _isLoading = true;
    });
    await Provider.of<AuthProvider>(context,listen: false).verifyOTP(otp: otp).then((value)async {
      if(value['status'] == true){
        print( value['data']['token']);
        await Provider.of<AuthProvider>(context,listen: false).updateJWTToken(jwtToken: value['data']['token']).then((_){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  Tabs(),),(route) => false,);

        });
      }else{
         if(value['data']== 'robot-verification'){
           Navigator.of(context).push(MaterialPageRoute(builder: (context) => RobotVerification(questionAndAnswers: value['questionAndAnswers']),));
         }else{
           showMessage(ctx: context, message: AppLocalizations.of(context)!.tryAgainLater, title: AppLocalizations.of(context)!.wrong);
         }
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((e){
      showMessage(ctx: context, message: AppLocalizations.of(context)!.tryAgainLater, title: AppLocalizations.of(context)!.wrong);
    });
  }
}
