import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/screens/settings/notifications_settings.dart';
import 'package:nosooh/services/navigation_service.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: kMainColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/videos/settings.json',
              height: 250,
              fit: BoxFit.cover,

            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NotificationsSettings(),
                ));
              },
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                       ImageIcon(
                          AssetImage(
                            'assets/icons/notification_outlined.png',
                          ),
                          color: HexColor('#31D5C8'),

                          size: 20),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        AppLocalizations.of(context)!.notifications,
                        style: const TextStyle(
                            color: kMainColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                       Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(141, 141, 141, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                if (Provider.of<NavigationService>(context, listen: false)
                        .appLocale
                        .languageCode ==
                    'ar') {
                  Provider.of<NavigationService>(context, listen: false)
                      .changeLanguage(const Locale('en'));
                } else {
                  Provider.of<NavigationService>(context, listen: false)
                      .changeLanguage(const Locale('ar'));
                }
              },
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                       ImageIcon(
                          AssetImage(
                            'assets/icons/translate.png',
                          ),
                          color: HexColor('#31D5C8'),
                          size: 20),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        AppLocalizations.of(context)!.changeLanguage,
                        style: const TextStyle(
                            color: kMainColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        Provider.of<NavigationService>(context, listen: false)
                                    .appLocale
                                    .languageCode ==
                                'ar'
                            ? AppLocalizations.of(context)!.english
                            : AppLocalizations.of(context)!.arabic,
                        style: const TextStyle(
                            color: kSecondColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
