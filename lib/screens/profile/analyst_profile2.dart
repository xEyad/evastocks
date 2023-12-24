import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/models/analyst_profile/analyst_profile_model.dart';
import 'package:nosooh/models/trading_model/trading_model.dart';
import 'package:nosooh/screens/notifications/notifications.dart';
import 'package:nosooh/screens/payment/payment.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../components/build_home_item.dart';
import '../../components/custom_button.dart';
import '../../components/show_dialog_widget.dart';
import '../../components/show_dialog_with_image.dart';
import '../../utils/size_utility.dart';

class AnalystProfile2 extends StatefulWidget {
  final String id;
  final int category;
  final bool isSubscribed;
  const AnalystProfile2({super.key, required this.id, required this.category,required this.isSubscribed});

  @override
  State<AnalystProfile2> createState() => _AnalystProfile2State();
}

class _AnalystProfile2State extends State<AnalystProfile2> {
  int cursor = 1;
  ScrollController _paginationController = ScrollController();
  AnalystProfileModel? profileData;
  TradingModel? opinions;

  String selectedFilter = 'all';
  String selectedStatusFilter = 'total';

  /////////////////////////////
  String recommendationStrategyFilter = 'all';
  int? orderType;
  int? status;
  int? favorite;
  int? type;
  int selectedTapBarIndex = 1;

  late var exp = (element) =>
      (selectedFilter == 'sale'
          ? element['recommendationType'] == AppLocalizations.of(context)!.sell
          : selectedFilter == AppLocalizations.of(context)!.buy
              ? element['recommendationType'] ==
                  AppLocalizations.of(context)!.buy
              : element == element) &&
      (selectedStatusFilter == 'hold'
          ? element['recommendationStatus'] == 'انتظار'
          : selectedStatusFilter == 'success'
              ? element['recommendationStatus'] ==
                  AppLocalizations.of(context)!.nagha
              : selectedStatusFilter == 'fail'
                  ? element['recommendationStatus'] ==
                      AppLocalizations.of(context)!.failed
                  : element == element);

  bool _isLoading = false;

  initScrollingListener() {
    _paginationController.addListener(() {
      if (_paginationController.position.pixels ==
          _paginationController.position.maxScrollExtent) {
        setState(() {
          cursor++;
        });
        print(cursor);
        updateAnalystOpinionsWithPagination();
      }
    });
  }

