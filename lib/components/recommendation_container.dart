import 'package:flutter/material.dart';
import 'package:nosooh/components/network_image_viewer.dart';
import 'package:nosooh/screens/about_app/info_disclaimer.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendationContainer extends StatelessWidget {
  final recommendation;
  Function() notifyMeFunction;
  Function() likeRecommendationFunction;
   RecommendationContainer({
    super.key,
    required this.recommendation,
    required this.notifyMeFunction,
    required this.likeRecommendationFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Row(
                      children: [
                         CircleAvatar(backgroundImage: NetworkImage(recommendation['stockImage']),radius: 25,),
                        const SizedBox(width: 10,),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(' ${recommendation['stockName']}',style: const TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 5,),
                                Text('(${recommendation['stockId']})',style: const TextStyle(color: Color.fromRGBO(206, 150, 84, 1),fontSize: 15)),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Text(recommendation['recommendationDate'],style: const TextStyle(color: Color.fromRGBO(141, 141, 141, 1),fontWeight: FontWeight.w600),textDirection: TextDirection.ltr)
                          ],),
                        const Spacer(),
                        Container(
                          height: 40,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: recommendation['recommendationType'] == AppLocalizations.of(context)!.buy ? const Color.fromRGBO(196, 227, 216, 1) : const Color.fromRGBO(244, 192, 192, 1),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text('${recommendation['recommendationType']}',style: TextStyle(color:recommendation['recommendationType'] == AppLocalizations.of(context)!.buy ? const Color.fromRGBO(78, 180, 142, 1) : Colors.red.shade900,fontWeight: FontWeight.w600,fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    width: SizeUtility(context).width,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                    color: const Color.fromRGBO(250, 250, 250, 1),
                    child: Text('${recommendation['recommendationText']}',style: const TextStyle(
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
                                Text(AppLocalizations.of(context)!.priceAtRecommendation,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center,),
                                const SizedBox(height: 5,),
                                Text('${recommendation['priceAtRecommendation']} ${AppLocalizations.of(context)!.day}',style: const TextStyle(fontWeight: FontWeight.w700),)

                              ],
                            ),)
                            ,SizedBox(width: SizeUtility(context).width * 25/100,child:  Column(
                              children: [
                                Text(AppLocalizations.of(context)!.targetPrice,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center,),
                                const SizedBox(height: 5,),
                                Text('${recommendation['targetPrice']} ${AppLocalizations.of(context)!.day}',style: const TextStyle(fontWeight: FontWeight.w700),)

                              ],
                            ),)
                            ,SizedBox(width: SizeUtility(context).width * 25/100,child: Column(
                              children: [
                                Text(AppLocalizations.of(context)!.priceToday,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center,),
                                const SizedBox(height: 5,),
                                Text('${recommendation['stockTodayPrice']}',style: const TextStyle(fontWeight: FontWeight.w700),)

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
                                Text(AppLocalizations.of(context)!.recommendationType,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center,),
                                const SizedBox(height: 5,),
                                Text('${recommendation['recommendationStrategy']}',style: const TextStyle(fontWeight: FontWeight.w700),)

                              ],
                            ),)
                            ,SizedBox(width: SizeUtility(context).width * 30/100,child: Column(
                              children: [
                                Text(AppLocalizations.of(context)!.profitChange,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center,),
                                const SizedBox(height: 5,),
                                Text('${recommendation['profitPercentage']}',style: TextStyle(fontWeight: FontWeight.w700,color: double.parse(recommendation['profitPercentage']).isNegative ? const Color.fromRGBO(234, 63, 63, 1) : const Color.fromRGBO(78, 180, 142, 1,))),
                              ],
                            ),)
                            ,SizedBox(width: SizeUtility(context).width * 25/100,child: Column(
                              children: [
                                Text(AppLocalizations.of(context)!.recommendationDuration,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center,),
                                const SizedBox(height: 5,),
                                Text('${recommendation['recommendationDuration']} ${AppLocalizations.of(context)!.day}',style: const TextStyle(fontWeight: FontWeight.w700),)

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
                                Text(AppLocalizations.of(context)!.stopLoss,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center,),
                                const SizedBox(height: 5,),
                                Text('${recommendation['stopLoss']}',style: const TextStyle(fontWeight: FontWeight.w700),)

                              ],
                            ),)
                            ,SizedBox(width: SizeUtility(context).width * 30/100,child: Column(
                              children: [
                                Text(AppLocalizations.of(context)!.changePerToday,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(81, 81, 81, 1)),textAlign: TextAlign.center,),
                                const SizedBox(height: 5,),
                                Text('${recommendation['achievedPercentage']}',style: TextStyle(fontWeight: FontWeight.w700,color: double.parse(recommendation['achievedPercentage']).isNegative ? const Color.fromRGBO(234, 63, 63, 1) : const Color.fromRGBO(78, 180, 142, 1,))),
                              ],
                            ),),
                            SizedBox(width: SizeUtility(context).width * 25/100),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(250, 250, 250, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:  Row(
                                children: [
                                  recommendation['recommendationStatus']  == AppLocalizations.of(context)!.nagha? const ImageIcon(AssetImage('assets/icons/check.png'),color: Color.fromRGBO(78, 180, 142, 1)) : recommendation['recommendationStatus'] == AppLocalizations.of(context)!.awaiting  ?ImageIcon(const AssetImage('assets/icons/hold.png'),size: 25,color: Colors.red.shade900,) : const ImageIcon(AssetImage('assets/icons/failed.png'),),
                                  const SizedBox(width: 8,),
                                  SizedBox( width: SizeUtility(context).width * .12,
                                      child: Text('${recommendation['recommendationStatus']}',style: const TextStyle(color: Color.fromRGBO(111, 107, 178, 1)),maxLines: 2,overflow: TextOverflow.ellipsis,))
                                ],
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(250, 250, 250, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const ImageIcon(AssetImage('assets/icons/business_analysis.png'),color: Color.fromRGBO(78, 180, 142, 1)),
                                  const SizedBox(width: 5,),
                                  SizedBox(width: SizeUtility(context).width * .15,child: Text('${recommendation['companyName']?? ''}',style: const TextStyle(color: Color.fromRGBO(111, 107, 178, 1)),maxLines: 2,overflow: TextOverflow.ellipsis,))
                                ],
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(250, 250, 250, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child:  Row(
                                children: [
                                  const ImageIcon(AssetImage('assets/icons/pie_chart.png'),color: Color.fromRGBO(78, 180, 142, 1)),
                                  const SizedBox(width: 5,),
                                  SizedBox(width: SizeUtility(context).width * .15,child: Text('${recommendation['sectorName']}',style: const TextStyle(color: Color.fromRGBO(111, 107, 178, 1)),maxLines: 2,overflow: TextOverflow.ellipsis,))
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  if(recommendation['images'].isNotEmpty)
                   Column(
                     children: [
                       const SizedBox(height: 15,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           GestureDetector(onTap: () {
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => NetworkPictureViewer(imagePath: recommendation['images'][0]),));
                           },child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.network(recommendation['images'][0],width: recommendation['images'].length >= 2 ? SizeUtility(context).width * .40 : SizeUtility(context).width * .85,height: 200,fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) => const SizedBox(),))),
                           if(recommendation['images'].length >= 2)
                           GestureDetector(onTap: (){
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => NetworkPictureViewer(imagePath: recommendation['images'][1]),));
                           },child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.network(recommendation['images'][1],width: SizeUtility(context).width * .40,height: 200,fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) => const SizedBox(),)))

                         ],
                       )
                     ],
                   )
                ],
              ),
              const SizedBox(height: 15,),

              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Expanded(child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(111, 107, 178, 0.15),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),),

                      ),
                      child: IconButton(icon:  recommendation['notifyMe'] == '0'?  const ImageIcon(AssetImage('assets/icons/notification_outlined.png'),color:Color.fromRGBO(111, 107, 178, 1 ) ,size: 20) : const ImageIcon(AssetImage('assets/icons/notification_filled.png'),color:Color.fromRGBO(111, 107, 178, 1 )),onPressed: notifyMeFunction),
                    )),
                    Expanded(child: Container(
                      height: 40,

                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(111, 107, 178, 0.1)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${recommendation['likesCount']}',style: const TextStyle(color: Color.fromRGBO(111, 107, 178, 1 ))),
                          IconButton(icon: recommendation['isLiked'] == '0' ? const ImageIcon(AssetImage('assets/icons/like.png'),color:   Color.fromRGBO(111, 107, 178, 1 ),size: 20) : const ImageIcon(AssetImage('assets/icons/like_filled.png'),color:   Color.fromRGBO(111, 107, 178, 1 ),size: 20),onPressed: likeRecommendationFunction),
                        ],
                      ),

                    )),
                    Expanded(child: Container(
                      height: 40,

                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                          color: Color.fromRGBO(111, 107, 178, 0.15)
                      ),
                      child: IconButton(icon: const ImageIcon(AssetImage('assets/icons/share.png'),color: Color.fromRGBO(111, 107, 178, 1 ),size: 20),onPressed: (){
                        Share.share('${recommendation['recommendationText']} لمشاهدة المزيد من التحليلات قم بتحميل تطبيق نصح المالية https://nosooh.com/ ', subject: 'قم بالإطلاع على توصية المحلل ${recommendation['companyName']}');

                      }),

                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  InfoDisclaimer(title: AppLocalizations.of(context)!.bayanE5la2),));
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(251, 251, 251, 1),
                borderRadius: BorderRadius.circular(20)
            ),
            child:  Text(AppLocalizations.of(context)!.withinUsingThisApp,style: const TextStyle(
                color: Color.fromRGBO(234, 63, 63, 1),
                fontWeight: FontWeight.w500
            ),),
          ),
        ),

      ],
    );
  }
}