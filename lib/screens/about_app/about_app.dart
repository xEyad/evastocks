import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/screens/about_app/about_app_details.dart';
import 'package:nosooh/screens/about_app/info_disclaimer.dart';
import 'package:nosooh/screens/about_app/terms_and_conditions.dart';
import 'package:nosooh/screens/faq/faq.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.aboutApp,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: kMainColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Lottie.asset('assets/animations/about_us_animation.json',
                fit: BoxFit.cover,
                width: SizeUtility(context).width * 50 / 100),

            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutAppDetails(),
                ));
              },
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      ImageIcon(
                          const AssetImage(
                            'assets/logos/logo.png',
                          ),
                          color: Color(0xff31d5c8),
                          size: 25),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        AppLocalizations.of(context)!.aboutEva ,
                        style: TextStyle(
                            color: kMainColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: suvaGreyColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                       InfoDisclaimer(),
                ));
              },
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      ImageIcon(AssetImage('assets/icons/statement.png'),
                          color: Color(0xff31d5c8), size: 25),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bayanE5la2,
                        style: TextStyle(
                            color: kMainColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: suvaGreyColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TermsAndConditions(),
                ));
              },
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      ImageIcon(AssetImage('assets/icons/terms.png'),
                          color: Color(0xff31d5c8), size: 25),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        AppLocalizations.of(context)!.termsAndConditions,
                        style: TextStyle(
                            color: kMainColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: suvaGreyColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FAQ(),
                ));
              },
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      ImageIcon(AssetImage('assets/icons/question_mark.png'),
                          color: Color(0xff31d5c8), size: 25),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        AppLocalizations.of(context)!.faq,
                        style: TextStyle(
                            color: kMainColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: suvaGreyColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
