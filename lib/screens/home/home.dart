import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/components/recommendation_container.dart';
import 'package:nosooh/screens/add_feedback/add_feedback.dart';
import 'package:nosooh/screens/notifications/notifications.dart';
import 'package:nosooh/screens/tabs/tabs.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;
  String recommendationTypeFilter = 'all';
  String recommendationStrategyFilter = 'all';
  String analyticsFilter = 'all';

  //var exp = (element) => element == element;
  List recommendations = [];

  String? selectedFilter = '3';

  int cursor = 1;
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
    updateRecs();
    initScrollingListener();
    super.initState();
  }

  updateRecsWithPagination() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getRecommendationList(
            searchQuery: _searchController.text,
            cursor: cursor,
            appliedFilter: selectedFilter,
            recommendationStrategy: recommendationStrategyFilter == 'modarpa'
                ? '2'
                : recommendationStrategyFilter == 'estsmar'
                    ? '1'
                    : null,
            recommendationType: recommendationTypeFilter == 'buy'
                ? 'Buy'
                : recommendationTypeFilter == 'sell'
                    ? 'Sell'
                    : null,
            favourite: analyticsFilter == 'fav' ? '1' : null,
            isMine: analyticsFilter == 'mine' ? '1' : null)
        .then((value) {
      setState(() {
        recommendations.addAll(value['data']);
        _isLoading = false;
      });
    });
  }

  updateRecs() {
    setState(() {
      cursor = 1;
      _isLoading = true;
    });
    Provider.of<ServiceProvider>(context, listen: false)
        .getRecommendationList(
            searchQuery: _searchController.text,
            cursor: cursor,
            appliedFilter: selectedFilter,
            recommendationStrategy: recommendationStrategyFilter == 'modarpa'
                ? '2'
                : recommendationStrategyFilter == 'estsmar'
                    ? '1'
                    : null,
            recommendationType: recommendationTypeFilter == 'buy'
                ? 'Buy'
                : recommendationTypeFilter == 'sell'
                    ? 'Sell'
                    : null,
            favourite: analyticsFilter == 'fav' ? '1' : null,
            isMine: analyticsFilter == 'mine' ? '1' : null)
        .then((value) {
      setState(() {
        recommendations = value['data'];
        _isLoading = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => const AddFeedback(),
              ))
                  .then((value) {
                updateRecs();
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [kMainColor, kMainColor.withOpacity(0.2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: const Icon(Icons.add, color: Colors.white),
            )),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.home,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                showHelpNosoohBottomSheet(context);
              },
              child:
                  Image.asset('assets/icons/help.png', height: 40, width: 40)),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Notifications(),
                ));
              },
              child: Image.asset('assets/icons/notification.png',
                  height: 26, width: 26)),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: recommendations.isEmpty && _searchController.text.isEmpty
            ? _isLoading
                ? const SizedBox()
                : buildEmptyRecs(context)
            : SingleChildScrollView(
                controller: _paginationController,
                child: Column(
                  children: [
                    buildFilterAndSearchRow(context),
                    const SizedBox(height: 25),
                    Column(children: [
                      ...recommendations
                          .map<Widget>((rec) => RecommendationContainer(
                                recommendation: rec,
                                likeRecommendationFunction: () async {
                                  if (rec['isLiked'] == '0') {
                                    await Provider.of<ServiceProvider>(context,
                                            listen: false)
                                        .likeRecommendation(
                                            rec['recommendationId'])
                                        .then((value) {
                                      updateRecs();
                                    });
                                  } else {
                                    await Provider.of<ServiceProvider>(context,
                                            listen: false)
                                        .disLikeRecommendation(
                                            rec['recommendationId'])
                                        .then((value) {
                                      updateRecs();
                                    });
                                  }
                                },
                                notifyMeFunction: () async {
                                  if (rec['notifyMe'] == '0') {
                                    await Provider.of<ServiceProvider>(context,
                                            listen: false)
                                        .recommendationNotify(
                                            rec['recommendationId'])
                                        .then((value) {
                                      updateRecs();
                                    });
                                  } else {
                                    await Provider.of<ServiceProvider>(context,
                                            listen: false)
                                        .recommendationDeNotify(
                                            rec['recommendationId'])
                                        .then((value) {
                                      updateRecs();
                                    });
                                  }
                                },
                              ))
                          .toList(),

                      /*  if(_isLoading)
                      LoadingIndicator(),*/

                      const SizedBox(
                        height: 50,
                      )
                    ]),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
      ),
    );
  }

  Column buildEmptyRecs(BuildContext context) {
    return Column(
      children: [
        buildFilterAndSearchRow(context),
        const SizedBox(height: 25),
        buildEmptyWidget(context),
      ],
    );
  }

  Row buildFilterAndSearchRow(BuildContext context) {
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
                  updateRecs();
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
                        updateRecs();
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
        const SizedBox(
          width: 10,
        ),
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
                                    .analystsRecommendations,
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
                                          border: Border.all(color: kMainColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: recommendationStrategyFilter ==
                                                  'all'
                                              ? kMainColor
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
                                        recommendationStrategyFilter =
                                            'modarpa';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: SizeUtility(context).width * .28,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: kMainColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: recommendationStrategyFilter ==
                                                  'modarpa'
                                              ? kMainColor
                                              : null),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .dayTrading,
                                          style: TextStyle(
                                              color:
                                                  recommendationStrategyFilter ==
                                                          'modarpa'
                                                      ? Colors.white
                                                      : kMainColor)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        recommendationStrategyFilter =
                                            'estsmar';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: SizeUtility(context).width * .28,
                                      decoration: BoxDecoration(
                                        color: recommendationStrategyFilter ==
                                                'estsmar'
                                            ? kMainColor
                                            : null,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: kMainColor),
                                      ),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .investment,
                                          style: TextStyle(
                                              color:
                                                  recommendationStrategyFilter ==
                                                          'estsmar'
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
                                AppLocalizations.of(context)!
                                    .recommendationType,
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
                                        recommendationTypeFilter = 'all';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: SizeUtility(context).width * .28,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: kMainColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              recommendationTypeFilter == 'all'
                                                  ? kMainColor
                                                  : null),
                                      child: Text(
                                          AppLocalizations.of(context)!.all,
                                          style: TextStyle(
                                              color: recommendationTypeFilter ==
                                                      'all'
                                                  ? Colors.white
                                                  : kMainColor)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        recommendationTypeFilter = 'buy';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: SizeUtility(context).width * .28,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: kMainColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              recommendationTypeFilter == 'buy'
                                                  ? kMainColor
                                                  : null),
                                      child: Text(
                                          AppLocalizations.of(context)!.buy,
                                          style: TextStyle(
                                              color: recommendationTypeFilter ==
                                                      'buy'
                                                  ? Colors.white
                                                  : kMainColor)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        recommendationTypeFilter = 'sell';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: SizeUtility(context).width * .28,
                                      decoration: BoxDecoration(
                                        color:
                                            recommendationTypeFilter == 'sell'
                                                ? kMainColor
                                                : null,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: kMainColor),
                                      ),
                                      child: Text(
                                          AppLocalizations.of(context)!.sell,
                                          style: TextStyle(
                                              color: recommendationTypeFilter ==
                                                      'sell'
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
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        analyticsFilter = 'all';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: SizeUtility(context).width * .28,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: kMainColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: analyticsFilter == 'all'
                                              ? kMainColor
                                              : null),
                                      child: Text(
                                          AppLocalizations.of(context)!.all,
                                          style: TextStyle(
                                              color: analyticsFilter == 'all'
                                                  ? Colors.white
                                                  : kMainColor)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        analyticsFilter = 'fav';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: SizeUtility(context).width * .28,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: kMainColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: analyticsFilter == 'fav'
                                              ? kMainColor
                                              : null),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .favourite,
                                          style: TextStyle(
                                              color: analyticsFilter == 'fav'
                                                  ? Colors.white
                                                  : kMainColor)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        analyticsFilter = 'mine';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: SizeUtility(context).width * .28,
                                      decoration: BoxDecoration(
                                        color: analyticsFilter == 'mine'
                                            ? kMainColor
                                            : null,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: kMainColor),
                                      ),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .myRecommendation,
                                          style: TextStyle(
                                              color: analyticsFilter == 'mine'
                                                  ? Colors.white
                                                  : kMainColor)),
                                    ),
                                  )
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Tabs(
                              index: 1,
                            )));
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
