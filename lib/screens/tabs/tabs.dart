import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/screens/home/investment.dart';
import 'package:nosooh/screens/side_menu/side_menu.dart';
import 'package:nosooh/utils/colors.dart';

import '../analysts/analysts_list2.dart';
import '../home/trading.dart';
import '../side_menu/side_menu2.dart';

class Tabs extends StatefulWidget {
  int index;

  Tabs({super.key, this.index = 0});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  List pages = [
    const TradingScreen(),
    const InvestmentScreen(),
    const AnalystsListScreen2(),
    //const Consulting(),
    const SideMenu2(),
  ];

  onTap(int ind) {
    setState(() {
      widget.index = ind;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      extendBody: true,
      drawer: const SideMenu(),
      body: pages[widget.index],
      bottomNavigationBar: DotNavigationBar(
        marginR: const EdgeInsets.all(20),
        dotIndicatorColor: Colors.transparent,
        paddingR: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        currentIndex: widget.index,
        onTap: onTap,
        enableFloatingNavBar: true,
        margin: EdgeInsets.zero,
        unselectedItemColor: const Color.fromRGBO(141, 141, 141, 1),
        duration: Duration.zero,
        enablePaddingAnimation: false,
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              blurRadius: 6,
              spreadRadius: 1,
              blurStyle: BlurStyle.inner)
        ],
        items: [
          DotNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(AssetImage('assets/icons/trading.png')),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.trading,
                    style: TextStyle(
                      color: widget.index == 0
                          ? selectedNavIconColor
                          : unSelectedNavIconColor,
                    ),
                  ),
                ],
              ),
              selectedColor: selectedNavIconColor,
              unselectedColor: unSelectedNavIconColor),
          DotNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(AssetImage('assets/icons/investment.png')),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.investment,
                    style: TextStyle(
                      color: widget.index == 1
                          ? selectedNavIconColor
                          : unSelectedNavIconColor,
                    ),
                  ),
                ],
              ),
              selectedColor: selectedNavIconColor,
              unselectedColor: unSelectedNavIconColor),
          DotNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(AssetImage('assets/icons/list.png')),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.lists,
                    style: TextStyle(
                      color: widget.index == 2
                          ? selectedNavIconColor
                          : unSelectedNavIconColor,
                    ),
                  ),
                ],
              ),
              selectedColor: selectedNavIconColor,
              unselectedColor: unSelectedNavIconColor),
          DotNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(AssetImage('assets/icons/infography.png')),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.more,
                    style: TextStyle(
                      color: widget.index == 3
                          ? selectedNavIconColor
                          : unSelectedNavIconColor,
                    ),
                  ),
                ],
              ),
              selectedColor: selectedNavIconColor,
              unselectedColor: unSelectedNavIconColor),
        ],
      ),
    );
  }
}
