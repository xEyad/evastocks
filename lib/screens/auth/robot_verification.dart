
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/screens/Auth/verify_otp.dart';
import 'package:nosooh/services/auth_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';

class RobotVerification extends StatefulWidget {
  final Map questionAndAnswers;
  const RobotVerification({super.key,required this.questionAndAnswers});

  @override
  State<RobotVerification> createState() => _RobotVerificationState();
}

class _RobotVerificationState extends State<RobotVerification> {
  late String question = widget.questionAndAnswers['question'];
  late List<dynamic> answers = widget.questionAndAnswers['challenge'];
  int MAX = 100;
  int? selectedAnswer;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Lottie.asset('assets/videos/05.json',height: SizeUtility(context).height * 0.30)),
              const SizedBox(height: 20,),
              Text(AppLocalizations.of(context)!.dearUserCalc,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,color: kMainColor),),
              const SizedBox(height: 10,),
               Text('$question',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,color: kMainColor),),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: answers.map((e) => GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedAnswer = e;
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.symmetric(horizontal: 10),

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: selectedAnswer == e ? kMainColor : Color.fromRGBO(249, 249, 249, 1),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Text(e.toString(),style: TextStyle(fontSize: 28,fontWeight: FontWeight.w700,color:selectedAnswer == e? Colors.white: kMainColor)),
                  ),
                ),).toList()
              ),
              SizedBox(height: 50,),
              CustomButton(title: AppLocalizations.of(context)!.next, onPressed: submit,)
            ],
          ),
        ),
      ),
    );
  }

  submit()async{
    await Provider.of<AuthProvider>(context,listen: false).verifyChallenge(answer: selectedAnswer.toString()).then((value)async {
      if(value['status'] == true){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => VerifyOTP(),),(route) => false,);
      }else{
        showMessage(ctx: context, message:AppLocalizations.of(context)!.wrongAnswer, title: AppLocalizations.of(context)!.wrong);
        }
    });


  }

}
