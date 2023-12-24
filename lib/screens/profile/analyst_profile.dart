
import 'package:flutter/material.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/components/recommendation_container.dart';
import 'package:nosooh/screens/notifications/notifications.dart';
import 'package:nosooh/screens/payment/payment.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnalystProfile extends StatefulWidget {
  final String companyId;
  AnalystProfile({super.key,required this.companyId});

  @override
  State<AnalystProfile> createState() => _AnalystProfileState();
}

class _AnalystProfileState extends State<AnalystProfile> {

  dynamic profileData;

  String selectedFilter = 'all';
  String selectedStatusFilter = 'total';

  late var exp =(element)=> (selectedFilter == 'sale' ? element['recommendationType'] == AppLocalizations.of(context)!.sell :selectedFilter ==  AppLocalizations.of(context)!.buy ?element['recommendationType'] ==  AppLocalizations.of(context)!.buy :  element == element) && (selectedStatusFilter == 'hold'? element['recommendationStatus'] == 'انتظار' : selectedStatusFilter == 'success' ? element['recommendationStatus'] == AppLocalizations.of(context)!.nagha : selectedStatusFilter == 'fail' ? element['recommendationStatus'] == AppLocalizations.of(context)!.failed : element == element);

  bool _isLoading= true;

  @override
  void initState() {
    updateAnalyst();
    super.initState();
  }

