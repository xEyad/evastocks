import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/components/recommendation_container.dart';
import 'package:nosooh/screens/notifications/notifications.dart';
import 'package:nosooh/screens/update_profile/update_profile.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
   Profile({super.key,});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future _getProfile = Provider.of<ServiceProvider>(context,listen: false).getProfile();

  String? selectedFilter = '3';
  //var exp = (element) => element == element;
  String recommendationTypeFilter = 'all';
  String recommendationStrategyFilter = 'all';
  String analyticsFilter = 'all';

  List recommendations = [];

  int cursor = 1;
  final TextEditingController _searchController = TextEditingController();
  static final _paginationController = ScrollController();
  bool _isLoading = false;

  initScrollingListener() {
    _paginationController.addListener(() {
      if (_paginationController.position.pixels ==
          _paginationController.position.maxScrollExtent
      ) {
        setState(() {
          cursor ++;
        });
        print(cursor);
        updateMyRecsWithPagination();
      }
    });
  }

  updateMyRecs(){

    setState(() {
      cursor = 1;
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context,listen: false).getRecommendationList(searchQuery: _searchController.text,cursor: cursor,appliedFilter: selectedFilter,recommendationStrategy: recommendationStrategyFilter == 'modarpa' ? '2' : recommendationStrategyFilter == 'estsmar' ? '1' : null,
        recommendationType: recommendationTypeFilter == 'buy' ? 'Buy' : recommendationTypeFilter == 'sell' ? 'Sell' : null,
        favourite: analyticsFilter == 'fav' ? '1' : null,isMine: analyticsFilter == 'mine' ? '1' : null,status: analyticsFilter=='hold'? '3' :analyticsFilter=='success'? '1' : analyticsFilter=='failed'?'2' : null ).then((value) {
      setState(() {
       // recommendations = value['data'].where((item)=>item['is_mine'] == 1).toList();
        recommendations = value['data'].toList();

        if(analyticsFilter == 'all'){
         // recommendations = value['data'].where((item)=>item['is_mine'] == 1).toList();
          recommendations = value['data'].toList();
        }else{
          recommendations = value['data'].where((item)=>/*item['is_mine'] == 1 &&*/ (analyticsFilter == 'hold'? item['recommendationStatus' ]== AppLocalizations.of(context)!.awaiting :analyticsFilter == 'success'? item['recommendationStatus']== AppLocalizations.of(context)!.nagha : item['recommendationStatus'] == AppLocalizations.of(context)!.failed ) ).toList();
        }
        _isLoading = false;
      });
    });
  }

  updateMyRecsWithPagination(){

    setState(() {
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context,listen: false).getRecommendationList(searchQuery: _searchController.text,cursor: cursor,appliedFilter: selectedFilter,recommendationStrategy: recommendationStrategyFilter == 'modarpa' ? '2' : recommendationStrategyFilter == 'estsmar' ? '1' : null,
        recommendationType: recommendationTypeFilter == 'buy' ? 'Buy' : recommendationTypeFilter == 'sell' ? 'Sell' : null,
        favourite: analyticsFilter == 'fav' ? '1' : null,isMine: analyticsFilter == 'mine' ? '1' : null,status: analyticsFilter=='hold'? '3' :analyticsFilter=='success'? '1' : analyticsFilter=='failed'?'2' : null ).then((value) {
      setState(() {
        if(analyticsFilter == 'all'){
          recommendations.addAll(value['data'].where((item)=>item['is_mine'] == 1).toList());
        }else{
          recommendations.addAll( value['data'].where((item)=>item['is_mine'] == 1 && (analyticsFilter == 'hold'? item['recommendationStatus' ]== AppLocalizations.of(context)!.awaiting :analyticsFilter == 'success'? item['recommendationStatus']== AppLocalizations.of(context)!.nagha : item['recommendationStatus'] == AppLocalizations.of(context)!.failed ) ).toList());
        }
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    initScrollingListener();
    updateMyRecs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getProfile,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              controller: _paginationController,
              child: Column(
                children: [

                  SizedBox(
                    height: 170,

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
                        AppLocalizations.of(context)!.localeName == 'en' ?
                        Positioned(bottom: 0,left: 20,child: ClipOval(child: SizedBox.fromSize(size: const Size.fromRadius(25),child: Image.network(snapshot.data['data'].first['image'],fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/user.png',),)),)):
                        Positioned(bottom: 0,right: 20,child: ClipOval(child: SizedBox.fromSize(size: const Size.fromRadius(25),child: Image.network(snapshot.data['data'].first['image'],fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/user.png',),)),)),
                      ],
                    ),
                  ),
              //    const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data['data'].first['name'].isEmpty? '' : snapshot.data['data'].first['name'],style: const TextStyle(color: kMainColor,fontSize: 20,fontWeight: FontWeight.w800),)
                                  ,Text(snapshot.data['data'].first['userName'] ?? '',style: const TextStyle(fontWeight: FontWeight.w400,color: kSecondColor,fontSize: 16),)
                                ],
                              ),
                            ),

                            ElevatedButton.icon(icon: const ImageIcon(AssetImage('assets/icons/edit.png'),size: 15),onPressed: ()async {
                              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateProfile(profileData: snapshot.data['data'].first,),)).then((value) {
                                setState(() {
                                  _getProfile = Provider.of<ServiceProvider>(context,listen: false).getProfile();
                                });
                              });
                            },style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular( 10),

                                  )),
                              backgroundColor: MaterialStateProperty.all(kMainColor),
                              fixedSize: MaterialStateProperty.all(const Size(180,30)),
                            ), label: Text(AppLocalizations.of(context)!.updateProfile,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500)),),

                          ],
                        ),
                        const SizedBox(height: 30,),
                        Text(snapshot.data['data'].first['briefYourself'].isEmpty? '${AppLocalizations.of(context)!.descNotFound}' : snapshot.data['data'].first['briefYourself'] ?? '${AppLocalizations.of(context)!.descNotFound}',style: const TextStyle(fontWeight: FontWeight.w400,color: kSecondColor,fontSize: 16),)
                        ,const SizedBox(height: 20),

                        Divider(color: kSecondColor.withOpacity(0.5),),
                        const SizedBox(height: 25),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    //width: SizeUtility(context).width * 60/ 100,
                                    child:  TextField(
                                      controller: _searchController,
                                      textAlignVertical: TextAlignVertical.center,
                                      onTap: (){
                                      },
                                      onChanged: (value) {
                                        setState(() {

                                        });
                                      },
                                      onSubmitted: (value) {
                                        if(_searchController.text.trim().isNotEmpty){
                                          setState(() {
                                            cursor = 1;
                                          });
                                          updateMyRecs();
                                        }
                                      },
                                      decoration: InputDecoration(
                                          hintText: '  ${AppLocalizations.of(context)!.search}',
                                          hintStyle: const TextStyle(color: iconColor,fontSize: 18,fontWeight: FontWeight.w500),
                                          alignLabelWithHint: true,
                                          contentPadding: const EdgeInsets.only(right: 20,),
                                          fillColor: textFieldColor,
                                          filled: true,
                                          suffixIcon: _searchController.text.trim().isNotEmpty ? IconButton(onPressed: (){
                                            setState((){
                                              cursor = 1;
                                              _searchController.clear();
                                            });
                                            updateMyRecs();
                                          },icon: const Icon(Icons.close)) : null,
                                          prefixIcon:InkWell(
                                            onTap: (){
                                              if(_searchController.text.trim().isNotEmpty){
                                                setState(() {
                                                  cursor = 1;
                                                });
                                                updateMyRecs();
                                              }
                                            },
                                            child:  Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: ImageIcon(const AssetImage('assets/icons/search.png',),size: 20,color: _searchController.text.trim().isNotEmpty ? kMainColor: null),
                                            ),
                                          ),
                                          prefixIconColor: iconColor,
                                          prefixIconConstraints: const BoxConstraints(
                                              minHeight: 20
                                          ),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: const BorderSide(color : textFieldBorderColor)),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: const BorderSide(color : textFieldBorderColor))
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),

                                GestureDetector(onTap: (){
                                  showModalBottomSheet(context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (context) => StatefulBuilder(
                                      builder: (context, setState) => IntrinsicHeight(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 6,
                                              width: 70,
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: const Color.fromRGBO(112, 112, 112, 1),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 25,left: 20,right: 20,bottom: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(child: Text(AppLocalizations.of(context)!.filter,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: kMainColor),)),
                                                  const SizedBox(height: 30,),
                                                   Text(AppLocalizations.of(context)!.analystsRecommendations,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: kMainColor),),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            recommendationStrategyFilter = 'all';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: kMainColor),
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: recommendationStrategyFilter == 'all' ? kMainColor: null
                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.all,style: TextStyle(color: recommendationStrategyFilter == 'all' ? Colors.white :kMainColor )),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            recommendationStrategyFilter = 'modarpa';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: kMainColor),
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: recommendationStrategyFilter == 'modarpa' ? kMainColor: null

                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.dayTrading,style: TextStyle(color: recommendationStrategyFilter == 'modarpa' ? Colors.white :kMainColor )),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            recommendationStrategyFilter = 'estsmar';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                            color: recommendationStrategyFilter == 'estsmar' ? kMainColor: null,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: kMainColor),

                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.investment,style: TextStyle(color: recommendationStrategyFilter == 'estsmar' ? Colors.white :kMainColor )),
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                  const SizedBox(height: 30,),
                                                   Text(AppLocalizations.of(context)!.recommendationType,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: kMainColor),),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            recommendationTypeFilter = 'all';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: kMainColor),
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: recommendationTypeFilter == 'all' ? kMainColor: null
                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.all,style: TextStyle(color: recommendationTypeFilter == 'all' ? Colors.white :kMainColor )),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            recommendationTypeFilter = 'buy';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: kMainColor),
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: recommendationTypeFilter == 'buy' ? kMainColor: null

                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.buy,style: TextStyle(color: recommendationTypeFilter == 'buy' ? Colors.white :kMainColor )),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            recommendationTypeFilter = 'sell';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                            color: recommendationTypeFilter == 'sell' ? kMainColor: null,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: kMainColor),

                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.sell,style: TextStyle(color: recommendationTypeFilter == 'sell' ? Colors.white :kMainColor )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 30,),
                                                  Text(AppLocalizations.of(context)!.analysts,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: kMainColor),),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            analyticsFilter = 'all';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: kMainColor),
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: analyticsFilter == 'all' ? kMainColor: null
                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.all,style: TextStyle(color: analyticsFilter == 'all' ? Colors.white :kMainColor )),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            analyticsFilter = 'hold';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: kMainColor),
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: analyticsFilter == 'hold' ? kMainColor: null

                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.hold,style: TextStyle(color: analyticsFilter == 'hold' ? Colors.white :kMainColor )),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            analyticsFilter = 'success';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                            color: analyticsFilter == 'success' ? kMainColor: null,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: kMainColor),

                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.succeed,style: TextStyle(color: analyticsFilter == 'success' ? Colors.white :kMainColor )),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:(){
                                                          setState(() {
                                                            analyticsFilter = 'fail';
                                                          });
                                                        } ,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: 35,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                            color: analyticsFilter == 'fail' ? kMainColor: null,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: kMainColor),

                                                          ),
                                                          child: Text(AppLocalizations.of(context)!.failed,style: TextStyle(color: analyticsFilter == 'fail' ? Colors.white :kMainColor )),
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                  const SizedBox(height: 50,),
                                                  CustomButton(title: AppLocalizations.of(context)!.apply, onPressed: () async{
                                                    Navigator.of(context).pop();
                                                    updateMyRecs();

                                                  },),
                                                  const SizedBox(height: 30,),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),);
                                },child: const ImageIcon(AssetImage('assets/icons/filter.png'),size: 30,color: kMainColor)),
                                const SizedBox(width: 10,),
                                GestureDetector(onTap: (){
                                  showModalBottomSheet(context: context,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder( // <-- SEE HERE
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (context) => StatefulBuilder(
                                      builder:(context, setState) =>  SizedBox(
                                        height: 420,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 6,
                                              width: 70,
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: const Color.fromRGBO(112, 112, 112, 1),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 25,left: 20,right: 20,bottom: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(child: Text(AppLocalizations.of(context)!.sort,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: kMainColor),)),
                                                  const SizedBox(height: 30,),
                                                  Card(
                                                    child: SizedBox(
                                                      width: SizeUtility(context).width,
                                                      child:  Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const SizedBox(height: 7,),

                                                          InkWell(
                                                            onTap: (){
                                                              setState(() {
                                                                selectedFilter = '1';
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(AppLocalizations.of(context)!.profitsFromHighToLess,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: kMainColor),),
                                                                  if(selectedFilter == '1')
                                                                    const Icon(Icons.check,color: kMainColor,)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(),
                                                          const SizedBox(height: 7,),

                                                          InkWell(
                                                            onTap: (){
                                                              setState(() {
                                                                selectedFilter = '2';
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                children: [
                                                                  Text(AppLocalizations.of(context)!.profitsFromLessToHigh,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: kMainColor),),
                                                                  if(selectedFilter == '2')
                                                                    const Icon(Icons.check,color: kMainColor,)
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          const Divider(),

                                                          const SizedBox(height: 7,),

                                                          InkWell(
                                                            onTap: (){
                                                              setState(() {
                                                                selectedFilter = '3';
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                children: [
                                                                  Text(AppLocalizations.of(context)!.updatedRecommendations,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: kMainColor),),
                                                                  if(selectedFilter == '3')
                                                                    const Icon(Icons.check,color: kMainColor,)
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          const Divider(),

                                                          const SizedBox(height: 7,),

                                                          InkWell(
                                                            onTap: (){
                                                              setState(() {
                                                                selectedFilter = '4';
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                children: [
                                                                  Text(AppLocalizations.of(context)!.oldestRecommendations,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: kMainColor),),
                                                                  if(selectedFilter == '4')
                                                                    const Icon(Icons.check,color: kMainColor,)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 7,),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 30,),
                                                  CustomButton(title: AppLocalizations.of(context)!.apply, onPressed: () {
                                                    Navigator.of(context).pop();
                                                    updateMyRecs();
                                                  },),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),);
                                },child: const ImageIcon(AssetImage('assets/icons/sort.png'),size: 30,color: kMainColor,))
                              ],
                            ),

                            const SizedBox(height: 25),
                             Column(
                                children:[
                                  ...recommendations.map<Widget>((rec)=> RecommendationContainer(recommendation: rec, notifyMeFunction:()async{
                                    if(rec['notifyMe'] == '0'){
                                      await Provider.of<ServiceProvider>(context,listen: false).recommendationNotify(rec['recommendationId']).then((value) {
                                        updateMyRecs();
                                      });
                                    }else{
                                      await Provider.of<ServiceProvider>(context,listen: false).recommendationDeNotify(rec['recommendationId']).then((value) {
                                        updateMyRecs();
                                      });
                                    }
                                  }, likeRecommendationFunction: () async{
                                    if(rec['isLiked'] == '0'){
                                      await Provider.of<ServiceProvider>(context,listen: false).likeRecommendation(rec['recommendationId']).then((value) {
                                        updateMyRecs();
                                      });
                                    }else{
                                      await Provider.of<ServiceProvider>(context,listen: false).disLikeRecommendation(rec['recommendationId']).then((value) {
                                        updateMyRecs();
                                      });
                                    }
                                  },)).toList(),

                               /*   if(_isLoading)
                                    const LoadingIndicator(),*/

                                  const SizedBox(height: 50,)
                                   ]
                            )
                            ])
                          ],
                        )
                    ),

                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
