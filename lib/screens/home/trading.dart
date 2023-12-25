import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/models/analysts_model/analysts_model.dart';
import 'package:nosooh/screens/notifications/notifications.dart';
import 'package:nosooh/screens/payment/payment.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

import '../../components/analyst_container.dart';
import '../../components/build_home_item.dart';
import '../../components/show_dialog_widget.dart';
import '../../components/show_dialog_with_image.dart';
import '../../models/markets_model/markets_model.dart';
import '../../models/trading_model/trading_model.dart';
import '../profile/analyst_profile2.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {

  bool _isLoading = true;
  String recommendationTypeFilter = 'all';
  String statusFilter = 'all';
  String analyticsFilter = 'all';

  /////////////////////////////////////////
  String recommendationStrategyFilter = 'all';
  int? orderType;
  int? status;
  int? favorite;

  //var exp = (element) => element == element;
  List recommendations = [];
  TradingModel? model;
  MarketsModel? markets;
  AnalystsModel? analystsListModel;
  String? selectedFilter = '3';
  bool showSearchBar = false;
  int cursor = 1;
  int? marketType;
  int selectedTapBarIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  static final _paginationController = ScrollController();

  initScrollingListener() {
    _paginationController.addListener(() {
      if (_paginationController.position.pixels ==
          _paginationController.position.maxScrollExtent) {
        setState(() {
          cursor++;
        });
        print(cursor);
        updateRecsWithPagination();
      }
    });
  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateRecs();
      updateAnalystsList();
      initScrollingListener();
      if (markets == null) {
        getAllMarkets();
      }
    });
    super.initState();
  }


  updateRecsWithPagination() async {
    setState(() {
     // _isLoading = true;
    });


    Provider.of<ServiceProvider>(context, listen: false)
        .getTradingRecommendationList(
      sortBy: selectedFilter,
      status: status,
      favorite: favorite,
      orderType: orderType,
      type: recommendationStrategyFilter == 'all' ? null : recommendationStrategyFilter == 'ashm'? 1 : 2,
      searchQuery: _searchController.text,
      cursor: cursor,

    )
        .then((value) {
      setState(() {
        model?.data?.addAll(Provider.of<ServiceProvider>(context, listen: false)
            .tradingModel!
            .data!);
        _isLoading = false;
      });
    });
  }

  updateRecs() {

    setState(() {
      cursor = 1;
      _isLoading = false;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getTradingRecommendationList(
      sortBy: selectedFilter,
      status: status,
      favorite: favorite,
      orderType: orderType,
      type: recommendationStrategyFilter == 'all' ? null : recommendationStrategyFilter == 'ashm'? 1 : 2,
      searchQuery: _searchController.text,
      cursor: cursor,
    )
        .then((value) {
      setState(() {
        model =
            Provider.of<ServiceProvider>(context, listen: false).tradingModel;
        _isLoading = false;
      });
    });

  }

  getAllMarkets() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getAllMarkets()
        .then((value) {
      setState(() {
        markets = Provider.of<ServiceProvider>(context, listen: false).markets;
        _isLoading = false;
      });
    });
  }

  updateAnalystsList() {
    setState(() {
      cursor = 1;
      _isLoading = true;
    });
    int? selectedMarketId;
    if (marketType == 2) {
      //american
      selectedMarketId = markets!.data![0].id;
    } else if (marketType == 1) {
      //saudi
      selectedMarketId = markets!.data![1].id;
    } else {}
    print('market type id is $selectedMarketId and market type $marketType ');

    Provider.of<ServiceProvider>(context, listen: false)
        .getTradingAnalystList(
      appliedFilter: selectedFilter.toString(),
      marketId: selectedMarketId,
      searchQuery: _searchController.text
    )
        .then((value) {
      setState(() {
        analystsListModel =
            Provider.of<ServiceProvider>(context, listen: false).analystsModel;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              setState(() {
                showSearchBar = !showSearchBar;
              });
              setState(() {
                cursor = 1;
                _searchController.clear();
              });
            if(!showSearchBar){
              updateAnalystsList();
              updateRecs();
            }
            },
            child: Image.asset(
              'assets/icons/search.png',
              height: 40,
              width: 40,
              color: selectedIconColor,
            )),
        title: Text(
          AppLocalizations.of(context)!.trading,
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                showHelpNosoohBottomSheet(context);
              },
              child: Image.asset(
                'assets/icons/help.png',
                height: 40,
                width: 40,
                color: selectedIconColor,
              )),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Notifications(),
                ));
              },
              child: Image.asset(
                'assets/icons/notification.png',
                height: 26,
                width: 26,
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: _isLoading? SizedBox() :Padding(
        padding: const EdgeInsets.all(15.0),
        child:  CustomScrollView(

          slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (showSearchBar) buildSearchRow(context),
                        const SizedBox(height: 10),
                        selectedTapBarIndex == 2
                            ? buildFilterAndTapBarRowOfAnalysts(context)
                            : buildFilterAndTapBarRow(context),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  if (selectedTapBarIndex == 1)
                    (model == null || model!.data!.isEmpty) &&
                        _searchController.text.isEmpty
                        ? _isLoading
                        ? const SizedBox()
                        : SliverFillRemaining(
                      child: buildEmptyRecs(context),
                    )
                        :SliverFillRemaining(
                      child: ListView.separated(
                          controller: _paginationController,
                          itemBuilder: (context, index) {
                            return BuildHomeItem(
                              isTrading: true,
                              data: model!.data![index],
                              likeOnTap: () async {
                                if (model!.data![index].isFavorite == false) {
                                  await Provider.of<ServiceProvider>(context,
                                          listen: false)
                                      .favoriteRecommendation(int.parse(model!
                                          .data![index].opinionId
                                          .toString()))
                                      .then((value) {
                                    updateRecs();
                                  });
                                } else {
                                  await Provider.of<ServiceProvider>(context,
                                      listen: false)
                                      .favoriteRecommendation(int.parse(model!
                                      .data![index].opinionId
                                      .toString()))
                                      .then((value) {
                                    updateRecs();
                                  });
                                }
                              },
                              opinionTypeOnTap: () {
                                showCustomDialog(
                                  context: context,
                                  title:
                                      AppLocalizations.of(context)!.opinionType,
                                  body:
                                      model!.data![index].opinionTypeText ?? '',
                                );
                              },
                              showMoreOnTap: () {
                                showCustomDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .moreInformation,
                                  body: model!.data![index].opinionExtraInfo ??
                                      '',
                                );
                              },
                              addCommentOnTap: () {
                                showCustomDialogWithImage(
                                    buttonText:
                                        AppLocalizations.of(context)!.send,
                                    hintText: AppLocalizations.of(context)!
                                        .whatIsYourComment,
                                    title: AppLocalizations.of(context)!
                                        .addYourCommentForUs,
                                    body: AppLocalizations.of(context)!
                                        .dontHistateToAddYourComment,
                                    opinionId: int.parse(model!
                                        .data![index].opinionId
                                        .toString()),
                                    context: context,
                                    provider: Provider.of<ServiceProvider>(
                                        context,
                                        listen: false));
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: model!.data!.length),
                    ),
                  if (selectedTapBarIndex == 2 && analystsListModel != null)
                    SliverFillRemaining(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return AnalystContainer2(
                              subscribeOnTap:  () {

                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                    builder: (context) => Payment(
                                        listName: analystsListModel!.data![index].name,
                                        planId: analystsListModel!.data![index].planId
                                            .toString()
                                    )));

                              },
                              companyId:
                                  analystsListModel!.data![index].id.toString(),
                              companyName:
                                  analystsListModel!.data![index].name!,
                              successRate: analystsListModel!
                                  .data![index].successPercentage
                                  .toString(),
                              buyingOpinions: analystsListModel!
                                  .data![index].buyCount
                                  .toString(),
                              sellingOpinions: analystsListModel!
                                  .data![index].sellCount
                                  .toString(),
                              followed:
                                  analystsListModel!.data![index].isSubscribed!,
                              image:
                                  analystsListModel!.data![index].avatar ?? '',
                              onTap: () async {
                                print("HERETHEDEEEEEEEEEP");
                                print(analystsListModel!.data![index].name);
                                 Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => AnalystProfile2(
                                      category: 3,
                                      id: analystsListModel!.data![index].id
                                          .toString(),
                                      isSubscribed: analystsListModel!.data![index].isSubscribed!
                                  ),
                                ));

                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                              // height: 10,
                              ),
                          itemCount: analystsListModel!.data!.length),
                    ),
                ],
              ),
      ),
    );
  }

  Column buildEmptyRecs(BuildContext context) {
    return Column(
      children: [
        buildEmptyWidget(context),
      ],
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
            AppLocalizations.of(context)!.opinions,
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
            AppLocalizations.of(context)!.tradingLists,
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
        GestureDetector(
            onTap: () {
              showModalBottomSheet(
                constraints: BoxConstraints(minHeight: SizeUtility(context).height * 70/100,),
                isScrollControlled: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => SingleChildScrollView(
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
                                style: const TextStyle(
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
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
                                            color: orderType ==2
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
                              Text(
                                AppLocalizations.of(context)!.analysts,
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
                                          favorite = null;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: favorite == null
                                                    ? HexColor('#31d5c8')
                                                    : kMainColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: favorite == null
                                                ? HexColor('#31d5c8')
                                                : null),
                                        child: Text(
                                            AppLocalizations.of(context)!.all,
                                            style: TextStyle(
                                                color: favorite == null
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
                                          favorite = 1;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: favorite == 1
                                                    ? HexColor('#31d5c8')
                                                    : kMainColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: favorite == 1
                                                ? HexColor('#31d5c8')
                                                : null),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .favourite,
                                            style: TextStyle(
                                                color: favorite == 1
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
                                  Navigator.of(context).pop();
                                  updateRecs();
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
                                  Navigator.of(context).pop();
                                  updateRecs();
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

  Widget buildFilterAndTapBarRowOfAnalysts(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              selectedTapBarIndex = 1;
            });
          },
          child: Text(
            AppLocalizations.of(context)!.opinions,
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
            AppLocalizations.of(context)!.tradingLists,
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
                                // market type
                                Text(
                                  AppLocalizations.of(context)!.marketType,
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
                                          marketType = null;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: marketType == null
                                                    ? HexColor('#31d5c8')
                                                    : kMainColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: marketType == null
                                                ? HexColor('#31d5c8')
                                                : null),
                                        child: Text(
                                            AppLocalizations.of(context)!.all,
                                            style: TextStyle(
                                                color: marketType == null
                                                    ? Colors.white
                                                    : kMainColor)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          marketType = 1;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: marketType == 1
                                                    ? HexColor('#31d5c8')
                                                    : kMainColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: marketType == 1
                                                ? HexColor('#31d5c8')
                                                : null),
                                        child: Text(
                                            AppLocalizations.of(context)!.saudi,
                                            style: TextStyle(
                                                color: marketType == 1
                                                    ? Colors.white
                                                    : kMainColor)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          marketType = 2;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: SizeUtility(context).width * .28,
                                        decoration: BoxDecoration(
                                          color: marketType == 2
                                              ? HexColor('#31d5c8')
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: marketType == 2
                                                  ? HexColor('#31d5c8')
                                                  : kMainColor),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .american,
                                            style: TextStyle(
                                                color: marketType == 2
                                                    ? Colors.white
                                                    : kMainColor)),
                                      ),
                                    )
                                  ],
                                ),
                                /////////////////////////////////////////////////////////////////////
                                const SizedBox(
                                  height: 50,
                                ),
                                CustomButton(
                                  title: AppLocalizations.of(context)!.apply,
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    updateAnalystsList();
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => SizedBox(
                    height: 430,
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
                                                    .highestSuccessRate,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: kMainColor),
                                              ),
                                              if (selectedFilter == '1')
                                                const Icon(
                                                  Icons.check,
                                                  color: kMainColor2,
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
                                                    .highestFailingRate,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: kMainColor),
                                              ),
                                              if (selectedFilter == '2')
                                                const Icon(
                                                  Icons.check,
                                                  color: kMainColor2,
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
                                                    .lastAnalystsJoined,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: kMainColor),
                                              ),
                                              if (selectedFilter == '3')
                                                const Icon(
                                                  Icons.check,
                                                  color: kMainColor2,
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                title: AppLocalizations.of(context)!.apply,
                                onPressed: () {
                                  updateAnalystsList();

                                  //updateAnalystList();
                                  Navigator.of(context).pop();
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
            )),
      ],
    );
  }

  Row buildSearchRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            //width: SizeUtility(context).width * 60/ 100,
            child: TextField(
              controller: _searchController,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                /*setState(() {
                          exp = (element) => element['recommendationText'].contains(value);
                        });*/
                setState(() {
                  cursor = 1;
                });
              },
              onSubmitted: (value) {
                if (_searchController.text.trim().isNotEmpty) {
                  setState(() {
                    cursor = 1;
                  });
                  if(selectedTapBarIndex == 1){
                    updateRecs();
                  }else{
                    updateAnalystsList();
                  }
                }
              },
              decoration: InputDecoration(
                  hintText: ' ${AppLocalizations.of(context)!.search}',
                  hintStyle: const TextStyle(
                      color: iconColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.only(
                    right: 20,
                  ),
                  fillColor: textFieldColor,
                  filled: true,
                  suffixIcon: _searchController.text.trim().isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              cursor = 1;
                              _searchController.clear();
                            });
                            updateAnalystsList();
                            updateRecs();
                          },
                          icon: const Icon(Icons.close))
                      : null,
                  prefixIcon: InkWell(
                    onTap: () {
                      if (_searchController.text.trim().isNotEmpty) {
                        setState(() {
                          cursor = 1;
                        });
                        if(selectedTapBarIndex == 1){
                          updateRecs();
                        }else{
                          updateAnalystsList();
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ImageIcon(
                          const AssetImage(
                            'assets/icons/search.png',
                          ),
                          size: 20,
                          color: _searchController.text.trim().isNotEmpty
                              ? kMainColor
                              : null),
                    ),
                  ),
                  prefixIconColor: iconColor,
                  prefixIconConstraints: const BoxConstraints(minHeight: 20),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: textFieldBorderColor)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: textFieldBorderColor))),
            ),
          ),
        ),
      ],
    );
  }

  Center buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/videos/08.json',
              width: SizeUtility(context).width * 75 / 100, fit: BoxFit.cover),
          const SizedBox(
            height: 30,
          ),
          Text(
            AppLocalizations.of(context)!.emptyHome,
            style: const TextStyle(
                color: kMainColor, fontWeight: FontWeight.w600, fontSize: 25),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.toFollowAnalysts,
                style: const TextStyle(color: kSecondColor, fontSize: 14),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTapBarIndex = 2;
                    });
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (context) => Tabs(
                    //           index: 1,
                    //         )));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.goToAnalystList,
                    style: const TextStyle(
                        color: kMainColor,
                        fontSize: 14,
                        decoration: TextDecoration.underline),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