  updateAnalyst(){
    setState(() {
      _isLoading = true;
    });
       Provider.of<ServiceProvider>(context,listen: false).getRecommendationByCompanyId(widget.companyId).then((value) {
         if(value['data'] != 'Not Subscribed'){
           setState(() {
             profileData = value['data'];
             _isLoading = false;
           });
         }else{
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Payment(),));
         }
       });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? const SizedBox() : SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 150,
                    color: const Color.fromRGBO(111, 107, 178, 0.1),
                    child: Row(
                      children: [
                        const SizedBox(width: 20,),
                        IconButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios,color: kMainColor),
                        ) ,
                        const Spacer(),
                        Row(
                          children: [
                            GestureDetector(onTap: () {
                              showHelpNosoohBottomSheet(context);

                            },child: Image.asset('assets/icons/help.png',height: 40,width: 40)),
                            GestureDetector(onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Notifications(),));
                            },child: Image.asset('assets/icons/notification.png',height: 26,width: 26)),

                            const SizedBox(width: 20,)
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppLocalizations.of(context)!.localeName
                      == 'en' ? Positioned(bottom: 0,left: 20,child: CircleAvatar(child: Image.network('${profileData['meta']['analyst'].first['companyImage']}',errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/user.png',),),radius: 30,)):
                  Positioned(bottom: 0,right: 20,child: CircleAvatar(child: Image.network('${profileData['meta']['analyst'].first['companyImage']}',errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/user.png',),),radius: 30,))
                ],
              ),
            ),
            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(

                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${profileData['meta']['analyst'].first['companyName']}',style: const TextStyle(color: kMainColor,fontSize: 20,fontWeight: FontWeight.w800),)
                          ,
                          //Text('${profileData.first['userName']}',style: TextStyle(fontWeight: FontWeight.w400,color: kSecondColor,fontSize: 16),)
                        ],
                      ),

                      profileData['meta']['analyst'].first['isFavourite'] == '1'? GestureDetector(
                        onTap: ()async{
                          setState(() {
                            _isLoading = true;
                          });
                          await Provider.of<ServiceProvider>(context,listen: false).unFavAnalyst(companyId: widget.companyId).then((value) {
                            updateAnalyst();
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kMainColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  AppLocalizations.of(context)!.followed,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white)
                              ),
                              Icon(Icons.person,color: Colors.white,)
                            ],
                          ),
                        ),
                      ) : GestureDetector(
                        onTap: ()async{
                          setState(() {
                            _isLoading = true;
                          });
                          await Provider.of<ServiceProvider>(context,listen: false).favAnalyst(companyId: widget.companyId).then((value) {
                            updateAnalyst();
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(111, 107, 178, 0.2),
                          ),

                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  AppLocalizations.of(context)!.following,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color.fromRGBO(111, 107, 178, 1))
                              ),
                              Icon(Icons.add,color: Color.fromRGBO(111, 107, 178, 1),)
                            ],),
                        ),
                      ),


                    ],
                  ),
                  const SizedBox(height: 20,),
                  Text('${profileData['meta']['analyst'].first['companyBio']}',style: const TextStyle(fontWeight: FontWeight.w400,color: kSecondColor,fontSize: 16),)
                  ,const SizedBox(height: 20),


                  Row(
                    children: [
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            selectedStatusFilter = 'total';
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(245, 245, 245, 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/like_green.png',height: 20),
                              const SizedBox(height: 10,),
                              Text(AppLocalizations.of(context)!.total,style: TextStyle(color: const Color.fromRGBO(46, 46, 46, 1),fontSize: 10,fontWeight: selectedStatusFilter == 'total' ? FontWeight.w600 : null),),
                              const SizedBox(height: 3,),
                              Text('${profileData['meta']['analyst'].first['companyTotalRecommendation']} ${AppLocalizations.of(context)!.recommendation}',style:  TextStyle(color: const Color.fromRGBO(46, 46, 46, 1),fontSize: 10,fontWeight: selectedStatusFilter == 'total' ? FontWeight.w600 : null)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            selectedStatusFilter = 'hold';
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(206, 150, 84, 0.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/clock.png',height: 20),
                              const SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context)!.holding} : ${profileData['meta']['analyst'].first['companyAwaitingCount']}',style:  TextStyle(color: const Color.fromRGBO(46, 46, 46, 1),fontSize: 10,fontWeight: selectedStatusFilter == 'hold' ? FontWeight.w600 : null),),
                              const SizedBox(height: 3,),
                              Text('%${profileData['meta']['analyst'].first['companyAwaitingPercentage']}',style:  TextStyle(color: const Color.fromRGBO(46, 46, 46, 1),fontSize: 10,fontWeight: selectedStatusFilter == 'hold' ? FontWeight.w600 : null)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            selectedStatusFilter = 'success';
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(196, 227, 216, 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/check.png',height: 20),
                              const SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context)!.mohaqqah} '
                                  ': ${profileData['meta']['analyst'].first['companySuccessCount']}'
                                ,style:  TextStyle(color: const Color.fromRGBO(46, 46, 46, 1),fontSize: 10,fontWeight: selectedStatusFilter == 'success' ? FontWeight.w600 : null),),
                              const SizedBox(height: 3,),
                              Text('%${profileData['meta']['analyst'].first['companySuccessPercentage']}',style:  TextStyle(color: const Color.fromRGBO(46, 46, 46, 1),fontSize: 10,fontWeight: selectedStatusFilter == 'success' ? FontWeight.w600 : null)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            selectedStatusFilter = 'fail';
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(244, 192, 192, 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/failed.png',height: 20),
                              const SizedBox(height: 10,),
                              Text('${AppLocalizations.of(context)!.notMohaqqah} : ${profileData['meta']['analyst'].first['companyFailedCount']}',style: TextStyle(color: const Color.fromRGBO(46, 46, 46, 1),fontSize: 10,fontWeight: selectedStatusFilter == 'fail' ? FontWeight.w600 : null),),
                              const SizedBox(height: 3,),
                              Text('%${profileData['meta']['analyst'].first['companyFailedPercentage']}',style:  TextStyle(color: const Color.fromRGBO(46, 46, 46, 1),fontSize: 10,fontWeight: selectedStatusFilter == 'fail' ? FontWeight.w600 : null)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  Align(alignment: Alignment.centerRight,child: Text(AppLocalizations.of(context)!.analystsRecommendations,style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.start)),
                  const SizedBox(height: 5),

                  Container(
                    width: SizeUtility(context).width * 85 /100,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:const Color.fromRGBO(0, 0, 0, 0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: selectedFilter == 'all'? Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(onTap: (){
                                setState(() {
                                  selectedFilter = 'all';
                                });
                              },child: Text(AppLocalizations.of(context)!.all,style: TextStyle(fontWeight: selectedFilter == 'all' ? FontWeight.w600 : FontWeight.w400,color: selectedFilter == 'all' ? Colors.blue.shade700 : null),textAlign: TextAlign.center,)),
                            ),
                          ) : InkWell(onTap: (){
                            setState(() {
                              selectedFilter = 'all';
                            });
                          },child: Text(AppLocalizations.of(context)!.all,style: TextStyle(fontWeight: selectedFilter == 'all' ? FontWeight.w600 : FontWeight.w400),textAlign: TextAlign.center,)),
                        ),
                        Container(
                          width: 1,
                          height: 10,
                          color: Colors.black12,
                        ),
                        Expanded(
                          child: selectedFilter == 'sale' ? Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(onTap: (){
                                setState(() {
                                  selectedFilter = 'sale';
                                });
                              },child: Text(AppLocalizations.of(context)!.sell,style: TextStyle(fontWeight: selectedFilter == 'sale' ? FontWeight.w600 : FontWeight.w400,color: selectedFilter == 'sale' ? Colors.blue.shade700 : null),textAlign: TextAlign.center,)),
                            ),
                          ) : InkWell(onTap: (){
                            setState(() {
                              selectedFilter = 'sale';
                            });
                          },child: Text(AppLocalizations.of(context)!.sell,style: TextStyle(fontWeight: selectedFilter == 'sale' ? FontWeight.w600 : FontWeight.w400),textAlign: TextAlign.center,)),
                        ),
                        Container(
                          width: 1,
                          height: 10,
                          color: Colors.black12,
                        ),
                        Expanded(
                          child: selectedFilter == 'buy' ? Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(onTap: (){
                                      setState(() {
                                      selectedFilter = 'buy';
                                      });
                                      },child: Text(AppLocalizations.of(context)!.buy,style: TextStyle(fontWeight: selectedFilter == 'buy' ? FontWeight.w600 : FontWeight.w400,color: selectedFilter == 'buy' ? Colors.blue.shade700 : null),textAlign: TextAlign.center,)),
                            ),
                          ) : InkWell(onTap: (){
                            setState(() {
                              selectedFilter = 'buy';
                            });
                          },child: Text(AppLocalizations.of(context)!.buy,style: TextStyle(fontWeight: selectedFilter == 'buy' ? FontWeight.w600 : FontWeight.w400),textAlign: TextAlign.center,)),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Row(children: [

                      ]),
                      const SizedBox(height: 25),
                      Column(
                          children: profileData['data'].where(exp).map<Widget>((rec)=> RecommendationContainer(recommendation: rec,likeRecommendationFunction: ()async{
                            if(rec['isLiked'] == '0'){
                              setState(() {
                                _isLoading = true;
                              });
                              await Provider.of<ServiceProvider>(context,listen: false).likeRecommendation(rec['recommendationId']).then((value) {
                                updateAnalyst();
                              });
                            }else{
                              setState(() {
                                _isLoading = true;
                              });
                              await Provider.of<ServiceProvider>(context,listen: false).disLikeRecommendation(rec['recommendationId']).then((value) {
                                updateAnalyst();
                              });
                            }
                          },notifyMeFunction: ()async{

                            if(rec['notifyMe'] == '0'){
                              setState(() {
                                _isLoading = true;
                              });
                              await Provider.of<ServiceProvider>(context,listen: false).recommendationNotify(rec['recommendationId']).then((value) {
                                updateAnalyst();
                              });
                            }else{
                              setState(() {
                                _isLoading = true;
                              });
                              await Provider.of<ServiceProvider>(context,listen: false).recommendationDeNotify(rec['recommendationId']).then((value) {
                                 updateAnalyst();
                              });
                            }
                          },)).toList()
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      )

    );
  }
}