  @override
  void initState() {
    print('hEREEE');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initScrollingListener();
      updateAnalyst();
      updateAnalystOpinions();
    });

    super.initState();
  }

  updateAnalyst() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getAnalystProfileById(widget.id)
        .then((value) {
      setState(() {
        profileData = Provider.of<ServiceProvider>(context, listen: false)
            .analystProfileModel;
        _isLoading = false;
      });
      // else {
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => const Payment(),
      //   ));
      // }
    });
  }

  updateAnalystOpinions() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getAnalystProfileOpinions(
      type: type,
      status: status,
      sort: selectedFilter == 'all'? null : selectedFilter,
      orderType: orderType,
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

  updateAnalystOpinionsWithPagination() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getAnalystProfileOpinions(
      type: type,
      status: status,
      sort: selectedFilter == 'all'? null : selectedFilter,
      orderType: orderType,
      id: widget.id,
      cursor: cursor,
    )
        .then((value) {
      setState(() {
        opinions?.data?.addAll(
            Provider.of<ServiceProvider>(context, listen: false)
                .analystProfileOpinions!
                .data!);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            if(profileData != null)
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
                                          AssetImage('assets/images/user.png'),
                                    ),
                                  )
                                : Positioned(
                                    bottom: 0,
                                    right: 20,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        profileData!.data.avatar ??
                                            'DEFAULT_URL',
                                      ),
                                      onBackgroundImageError: (exception,
                                              stackTrace) =>
                                          AssetImage('assets/images/user.png'),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if(profileData != null)
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
                                    Text(
                                      profileData?.data.name ?? '',
                                      style: const TextStyle(
                                          color: kMainColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      profileData!.data.analystName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: kSecondColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                // hide subscribed widget
                                /*
                                GestureDetector(
                                  onTap: () async {
                                    // setState(() {
                                    //   _isLoading = true;
                                    // });
                                    // await Provider.of<ServiceProvider>(context,
                                    //         listen: false)
                                    //     .unFavAnalyst(companyId: widget.id)
                                    //     .then((value) {
                                    //   updateAnalyst();
                                    // });
                                  },
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
                                                .subscribed,
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
                                )*/
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: AppLocalizations.of(context)!.localeName == 'en'? Alignment.centerLeft : Alignment.centerRight,
                              child: Text(
                                profileData!.data.bio,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: kSecondColor,
                                    fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: HexColor('#f7fdfd'),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/success_icon.png',
                                            //color: HexColor('#62dfd5'),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${AppLocalizations.of(context)!.successOpinions}: ${profileData?.data.successCount}',
                                              style: TextStyle(
                                                  color: HexColor('#5eded5'),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      selectedStatusFilter ==
                                                              'total'
                                                          ? FontWeight.w600
                                                          : null),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: HexColor('#fef5f5'),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/wrong_small.png',
                                            //color: HexColor('#e70000'),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${AppLocalizations.of(context)!.failOpinions}: ${profileData?.data.failedCount}',
                                              style: TextStyle(
                                                  color: HexColor('#f27373'),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      selectedStatusFilter ==
                                                              'total'
                                                          ? FontWeight.w600
                                                          : null),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: HexColor('#fffcf5'),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              'assets/icons/percentage_icon.png',
                                              color: HexColor('#ffb300'),
                                              height: 20),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${AppLocalizations.of(context)!.successRate}: ${profileData?.data.successPercentage?.toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                  color: HexColor('#ffc334'),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      selectedStatusFilter ==
                                                              'total'
                                                          ? FontWeight.w600
                                                          : null),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .analystsRecommendations,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start)),
                            const SizedBox(height: 5),
                            if(widget.isSubscribed)
                            buildFilterAndTapBarRow(context),
                            if(!widget.isSubscribed)
                              SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                !widget.isSubscribed ?
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
                                planId: profileData!.data.planId,
                                listName: profileData!.data.name
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
                        SizedBox(
                          height: 20,
                        ),
                        Lottie.asset(
                          'assets/animations/subscribe_animation.json',
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 200,
                        ),
                      ],
                    ),
                  ) :

                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: BuildHomeItem(
                        data: opinions!.data![index],
                        likeOnTap: () async {
                          if (opinions!.data![index].isFavorite == false) {
                            await Provider.of<ServiceProvider>(context,
                                    listen: false)
                                .favoriteRecommendation(int.parse(opinions!
                                    .data![index].opinionId
                                    .toString()))
                                .then((value) {
                              updateAnalystOpinions();
                            });
                          } else {
                            // await Provider.of<ServiceProvider>(context,
                            //         listen: false)
                            //     .disLikeRecommendation(
                            //         rec['recommendationId'])
                            //     .then((value) {
                            //   updateRecs();
                            // });
                          }
                        },
                        opinionTypeOnTap: () {
                          showCustomDialog(
                            context: context,
                            title: 'نوع الطرح',
                            body: opinions!.data![index].opinionTypeText ?? '',
                          );
                        },
                        showMoreOnTap: () {
                          showCustomDialog(
                            context: context,
                            title:
                                AppLocalizations.of(context)!.moreInformation,
                            body: opinions!.data![index].opinionExtraInfo ?? '',
                          );
                        },
                        addCommentOnTap: () {
                          showCustomDialogWithImage(
                              buttonText: AppLocalizations.of(context)!.send,
                              hintText: AppLocalizations.of(context)!
                                  .whatIsYourComment,
                              title: AppLocalizations.of(context)!
                                  .addYourCommentForUs,
                              body: AppLocalizations.of(context)!
                                  .dontHistateToAddYourComment,
                              opinionId: int.parse(
                                  opinions!.data![index].opinionId.toString()),
                              context: context,
                              provider: Provider.of<ServiceProvider>(context,
                                  listen: false));
                        },
                        isTrading: true,
                      ),
                    );
                  },
                  childCount: opinions?.data?.length ?? 0,
                )),
              ],
            ),
    );
  }

  Widget buildFilterAndTapBarRow(BuildContext context) {
    return Row(
      children: [
        //الكل
        TextButton(
          onPressed: () {
            setState(() {
              selectedTapBarIndex = 1;
              orderType = null;
              updateAnalystOpinions();
            });
          },
          child: Text(
            AppLocalizations.of(context)!.all,
            style: selectedTapBarIndex == 1
                ? TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kMainColor)
                : TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: kMainColor.withOpacity(0.6)),
          ),
        ),
        //البيع
        TextButton(
          onPressed: () {
            setState(() {
              selectedTapBarIndex = 2;
              orderType =1;
              updateAnalystOpinions();
            });
          },
          child: Text(
            AppLocalizations.of(context)!.sell,
            style: selectedTapBarIndex == 2
                ? TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kMainColor)
                : TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: kMainColor.withOpacity(0.6)),
          ),
        ),

        //الشراء
        TextButton(
          onPressed: () {
            setState(() {
              selectedTapBarIndex = 3;
              orderType = 2;
              updateAnalystOpinions();
            });
          },
          child: Text(
            AppLocalizations.of(context)!.buy,
            style: selectedTapBarIndex == 3
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
        Spacer(),
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
                                  AppLocalizations.of(context)!.opinionType,
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          recommendationStrategyFilter = 'all';
                                          type = null;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    recommendationStrategyFilter ==
                                                            'all'
                                                        ? HexColor('#31d5c8')
                                                        : kMainColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                recommendationStrategyFilter ==
                                                        'all'
                                                    ? HexColor('#31d5c8')
                                                    : null),
                                        child: Text(
                                            AppLocalizations.of(context)!.all,
                                            style: TextStyle(
                                                color:
                                                    recommendationStrategyFilter ==
                                                            'all'
                                                        ? Colors.white
                                                        : kMainColor)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          recommendationStrategyFilter = 'ashm';
                                          type = 1;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    recommendationStrategyFilter ==
                                                            'ashm'
                                                        ? HexColor('#31d5c8')
                                                        : kMainColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                recommendationStrategyFilter ==
                                                        'ashm'
                                                    ? HexColor('#31d5c8')
                                                    : null),
                                        child: Text(
                                            AppLocalizations.of(context)!.ashm,
                                            style: TextStyle(
                                                color:
                                                    recommendationStrategyFilter ==
                                                            'ashm'
                                                        ? Colors.white
                                                        : kMainColor)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          recommendationStrategyFilter = 'okod';
                                          type = 2;
                                          selectedTapBarIndex = 1;

                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                          color: recommendationStrategyFilter ==
                                                  'okod'
                                              ? HexColor('#31d5c8')
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  recommendationStrategyFilter ==
                                                          'okod'
                                                      ? HexColor('#31d5c8')
                                                      : kMainColor),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!.oqood,
                                            style: TextStyle(
                                                color:
                                                    recommendationStrategyFilter ==
                                                            'okod'
                                                        ? Colors.white
                                                        : kMainColor)),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.analystType,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: kMainColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (recommendationStrategyFilter == 'ashm' ||
                                    recommendationStrategyFilter == 'all')
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //الكل
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTapBarIndex = 1;
                                            orderType = null;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          width:
                                              SizeUtility(context).width * .28,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: orderType == null
                                                      ? HexColor('#31d5c8')
                                                      : kMainColor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: orderType == null
                                                  ? HexColor('#31d5c8')
                                                  : null),
                                          child: Text(
                                              AppLocalizations.of(context)!.all,
                                              style: TextStyle(
                                                  color: orderType == null
                                                      ? Colors.white
                                                      : kMainColor)),
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            orderType = 2;
                                            selectedTapBarIndex = 3;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          width:
                                              SizeUtility(context).width * .28,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: orderType == 2
                                                      ? HexColor('#31d5c8')
                                                      : kMainColor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: orderType == 2
                                                  ? HexColor('#31d5c8')
                                                  : null),
                                          child: Text(
                                              AppLocalizations.of(context)!.buy,
                                              style: TextStyle(
                                                  color: orderType == 2
                                                      ? Colors.white
                                                      : kMainColor)),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            orderType = 1;
                                            selectedTapBarIndex = 2;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          width:
                                              SizeUtility(context).width * .28,
                                          decoration: BoxDecoration(
                                            color: orderType == 1
                                                ? HexColor('#31d5c8')
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: orderType == 1
                                                    ? HexColor('#31d5c8')
                                                    : kMainColor),
                                          ),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .sell,
                                              style: TextStyle(
                                                  color: orderType == 1
                                                      ? Colors.white
                                                      : kMainColor)),
                                        ),
                                      )
                                    ],
                                  ),
                                if (recommendationStrategyFilter == 'all')
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (recommendationStrategyFilter == 'okod' ||
                                    recommendationStrategyFilter == 'all')
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              orderType = 3;
                                              selectedTapBarIndex = 1;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: orderType == 3
                                                        ? HexColor('#31d5c8')
                                                        : kMainColor),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: orderType == 3
                                                    ? HexColor('#31d5c8')
                                                    : null),
                                            child: Text('Call',
                                                style: TextStyle(
                                                    color: orderType == 3
                                                        ? Colors.white
                                                        : kMainColor)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              orderType = 4;
                                              selectedTapBarIndex = 1;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: orderType == 4
                                                  ? HexColor('#31d5c8')
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: orderType == 4
                                                      ? HexColor('#31d5c8')
                                                      : kMainColor),
                                            ),
                                            child: Text('Put',
                                                style: TextStyle(
                                                    color: orderType == 4
                                                        ? Colors.white
                                                        : kMainColor)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                const SizedBox(
                                  height: 30,
                                ),
                                //////////////////////////////////////////////////////////////////////////////////
                                Text(
                                  AppLocalizations.of(context)!.analysisStatus,
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          status = null;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: status == null
                                                    ? HexColor('#31d5c8')
                                                    : kMainColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: status == null
                                                ? HexColor('#31d5c8')
                                                : null),
                                        child: Text(
                                            AppLocalizations.of(context)!.all,
                                            style: TextStyle(
                                                color: status == null
                                                    ? Colors.white
                                                    : kMainColor)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          status = 1;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: status == 1
                                                    ? HexColor('#31d5c8')
                                                    : kMainColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: status == 1
                                                ? HexColor('#31d5c8')
                                                : null),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .success,
                                            style: TextStyle(
                                                color: status == 1
                                                    ? Colors.white
                                                    : kMainColor)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          status = 2;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                          color: status == 2
                                              ? HexColor('#31d5c8')
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: status == 2
                                                  ? HexColor('#31d5c8')
                                                  : kMainColor),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .failed,
                                            style: TextStyle(
                                                color: status == 2
                                                    ? Colors.white
                                                    : kMainColor)),
                                      ),
                                    )
                                  ],
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
                                            status = 3;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: status == 3
                                                ? HexColor('#31d5c8')
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: status == 3
                                                    ? HexColor('#31d5c8')
                                                    : kMainColor),
                                          ),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .pending,
                                              style: TextStyle(
                                                  color: status == 3
                                                      ? Colors.white
                                                      : kMainColor)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ///////////////////////////////////////////////////////
                                CustomButton(
                                  title: AppLocalizations.of(context)!.apply,
                                  onPressed: () async {
                                    updateAnalystOpinions();
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
        const SizedBox(
          width: 10,
        ),
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
                                            selectedFilter = '1';
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .profitsFromHighToLess,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: kMainColor),
                                              ),
                                              if (selectedFilter == '1')
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
                                            selectedFilter = '2';
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .profitsFromLessToHigh,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: kMainColor),
                                              ),
                                              if (selectedFilter == '2')
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
                                            selectedFilter = '3';
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .updatedRecommendations,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: kMainColor),
                                              ),
                                              if (selectedFilter == '3')
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
                                            selectedFilter = '4';
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .oldestRecommendations,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: kMainColor),
                                              ),
                                              if (selectedFilter == '4')
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
                                  updateAnalystOpinions();

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
