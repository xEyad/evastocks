import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/models/analyst_profile/analyst_profile_model.dart';
import 'package:nosooh/models/trading_model/trading_model.dart';
import 'package:nosooh/screens/notifications/notifications.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../components/build_analyst_profile_rating_list_item.dart';
import '../../components/build_analyst_profile_stocks_item.dart';
import '../../components/custom_button.dart';
import '../../models/chart_data_model/chart_data_model.dart';
import '../../models/ratings_logs_model/rating_logs_model.dart';
import '../../models/ratings_model/rating_model.dart';
import '../../utils/size_utility.dart';
import '../payment/payment.dart';
import 'chart_component.dart';

class AnalystProfile3 extends StatefulWidget {
  final String id;
  final String analystName;
  final String planeId;
  final bool isSubscribed;
  final String listName;

  const AnalystProfile3(
      {super.key,
      required this.id,
      required this.isSubscribed,
      required this.analystName,
      required this.planeId,required this.listName});

  @override
  State<AnalystProfile3> createState() => _AnalystProfile3State();
}

class _AnalystProfile3State extends State<AnalystProfile3> {
  int cursor = 1;
  ScrollController _paginationController = ScrollController();
  AnalystProfileModel? profileData;
  ChartDataModel? chartData1;
  RatingModel? ratingData;
  RatingLogsModel? ratingLogsData;

  TradingModel? opinions;

  String selectedFilter = 'all';
  String selectedStatusFilter = 'total';

  /////////////////////////////
  String recommendationStrategyFilter = 'all';
  int? orderType;
  int? status;
  int? favorite;
  int selectedTapBarIndex = 1;
  int sortBy = 1;
  int ratingPage = 1;
  int logsPage = 1;
  String? type;

  bool isFav = false;
  bool _isLoading = false;

  initScrollingListener() {
    _paginationController.addListener(() {
      if (_paginationController.position.pixels ==
          _paginationController.position.maxScrollExtent) {
        setState(() {
          if (selectedTapBarIndex == 1 && widget.isSubscribed) {
            ratingPage++;
          }
          if (selectedTapBarIndex == 2 && widget.isSubscribed) {
            //logsPage++;
          }
        });
        if (selectedTapBarIndex == 1 && widget.isSubscribed) {
          updateRatingDataWithPagination();
        }
        if (selectedTapBarIndex == 2 && widget.isSubscribed) {
          // updateRatingLogsDataWithPagination();
        }
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await initScrollingListener();
     await updateAnalyst();
     await updateChartData();
     await  updateRatingData();
     await  updateRatingLogsData();
      //updateAnalystOpinions();
    });

    super.initState();
  }

  updateAnalyst({bool? isPagination= false}) async {
    if(isPagination == false){
      setState(() {
        _isLoading = true;
      });
    }
    await Provider.of<ServiceProvider>(context, listen: false)
        .getRatingAnalystProfileById(widget.id)
        .then((value) {
      setState(() {
        profileData = Provider.of<ServiceProvider>(context, listen: false)
            .ratingAnalystProfileModel;
        _isLoading = false;
      });
      // else {
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => const Payment(),
      //   ));
      // }
    });
  }

  markRatingListFavorite() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ServiceProvider>(context, listen: false)
        .markRatingListFavorite(widget.id)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  updateRatingData({bool? isPagination = false}) async {
    if(isPagination == false){
      setState(() {
        _isLoading = true;
      });
    }
    setState(() {
      ratingPage = 1;
    });
    await Provider.of<ServiceProvider>(context, listen: false)
        .getRatingDataById(id: widget.id, sortBy: sortBy, page: ratingPage)
        .then((value) {
      setState(() {
        ratingData =
            Provider.of<ServiceProvider>(context, listen: false).ratingModel;
        _isLoading = false;
      });
    });
  }

  updateRatingLogsData({bool? isPagination = false}) async {
    if(isPagination == false){
      setState(() {
        _isLoading = true;
      });
    }
    setState(() {
   //   _isLoading = true;
      logsPage = 1;
    });
    await Provider.of<ServiceProvider>(context, listen: false)
        .getRatingLogsDataById(id: widget.id, type: type)
        .then((value) {
      setState(() {
        ratingLogsData = Provider.of<ServiceProvider>(context, listen: false)
            .ratingLogsModel;
        _isLoading = false;
      });
    });
  }

  updateChartData({bool? isPagination= false}) async {
    if(isPagination == false){
      setState(() {
        _isLoading = true;
      });
    }
    await Provider.of<ServiceProvider>(context, listen: false)
        .getChartDataById(widget.id)
        .then((value) {
      setState(() {
        chartData1 =
            Provider.of<ServiceProvider>(context, listen: false).chartData;
        _isLoading = false;
      });
    });
  }

  updateAnalystOpinions() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ServiceProvider>(context, listen: false)
        .getAnalystProfileOpinions(
      id: widget.id,
    )
        .then((value) {
      setState(() {
        opinions = Provider.of<ServiceProvider>(context, listen: false)
            .analystProfileOpinions;
        _isLoading = false;
      });
    });
  }

