import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/custom_text_button.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../auth/login_2.dart';

class Walkthrough extends StatefulWidget {
  const Walkthrough({super.key});

  @override
  State<Walkthrough> createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  final PageController _pageController = PageController();
  int pageViewIndex = 0;
  List _walkthroughPages = [];

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        setState(() {
          _walkthroughPages = [
            {
              'image': 'assets/videos/01.json',
              'title': AppLocalizations.of(context)!.walkthroughFirstTitle,
              'subtitle':
                  AppLocalizations.of(context)!.walkthroughFirstSubtitle,
            },
            {
              'image': 'assets/videos/02.json',
              'title': AppLocalizations.of(context)!.walkthroughSecondTitle,
              'subtitle':
                  AppLocalizations.of(context)!.walkthroughSecondSubtitle,
            },
            {
              'image': 'assets/videos/03.json',
              'title': AppLocalizations.of(context)!.walkthroughThirdTitle,
              'subtitle':
                  AppLocalizations.of(context)!.walkthroughThirdSubtitle,
            },
          ];
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    pageViewIndex = value;
                  });
                  print(value);
                },
                controller: _pageController,
                children: _walkthroughPages
                    .map((page) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Lottie.asset(page['image'],
                                height: SizeUtility(context).height * 40 / 100),
                            Text(page['title'],
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: kMainColor)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(page['subtitle'],
                                style: const TextStyle(
                                    fontSize: 16, color: kSecondColor)),
                            const Spacer(),
                            Center(
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: 3,
                                effect: WormEffect(
                                    dotWidth: 10,
                                    dotHeight: 10,
                                    activeDotColor: selectedIconColor,
                                    dotColor: selectedIconColor.withOpacity(
                                        0.5)), // your preferred effect
                                onDotClicked: (index) {},
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
            if (pageViewIndex < 2)
              CustomButton(
                title: AppLocalizations.of(context)!.next,
                onPressed: () async {
                  if (_pageController.page! < 2) {
                    await _pageController.nextPage(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.ease);
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Login2(),
                    ));
                  }
                },
              ),
            if (pageViewIndex < 2)
              const SizedBox(
                height: 5,
              ),
            if (pageViewIndex < 2)
              CustomTextButton(
                textColor: Color.fromRGBO(141, 141, 141, 1),
                title: AppLocalizations.of(context)!.skip,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Login2(),
                  ));
                },
              ),
            if (pageViewIndex == 2)
              const SizedBox(
                height: 30,
              ),
            if (pageViewIndex == 2)
              CustomButton(
                title: AppLocalizations.of(context)!.startRegistration,
                onPressed: () async {
                  if (pageViewIndex < 2) {
                    await _pageController.nextPage(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.ease);
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Login2(),
                    ));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
