import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/screens/walkthrough/walkthrough.dart';
import 'package:nosooh/services/navigation_service.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

class SelectAppLanguage extends StatefulWidget {
  const SelectAppLanguage({super.key});

  @override
  State<SelectAppLanguage> createState() => _SelectAppLanguageState();
}

class _SelectAppLanguageState extends State<SelectAppLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeUtility(context).height * 10 / 100,
            ),
            Center(
                child: Lottie.asset('assets/videos/06.json',
                    height: SizeUtility(context).height * 0.30)),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.selectAppLanguage,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        color: kMainColor)),
                const SizedBox(
                  height: 10,
                ),
                Text(AppLocalizations.of(context)!.youCanChangeItLater,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: kSecondColor)),
                const SizedBox(
                  height: 20,
                ),
                buildArLanguageSelector(),
                const SizedBox(
                  height: 10,
                ),
                buildEnLanguageSelector(),
              ],
            ),
            SizedBox(
              height: SizeUtility(context).height * 20 / 100,
            ),
            CustomButton(
              title: AppLocalizations.of(context)!.next,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Walkthrough(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  buildArLanguageSelector() {
    return GestureDetector(
      onTap: () {
        Provider.of<NavigationService>(context, listen: false)
            .changeLanguage(const Locale('ar'));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: Provider.of<NavigationService>(context, listen: false)
                    .appLocale
                    .languageCode ==
                'ar',
            replacement:
                Image.asset('assets/icons/empty_radio.png', height: 24),
            child: const ImageIcon(AssetImage('assets/icons/checked_radio.png'),
                color: kMainColor2, size: 24),
          ),
          const SizedBox(width: 8),
          Text(
            '${AppLocalizations.of(context)!.arabic}',
            style: TextStyle(
                color: kMainColor, fontWeight: FontWeight.w600, fontSize: 14),
          )
        ],
      ),
    );
  }

  buildEnLanguageSelector() {
    return GestureDetector(
      onTap: () {
        Provider.of<NavigationService>(context, listen: false)
            .changeLanguage(const Locale('en'));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: Provider.of<NavigationService>(context, listen: false)
                    .appLocale
                    .languageCode ==
                'en',
            replacement:
                Image.asset('assets/icons/empty_radio.png', height: 24),
            child: const ImageIcon(AssetImage('assets/icons/checked_radio.png'),
                color: kMainColor2, size: 24),
          ),
          const SizedBox(width: 8),
          Text(
            '${AppLocalizations.of(context)!.english}',
            style: TextStyle(
                color: kMainColor, fontWeight: FontWeight.w600, fontSize: 14),
          )
        ],
      ),
    );
  }
}
