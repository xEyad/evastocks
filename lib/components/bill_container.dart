import 'package:flutter/material.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/pdf_viewer.dart';
import 'package:nosooh/screens/my_bills/bill_webview.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BillContainer extends StatelessWidget {
  final dynamic bill;
  const BillContainer({
    super.key,
    required this.bill
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                    bill['image'].isNotEmpty?  CircleAvatar(
                        backgroundImage: NetworkImage(bill['image'],),
                        backgroundColor: Color.fromRGBO(217, 217, 217, 1))
                       : CircleAvatar(
                        child: Image.asset('assets/icons/eva_small_icon.png',width: 25),
                        backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                      ),
                      SizedBox(width: 10,),
                      Text(bill['name'] ?? 'لا يوجد اسم',style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: kMainColor),),

                    ],
                  ),
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.startDate,style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(0.7)),),
                      SizedBox(height: 5,),
                      Text(bill['start_date'] ?? '',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: kMainColor),),

                    ],
                  ),

                  Column(
                    children: [
                      Text( AppLocalizations.of(context)!.endDate,style:  TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(0.7)),),
                      SizedBox(height: 5,),
                      Text(bill['end_date'] ?? '',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: kMainColor),),

                    ],
                  )
                ],
              ),
            ),
          /*  SizedBox(height: 10,),
            CustomButton(title:  AppLocalizations.of(context)!.downloadBill, onPressed: ()async {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillWebView( hyperLink: bill['pdf'],),));

           //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFViewer(pdfUrl: bill['pdf']),));
            },fontSize: 13,borderRadius: 10,height: 40,)*/
          ],
        ),
      ),
    );
  }
}