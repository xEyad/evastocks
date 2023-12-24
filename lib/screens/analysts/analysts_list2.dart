import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nosooh/components/analyst_container.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/screens/notifications/notifications.dart';
import 'package:nosooh/screens/payment/payment.dart';
import 'package:nosooh/screens/profile/analyst_profile3.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:provider/provider.dart';

import '../../components/custom_button.dart';
import '../../models/markets_model/markets_model.dart';
import '../../models/rating_analysts_list_model/rating_analysts_model.dart';
import '../../utils/colors.dart';
import '../../utils/size_utility.dart';

class AnalystsListScreen2 extends StatefulWidget {
  const AnalystsListScreen2({super.key});

  @override
  State<AnalystsListScreen2> createState() => _AnalystsListScreen2State();
}

class _AnalystsListScreen2State extends State<AnalystsListScreen2> {
  // late Future _getAnalystList =
  //     Provider.of<ServiceProvider>(context).getAnalystList();
  final TextEditingController _searchController = TextEditingController();
  var exp = (element) => element == element;
  String? selectedFilter;
  bool showSearchBar = false;
  int selectedTapBarIndex = 1;
  bool _isLoading = false;
  int cursor = 1;
  int? marketType;
  MarketsModel? markets;

  static final _paginationController = ScrollController();

  RatingAnalystsListModel? analystList;

  initScrollingListener() {
    _paginationController.addListener(() {
      if (_paginationController.position.pixels ==
          _paginationController.position.maxScrollExtent) {
        setState(() {
          cursor++;
        });
        //updateAnalystListWithPagination();
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateAnalystList();
      // initScrollingListener();
      setState(() {
        markets = Provider.of<ServiceProvider>(context, listen: false).markets;
        _isLoading = false;
      });
    });

    super.initState();
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
              updateAnalystList();
            },
            child: Image.asset(
              'assets/icons/search.png',
              height: 40,
              width: 40,
              color: selectedIconColor,
            )),
        title: Text(
          AppLocalizations.of(context)!.evaLists,
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
                width: 26
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            if (showSearchBar) buildSearchRow(context),
            const SizedBox(height: 10),
            buildFilterAndTapBarRowOfAnalysts(context),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return AnalystListContainer2(
                    subscribeOnTap:  () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                          builder: (context) => Payment(
                              listName:  analystList!.data[index].name,
                              planId: analystList!.data[index].planId
                                  .toString()
                          )));

                    },
                    index: index,
                    followed: analystList!.data[index].isSubscribed!,
                    onTap: () {
                      print(
                          'analyst id ${analystList!.data[index].id.toString()}');
                      print('deep aab eeep');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnalystProfile3(
                              planeId: analystList!.data[index].planId,
                              analystName: analystList!.data[index].analystName,
                              id: analystList!.data[index].id.toString(),
                              isSubscribed:
                                  analystList!.data[index].isSubscribed!,
                              listName: analystList!.data[index].name,
                            ),
                          ));
                    },
                    image: analystList!.data[index].avatar,
                    stockNumber: analystList!.data[index].ratingsCount!,
                    bio: analystList!.data[index].bio,
                    name: analystList!.data[index].name,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: analystList?.data.length ?? 0,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
                setState(() {
                  cursor = 1;
                });
              },
              onSubmitted: (value) {
                if (_searchController.text.trim().isNotEmpty) {
                  updateAnalystList();
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
                            updateAnalystList();
                          },
                          icon: const Icon(Icons.close))
                      : null,
                  prefixIcon: InkWell(
                    onTap: () {
                      if (_searchController.text.trim().isNotEmpty) {
                        setState(() {
                          cursor = 1;
                        });
                        updateAnalystList();
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


  updateAnalystList() {
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
        .getRatingAnalystList(
      searchQuery: _searchController.text,
      marketId: selectedMarketId,
      appliedFilter: selectedFilter
    )
        .then((value) {
      setState(() {
        analystList = Provider.of<ServiceProvider>(context, listen: false)
            .ratingAnalystsListModel;
        _isLoading = false;
      });
    });
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
            AppLocalizations.of(context)!.evaLists,
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
                                    updateAnalystList();
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
                                  updateAnalystList();
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
}
