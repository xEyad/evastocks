import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/custom_text_button.dart';

import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreviewFeedback extends StatefulWidget {
  final dynamic recommendation;
   PreviewFeedback({super.key,required this.recommendation});

  @override
  State<PreviewFeedback> createState() => _PreviewFeedbackState();
}

class _PreviewFeedbackState extends State<PreviewFeedback> {
  bool _isEmpty = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addNewFeedback,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: kMainColor),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios,color: kMainColor),
        ) ,      ),
      body:  Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
        Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Card(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundImage: NetworkImage(widget.recommendation['stock']['stockImage']),radius: 25,),
                                  const SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(' ${widget.recommendation['stock']['stockName']}',style: const TextStyle(fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 5,),
                                          Text('(${widget.recommendation['stock']['stockId']})',style: const TextStyle(color: Color.fromRGBO(206, 150, 84, 1),fontSize: 15)),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(widget.recommendation['recommendation_date'],style: const TextStyle(color: Color.fromRGBO(141, 141, 141, 1),fontWeight: FontWeight.w600),textDirection: TextDirection.ltr)
                                    ],),
                                  const Spacer(),
                                  Container(
                                    height: 40,
                                    width: 70,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: widget.recommendation['recommendation_type'] == AppLocalizations.of(context)!.buy ? const Color.fromRGBO(196, 227, 216, 1) : const Color.fromRGBO(244, 192, 192, 1),
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: Text('${ widget.recommendation['recommendation_type']}',style: TextStyle(color: widget.recommendation['recommendation_type'] == AppLocalizations.of(context)!.buy ? const Color.fromRGBO(78, 180, 142, 1) : Colors.red.shade900,fontWeight: FontWeight.w600,fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Container(
                              width: SizeUtility(context).width,
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                              color: const Color.fromRGBO(250, 250, 250, 1),
                              child: Text('${widget.recommendation['recommendation_text_ar']}',style: const TextStyle(
                                  color: Color.fromRGBO(112, 112, 112, 1)
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: SizeUtility(context).width * 25/100,child:  Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!.priceAtRecommendation,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center),
                                          const SizedBox(height: 5,),
                                          Text('${widget.recommendation['priceAtRecommendation']} ${AppLocalizations.of(context)!.sr}',style: const TextStyle(fontWeight: FontWeight.w700),)

                                        ],
                                      ),)
                                      ,SizedBox(width: SizeUtility(context).width * 25/100,child:  Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!.targetPrice,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center),
                                          const SizedBox(height: 5,),
                                          Text('${widget.recommendation['target_price']} ${AppLocalizations.of(context)!.sr}',style: const TextStyle(fontWeight: FontWeight.w700),)

                                        ],
                                      ),)
                                      ,SizedBox(width: SizeUtility(context).width * 25/100,child: Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!.priceToday,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center),
                                          const SizedBox(height: 5,),
                                          Text('${widget.recommendation['stockTodayPrice']}',style: const TextStyle(fontWeight: FontWeight.w700),)

                                        ],
                                      ),)

                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: SizeUtility(context).width * 25/100,child:  Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!.recommendationType,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center),
                                          const SizedBox(height: 5,),
                                          Text('${widget.recommendation['recommendationStrategy']}',style: const TextStyle(fontWeight: FontWeight.w700),)

                                        ],
                                      ),)
                                      ,SizedBox(width: SizeUtility(context).width * 30/100,child: Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!.profitChange,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center),
                                          const SizedBox(height: 5,),
                                          Text('${widget.recommendation['profitPercentage']}',style: TextStyle(fontWeight: FontWeight.w700,color: double.parse(widget.recommendation['profitPercentage']).isNegative ? const Color.fromRGBO(234, 63, 63, 1) : const Color.fromRGBO(78, 180, 142, 1,))),
                                        ],
                                      ),)
                                      ,SizedBox(width: SizeUtility(context).width * 25/100,child: Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!.recommendationDuration,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center),
                                          const SizedBox(height: 5,),
                                          Text('${DateTime.parse(widget.recommendation['recommendationDuration']).difference(DateTime.now()).inDays} ${AppLocalizations.of(context)!.day}',style: const TextStyle(fontWeight: FontWeight.w700),)
                                        ],
                                      ),)

                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: SizeUtility(context).width * 25/100,child:  Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!.stopLoss,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center),
                                          const SizedBox(height: 5,),
                                          Text('${widget.recommendation['stopLoss']}',style: const TextStyle(fontWeight: FontWeight.w700),)

                                        ],
                                      ),)
                                      ,SizedBox(width: SizeUtility(context).width * 30/100,child: Column(
                                        children: [
                                          Text(AppLocalizations.of(context)!.changePerToday,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center),
                                          const SizedBox(height: 5,),
                                          Text('${widget.recommendation['changeLossPercentage']}',style: TextStyle(fontWeight: FontWeight.w700,color: double.parse(widget.recommendation['changeLossPercentage']).isNegative ? const Color.fromRGBO(234, 63, 63, 1) : const Color.fromRGBO(78, 180, 142, 1,))),
                                        ],
                                      ),),
                                      SizedBox(width: SizeUtility(context).width * 25/100),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                    Column(
                                      children: [
                                        const SizedBox(height: 15,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            if(widget.recommendation['image1'] != null)
                                              ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.file(File(widget.recommendation['image1']),width:widget.recommendation['image2'] != null ? SizeUtility(context).width * .40 : SizeUtility(context).width * .85,height: 200,fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) => SizedBox(),)),
                                            if(widget.recommendation['image2'] != null)
                                              ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.file(File(widget.recommendation['image2']),width: SizeUtility(context).width * .40,height: 200,fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) => SizedBox(),))

                                          ],
                                        )
                                      ],
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15,),

                      ],
                    ),
                  ),
                ),

              ],
            ),
            /*if(_isLoading)
              LoadingIndicator(),*/
            const Spacer(),
            CustomButton(title: AppLocalizations.of(context)!.next, onPressed: () async{
              setState((){
                _isLoading = true;
              });
              await Provider.of<ServiceProvider>(context,listen: false).createRecommendation(stockId: widget.recommendation['stock']['stockId'], recommendationDate: widget.recommendation['recommendation_date'], recommendationType:  widget.recommendation['recommendation_type'] ==AppLocalizations.of(context)!.sell ?'2' : '1', recommendationStrategy: widget.recommendation['recommendationStrategy'], targetPrice: widget.recommendation['target_price'], stopLoss: widget.recommendation['stop_loss'], recommendationTextAr: widget.recommendation['recommendation_text_ar'], image1: widget.recommendation['image1'], image2: widget.recommendation['image2']).then((value) {
                  if(value['status']){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    showMessage(ctx: context, message:AppLocalizations.of(context)!.recommendationAdded, title: AppLocalizations.of(context)!.success,backgroundColor: Colors.green);
                  }else{
                    showMessage(ctx: context, message: value['data'], title: AppLocalizations.of(context)!.wrong);
                  }

                  setState(() {
                    _isLoading = false;
                  });
              });
            },),
            const SizedBox(height: 20,),
            CustomTextButton(title: AppLocalizations.of(context)!.close, onPressed: () {
              Navigator.of(context).pop();

            },)

          ],
        ),
      ),

    );
  }
}
