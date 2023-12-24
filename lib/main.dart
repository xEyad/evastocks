import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/screens/auth/login_2.dart';
import 'package:nosooh/screens/personal_profile/finance_data.dart';
import 'package:nosooh/screens/personal_profile/personal_data.dart';
import 'package:nosooh/screens/personal_profile/risk_recognition.dart';
import 'package:nosooh/screens/splash/splash.dart';
import 'package:nosooh/screens/walkthrough/walkthrough.dart';
import 'package:nosooh/services/api_service.dart';
import 'package:nosooh/services/auth_provider.dart';
import 'package:nosooh/services/navigation_service.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN $token");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<NavigationService>(
        create: (context) => NavigationService()),
    ChangeNotifierProvider<APIService>(create: (context) => APIService()),
    ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
    ChangeNotifierProvider<ServiceProvider>(
        create: (context) => ServiceProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EVA Stocks',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: labelFormFieldColor,
            selectionColor: labelFormFieldColor,
            selectionHandleColor: labelFormFieldColor,
          ),
          fontFamily: globalFontFamily,
          useMaterial3: false,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        locale: Provider.of<NavigationService>(context).appLocale,
        navigatorKey: NavigationService.navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, child!),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(450, name: 'MOBILE'),
              const ResponsiveBreakpoint.autoScale(800, name: 'TABLET'),
              const ResponsiveBreakpoint.autoScale(1000, name: 'TABLET'),
              const ResponsiveBreakpoint.resize(1200, name: 'DESKTOP'),
              const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
            background: Container(
              color: const Color(0xFFF5F5F5),
            )),
        home: const Splash());
  }
}
