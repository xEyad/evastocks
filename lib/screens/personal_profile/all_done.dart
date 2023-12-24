import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/screens/personal_profile/finance_data.dart';
import 'package:nosooh/screens/personal_profile/risk_recognition.dart';
import 'package:nosooh/screens/tabs/tabs.dart';
import 'package:nosooh/utils/colors.dart';

import '../../utils/size_utility.dart';

class AllDone extends StatefulWidget {
  const AllDone({super.key});

  @override
  State<AllDone> createState() => _AllDoneState();
}

class _AllDoneState extends State<AllDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: const Text('الملف الشخصي',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: kMainColor),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios,color: kMainColor),
        ) ,      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Column(
                  children: [
                    Image.asset('assets/icons/personal_data.png',width: 25,),
                    SizedBox(height: 10,),
                    Text('البيانات الشخصية',style: TextStyle(color: Color.fromRGBO(111, 107, 178, 1)),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: DottedLine(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    lineLength:  SizeUtility(context).width * 13/100,
                    lineThickness: .8,
                    dashLength: 1.0,
                    dashColor: Colors.transparent,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Color.fromRGBO(111, 107, 178, 1),
                    dashGapRadius: 0.0,
                  ),
                ),
                Column(
                  children: [
                    Image.asset('assets/icons/coin.png',width: 25,color: Color.fromRGBO(111, 107, 178, 1)),
                    SizedBox(height: 10,),
                    Text('البيانات المالية',style: TextStyle(color: Color.fromRGBO(111, 107, 178, 1)),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: DottedLine(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    lineLength:  SizeUtility(context).width * 13/100,
                    lineThickness: .8,
                    dashLength: 1.0,
                    dashColor: Colors.transparent,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Color.fromRGBO(111, 107, 178, 1),
                    dashGapRadius: 0.0,
                  ),
                ),
                Column(
                  children: [
                    Image.asset('assets/icons/warning.png',width: 25,color: Color.fromRGBO(111, 107, 178, 1)),
                    SizedBox(height: 10,),
                    Text('معرفة المخاطر',style: TextStyle(color: Color.fromRGBO(111, 107, 178, 1)),)
                  ],
                ),
              ],
            ),
            SizedBox(height: 30,),
            Lottie.asset('assets/images/thumb_up.json'),
            const Text('أمورك في السليم',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w700,color: kMainColor),),

            const Spacer(),
            CustomButton(title: 'التالي', onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Tabs(),),(route) => false,);
            },)
          ],
        ),
      ),
    );
  }
}
