import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/screens/profile/analyst_profile2.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

import '../../components/analyst_container.dart';
import '../../components/build_home_item.dart';
import '../../components/show_dialog_widget.dart';
import '../../components/show_dialog_with_image.dart';
import '../../models/rating_favorite_analysts_list_model/rating_favorite_analysts_list_model.dart';
import '../../models/trading_model/trading_model.dart';
import '../notifications/notifications.dart';
import '../payment/payment.dart';
import '../profile/analyst_profile3.dart';

class MyFavoritesScreen extends StatefulWidget {
  const MyFavoritesScreen({super.key});

  @override
  State<MyFavoritesScreen> createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  bool _isLoading = true;
  TradingModel? favoriteTradingListModel;
  TradingModel? favoriteInvestmentListModel;
  RatingFavoritesAnalystsListModel? analystList;

  bool showSearchBar = false;
  int selectedTapBarIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  static final _paginationController = ScrollController();

  initScrollingListener() {
    _paginationController.addListener(() {
      if (_paginationController.position.pixels ==
          _paginationController.position.maxScrollExtent) {
        // setState(() {
        //   cursor++;
        // });
        // print(cursor);
        // updateTradingRecsWithPagination();
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateTradingRecs();
      updateInvestmentRecs();
      updateAnalystsList();
      initScrollingListener();
    });
    super.initState();
  }

  updateTradingRecs() {
    setState(() {
      // cursor = 1;
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getTradingRecommendationList(searchQuery: _searchController.text,favorite: 1,)
        .then((value) {
      setState(() {
        favoriteTradingListModel =
            Provider.of<ServiceProvider>(context, listen: false)
                .tradingModel;
        _isLoading = false;
      });
    });

  }

  updateInvestmentRecs() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getInvestmentRecommendationList(searchQuery:  _searchController.text,favorite: 1)
        .then((value) {
      setState(() {
        favoriteInvestmentListModel =
            Provider.of<ServiceProvider>(context, listen: false)
                .investmentModel;
        _isLoading = false;
      });
    });

  }

  updateAnalystsList() {
    setState(() {
      // cursor = 1;
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getRatingFavoriteAnalystList(
      searchQuery: _searchController.text,
    )
        .then((value) {
      setState(() {
        analystList = Provider.of<ServiceProvider>(context, listen: false)
            .ratingFavoriteAnalystsListModel;
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
        leadingWidth: 90,
        leading: Row(
          children: [
            BackButton(color: Colors.black),
            GestureDetector(
                onTap: () {
                  setState(() {
                    showSearchBar = !showSearchBar;
                  });
                  if(!showSearchBar){
                    _searchController.clear();
                    if(selectedTapBarIndex == 1){
                      updateTradingRecs();
                    }else if(selectedTapBarIndex == 2){
                      updateInvestmentRecs();
                    }else{
                      updateAnalystsList();
                    }
                  }
                },
                child: Image.asset(
                  'assets/icons/search.png',
                  height: 40,
                  width: 40,
                  color: selectedIconColor,
                )),
          ],
        ),
        title: Text(
          AppLocalizations.of(context)!.myFavorites,
          style: TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: (favoriteTradingListModel == null ||
                    favoriteTradingListModel!.data!.isEmpty) &&
                _searchController.text.isEmpty
            ? _isLoading
                ? const SizedBox()
                : buildEmptyRecs(context)
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (showSearchBar) buildSearchRow(context),
                        const SizedBox(height: 10),
                        buildFilterAndTapBarRow(context),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  if (selectedTapBarIndex == 1)
                    SliverFillRemaining(
                      child: ListView.separated(
                          controller: _paginationController,
                          itemBuilder: (context, index) {
                            return BuildHomeItem(
                              isTrading: true,
                              data: favoriteTradingListModel!.data![index],
                              likeOnTap: () async {
                                if (favoriteTradingListModel!
                                        .data![index].isFavorite ==
                                    false) {
                                  await Provider.of<ServiceProvider>(context,
                                          listen: false)
                                      .favoriteRecommendation(int.parse(
                                          favoriteTradingListModel!
                                              .data![index].opinionId
                                              .toString()))
                                      .then((value) {
                                    updateTradingRecs();
                                  });
                                } else {
                                  // await Provider.of<ServiceProvider>(context,
                                  //         listen: false)
                                  //     .disLikeRecommendation(
                                  //         rec['recommendationId'])
                                  //     .then((value) {
                                  //   updateTradingRecs();
                                  // });
                                }
                              },
                              opinionTypeOnTap: () {
                                showCustomDialog(
                                  context: context,
                                  title:
                                      AppLocalizations.of(context)!.opinionType,
                                  body: favoriteTradingListModel!
                                          .data![index].opinionTypeText ??
                                      '',
                                );
                              },
                              showMoreOnTap: () {
                                showCustomDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .moreInformation,
                                  body: favoriteTradingListModel!
                                          .data![index].opinionExtraInfo ??
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
                                    opinionId: int.parse(
                                        favoriteTradingListModel!
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
                          itemCount: favoriteTradingListModel!.data!.length),
                    ),
                  if (selectedTapBarIndex == 2)
                    SliverFillRemaining(
                      child: ListView.separated(
                          controller: _paginationController,
                          itemBuilder: (context, index) {
                            return BuildHomeItem(
                              isTrading: true,
                              data: favoriteInvestmentListModel!.data![index],
                              likeOnTap: () async {
                                if (favoriteInvestmentListModel!
                                        .data![index].isFavorite ==
                                    false) {
                                  await Provider.of<ServiceProvider>(context,
                                          listen: false)
                                      .favoriteRecommendation(int.parse(
                                          favoriteInvestmentListModel!
                                              .data![index].opinionId
                                              .toString()))
                                      .then((value) {
                                    updateInvestmentRecs();
                                  });
                                } else {
                                  // await Provider.of<ServiceProvider>(context,
                                  //         listen: false)
                                  //     .disLikeRecommendation(
                                  //         rec['recommendationId'])
                                  //     .then((value) {
                                  //   updateTradingRecs();
                                  // });
                                }
                              },
                              opinionTypeOnTap: () {
                                showCustomDialog(
                                  context: context,
                                  title:
                                      AppLocalizations.of(context)!.opinionType,
                                  body: favoriteInvestmentListModel!
                                          .data![index].opinionTypeText ??
                                      '',
                                );
                              },
                              showMoreOnTap: () {
                                showCustomDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .moreInformation,
                                  body: favoriteInvestmentListModel!
                                          .data![index].opinionExtraInfo ??
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
                                    opinionId: int.parse(
                                        favoriteInvestmentListModel!
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
                          itemCount: favoriteInvestmentListModel!.data!.length),
                    ),
                  if (selectedTapBarIndex == 3 && analystList != null)
                    SliverFillRemaining(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return AnalystListContainer2(
                            subscribeOnTap:  () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                  builder: (context) => Payment(
                                      listName: analystList!.data[index].name,
                                      planId:analystList!.data[index].planId
                                          .toString()
                                  )));

                            },
                            index: index,
                            followed: analystList!.data[index].isSubscribed!,
                            onTap: () async{
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => AnalystProfile3(
                                  analystName: analystList!.data![index].name,
                                    planeId: analystList!.data![index].planId,
                                    id: analystList!.data![index].id
                                        .toString(),
                                    isSubscribed: analystList!.data![index].isSubscribed!,
                                   listName: analystList!.data![index].name,

                                ),
                              ));

                            },
                            image: analystList!.data[index].avatar,
                            name: analystList!.data[index].name,
                            bio: analystList!.data[index].bio,
                            stockNumber: analystList!.data[index].ratingsCount,
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                        itemCount: analystList?.data.length ?? 0,
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Column buildEmptyRecs(BuildContext context) {
    return Column(
      children: [
        buildFilterAndTapBarRow(context),
        const SizedBox(height: 25),
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
            AppLocalizations.of(context)!.trading,
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
            AppLocalizations.of(context)!.investment,
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
        TextButton(
          onPressed: () {
            setState(() {
              selectedTapBarIndex = 3;
            });
          },
          child: Text(
            AppLocalizations.of(context)!.lists,
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

                // setState(() {
                //   cursor = 1;
                // });
              },
              onSubmitted: (value) {
                if (_searchController.text.trim().isNotEmpty) {
                  if(selectedTapBarIndex == 1){
                    updateTradingRecs();
                  }else if(selectedTapBarIndex == 2){
                    updateInvestmentRecs();
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
                              _searchController.clear();
                            });
                            if(selectedTapBarIndex == 1){
                              updateTradingRecs();
                            }else if(selectedTapBarIndex == 2){
                              updateInvestmentRecs();
                            }else{
                              updateAnalystsList();
                            }
                          },
                          icon: const Icon(Icons.close))
                      : null,
                  prefixIcon: InkWell(
                    onTap: () {
                      if (_searchController.text.trim().isNotEmpty) {
                        if(selectedTapBarIndex == 1){
                          updateTradingRecs();
                        }else if(selectedTapBarIndex == 2){
                          updateInvestmentRecs();
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
                      selectedTapBarIndex = 3;
                    });

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