  updateRatingDataWithPagination() async {

    await Provider.of<ServiceProvider>(context, listen: false)
        .getRatingDataById(id: widget.id, sortBy: sortBy, page: ratingPage)
        .then((value) {
      setState(() {
        ratingData?.data?.addAll(
            Provider.of<ServiceProvider>(context, listen: false)
                    .ratingModel
                    ?.data ??
                []);

        _isLoading = false;
      });
    });
  }

  updateRatingLogsDataWithPagination() async {

    await Provider.of<ServiceProvider>(context, listen: false)
        .getRatingLogsDataById(id: widget.id, type: type)
        .then((value) {
      setState(() {
        ratingLogsData?.data?.addAll(
            Provider.of<ServiceProvider>(context, listen: false)
                    .ratingLogsModel
                    ?.data ??
                []);

        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
              controller: _paginationController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 150,
                              color: HexColor('#eaeefb'),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.arrow_back_ios,
                                        color: kMainColor),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            showHelpNosoohBottomSheet(context);
                                          },
                                          child: Image.asset(
                                              'assets/icons/help.png',
                                              height: 40,
                                              width: 40)),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const Notifications(),
                                            ));
                                          },
                                          child: Image.asset(
                                              'assets/icons/notification.png',
                                              height: 26,
                                              width: 26)),
                                      const SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            AppLocalizations.of(context)!.localeName == 'en'
                                ? Positioned(
                                    bottom: 0,
                                    left: 20,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        profileData!.data.avatar ??
                                            'DEFAULT_URL',
                                      ),
                                      onBackgroundImageError: (exception,
                                              stackTrace) =>
                                          const AssetImage('assets/images/user.png'),
                                    ),
                                  )
                                : Positioned(
                                    bottom: 0,
                                    right: 20,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        profileData?.data.avatar ??
                                            'DEFAULT_URL',
                                      ),
                                      onBackgroundImageError: (exception,
                                              stackTrace) =>
                                          const AssetImage('assets/images/user.png'),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profileData?.data.name ?? '',
                                      style: const TextStyle(
                                          color: kMainColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      profileData?.data.analystName ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: kSecondColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                if(profileData!= null)
                                if (isFav == false &&
                                    profileData!.data.isFavorite == false)
                                  GestureDetector(
                                    onTap: () async {
                                      await markRatingListFavorite();

                                      await updateAnalyst();
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: HexColor('#e70000'),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .favorite,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: HexColor('#e70000'),
                                              )),
                                          Image.asset(
                                            'assets/icons/empty_heart.png',
                                            color: HexColor('#e70000'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if(profileData != null)
                                if (isFav == true ||
                                    profileData!.data.isFavorite == true)
                                  GestureDetector(
                                    onTap: ()async{
                                      await markRatingListFavorite();
                                      await  updateAnalyst();

                                    },
                                    child: Container(
                                      width: 80,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: HexColor('#e70000'),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .favorite,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: HexColor('#e70000'),
                                              )),
                                          Image.asset(
                                            'assets/icons/heart.png',
                                            color: HexColor('#e70000'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                //followed widget
                                /* const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () async {},
                                  child: Container(
                                    width: 80,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor('#305CD5'),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .followed,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                        Image.asset(
                                          'assets/icons/person_icon.png',
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              /*'${profileData['meta']['analyst'].first['companyBio']}'*/
                              profileData?.data.aboutMe ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: kSecondColor,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              alignment: Alignment.center,
                             
                              decoration: BoxDecoration(
                                color: HexColor('#F8F8F8'),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(width: 20,),
                                  // first part
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // bold text part
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .overAllListPerformance,
                                                style: TextStyle(
                                                    color: HexColor('#515151'),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const ImageIcon(AssetImage(
                                                'assets/icons/info.png')),
                                          ],
                                        ),
                                        //informations part
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              //first values part
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(children: [
                                                    Column(children: [
                                                      Wrap(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                HexColor(
                                                                    '#31D5C8'),
                                                            radius: 5,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxWidth: 50,
                                                            ),
                                                            child: Text(
                                                              chartData1?.data
                                                                      ?.listName
                                                                      .toString() ??
                                                                  '',
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: HexColor(
                                                                      '#A0A0A0'),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                                  ]),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  if(chartData1 != null)
                                                  Text(
                                                    '${chartData1?.data?.performanceSinceInception.toString() ?? ''}%',
                                                    style: TextStyle(
                                                        color:
                                                        chartData1!.data!.performanceSinceInception!.isNegative? HexColor('#E70000') : kMainColor2,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              //second values part
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(children: [
                                                    Column(children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                HexColor(
                                                                    '#305CD5'),
                                                            radius: 5,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            chartData1?.data
                                                                    ?.indexName ??
                                                                '',
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    '#A0A0A0'),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                                  ]),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  if(chartData1!= null)
                                                  Text(
                                                    '${chartData1?.data?.indexPerformanceSinceInception.toString() ?? ''}%',
                                                    style: TextStyle(
                                                        color:
                                                        chartData1!.data!.indexPerformanceSinceInception!.isNegative? HexColor('#E70000') : kMainColor2,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // second part
                                  if (chartData1 != null)
                                    Container(
                                      alignment: Alignment.center,
                                      height: 150,
                                      width: 230,
                                      child: YourChartWidget(
                                        chartDataModel: chartData1!,
                                      ),
                                    )
                                  //chart widget
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    AppLocalizations.of(context)!.analystList,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start)),
                            const SizedBox(height: 5),
                            if (widget.isSubscribed)
                              buildFilterAndTapBarRow(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedTapBarIndex == 1 && widget.isSubscribed)
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return BuildAnalystProfileStocksItem(
                        ratingData: ratingData,
                        index: index,
                      );
                    },
                    childCount: ratingData?.data?.length ?? 0,
                  )),
                if (selectedTapBarIndex == 2 && widget.isSubscribed)
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return BuildAnalystProfileRatingListItem(
                        index: index,
                        logsData: ratingLogsData!,
                      );
                    },
                    childCount: ratingLogsData?.data.length ?? 0,
                  )),
                if (!widget.isSubscribed)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                            AppLocalizations.of(context)!
                                .thisFeatureIsNotSupportedInYourFreePlan,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Payment(
                                planId: widget.planeId,
                                listName: widget.listName,
                              ),
                            ));
                          },
                          child: Text(
                              AppLocalizations.of(context)!.upgradeYourAccount,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: '',
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.start),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Lottie.asset(
                          'assets/animations/subscribe_animation.json',
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 200,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget buildFilterAndTapBarRow(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              selectedTapBarIndex = 1;
            });
          },
          child: Text(
            AppLocalizations.of(context)!.theStocks,
            style: selectedTapBarIndex == 1
                ? const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kMainColor)
                : TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: kMainColor.withOpacity(0.6)),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              selectedTapBarIndex = 2;
            });
          },
          child: Text(
            AppLocalizations.of(context)!.transactionsHistory,
            style: selectedTapBarIndex == 2
                ? const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kMainColor)
                : TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: kMainColor.withOpacity(0.6)),
          ),
        ),
        const Spacer(),
        if (selectedTapBarIndex == 2)
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (context) => StatefulBuilder(
                    builder: (context, setState) => IntrinsicHeight(
                      child: SingleChildScrollView(
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
                              padding: const EdgeInsets.only(
                                  top: 25, left: 20, right: 20, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Text(
                                    AppLocalizations.of(context)!.filter,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: kMainColor),
                                  )),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .transactionsHistory,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: kMainColor),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              type = null;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            width: SizeUtility(context).width *
                                                .28,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: type == null
                                                        ? HexColor('#31d5c8')
                                                        : kMainColor),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: type == null
                                                    ? HexColor('#31d5c8')
                                                    : null),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .all,
                                                style: TextStyle(
                                                    color: type == null
                                                        ? Colors.white
                                                        : kMainColor)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              type = 'BUY';
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            width: SizeUtility(context).width *
                                                .28,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: type == 'BUY'
                                                        ? HexColor('#31d5c8')
                                                        : kMainColor),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: type == 'BUY'
                                                    ? HexColor('#31d5c8')
                                                    : null),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .buy,
                                                style: TextStyle(
                                                    color: type == 'BUY'
                                                        ? Colors.white
                                                        : kMainColor)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              type = 'SELL';
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            width: SizeUtility(context).width *
                                                .28,
                                            decoration: BoxDecoration(
                                              color: type == 'SELL'
                                                  ? HexColor('#31d5c8')
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: type == 'SELL'
                                                      ? HexColor('#31d5c8')
                                                      : kMainColor),
                                            ),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .sell,
                                                style: TextStyle(
                                                    color: type == 'SELL'
                                                        ? Colors.white
                                                        : kMainColor)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              type = 'EDIT';
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            width: SizeUtility(context).width *
                                                .28,
                                            decoration: BoxDecoration(
                                              color: type == 'EDIT'
                                                  ? HexColor('#31d5c8')
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: type == 'EDIT'
                                                      ? HexColor('#31d5c8')
                                                      : kMainColor),
                                            ),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .edit,
                                                style: TextStyle(
                                                    color: type == 'EDIT'
                                                        ? Colors.white
                                                        : kMainColor)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              type = 'DIVIDEND';
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            width: SizeUtility(context).width *
                                                .28,
                                            decoration: BoxDecoration(
                                              color: type == 'DIVIDEND'
                                                  ? HexColor('#31d5c8')
                                                  : null,
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: type == 'DIVIDEND'
                                                      ? HexColor('#31d5c8')
                                                      : kMainColor),
                                            ),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .dividend,
                                                style: TextStyle(
                                                    color: type == 'DIVIDEND'
                                                        ? Colors.white
                                                        : kMainColor)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  CustomButton(
                                    title: AppLocalizations.of(context)!.apply,
                                    onPressed: () async {
                                      updateRatingLogsData(isPagination: true);
                                      Navigator.of(context).pop();
                                      //updateRecs();
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const ImageIcon(AssetImage('assets/icons/filter.png'),
                  size: 30, color: kMainColor)),
        if (selectedTapBarIndex == 1)
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    // <-- SEE HERE
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (context) => StatefulBuilder(
                    builder: (context, setState) => SizedBox(
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
                            padding: const EdgeInsets.only(
                                top: 25, left: 20, right: 20, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.sort,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: kMainColor),
                                )),
                                const SizedBox(
                                  height: 30,
                                ),
                                Card(
                                  child: SizedBox(
                                    width: SizeUtility(context).width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              sortBy = 2;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  /*AppLocalizations.of(context)!
                                                      .profitsFromHighToLess*/
                                                  AppLocalizations.of(context)!
                                                      .newestStocks,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kMainColor),
                                                ),
                                                if (sortBy == 2)
                                                  const Icon(
                                                    Icons.check,
                                                    color: kMainColor,
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              sortBy = 3;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  /*AppLocalizations.of(context)!
                                                      .profitsFromLessToHigh*/
                                                  AppLocalizations.of(context)!
                                                      .highestBuyPercentage,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kMainColor),
                                                ),
                                                if (sortBy == 3)
                                                  const Icon(
                                                    Icons.check,
                                                    color: kMainColor,
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              sortBy = 4;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  /*AppLocalizations.of(context)!
                                                      .updatedRecommendations*/
                                                  AppLocalizations.of(context)!
                                                      .highestChangePercentage,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kMainColor),
                                                ),
                                                if (sortBy == 4)
                                                  const Icon(
                                                    Icons.check,
                                                    color: kMainColor,
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomButton(
                                  title: AppLocalizations.of(context)!.apply,
                                  onPressed: () {
                                    updateRatingData(isPagination: true);
                                    Navigator.of(context).pop();
                                    //updateRecs();
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const ImageIcon(
                AssetImage('assets/icons/sort.png'),
                size: 30,
                color: kMainColor,
              ))
      ],
    );
  }
}
