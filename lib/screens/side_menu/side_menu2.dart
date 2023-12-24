import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/screens/about_app/about_app.dart';
import 'package:nosooh/screens/my_bills/my_bills.dart';
import 'package:nosooh/screens/my_fav_screen/my_fav_screen.dart';
import 'package:nosooh/screens/settings/settings.dart';
import 'package:nosooh/services/api_service.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

import '../auth/login_2.dart';
import '../update_profile/update_profile2.dart';

class SideMenu2 extends StatefulWidget {
  const SideMenu2({super.key});

  @override
  State<SideMenu2> createState() => _SideMenu2State();
}

class _SideMenu2State extends State<SideMenu2> {
  late Future _getProfile2 = Provider.of<ServiceProvider>(
    context,
  ).getProfile2(context: context);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.more,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
      ),
      body: Container(
        width: SizeUtility(context).width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                FutureBuilder(
                  future: _getProfile2,
                  builder: (context, snapshot) {
                    if (snapshot.data?['status'] == false) {
                      return SizedBox();
                    }
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ClipOval(
                                  child: SizedBox.fromSize(
                                      size: const Size.fromRadius(45),
                                      child: (snapshot.data!['data']
                                                      ['avatar'] ==
                                                  null ||
                                              snapshot.data!['data']['avatar']
                                                  .toString()
                                                  .isEmpty)
                                          ? Image.asset(
                                              'assets/images/default_avatar.png',
                                              height: 80, width: 80)
                                          : Image.network(
                                              snapshot.data!['data']['avatar'],
                                              fit: BoxFit.cover,
                                              height: 80,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Image.asset(
                                                      'assets/images/default_avatar.png',
                                                      height: 80, width: 80),
                                            ))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                snapshot.data!['data']['name'],
                                style: const TextStyle(
                                    color: kMainColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Center(
                              child: Text(
                                snapshot.data!['data']['email'],
                                style: const TextStyle(
                                    color: kSecondColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  onTap: ()async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UpdateProfile2(),
                    )).then((value) {
                      setState(() {
                        _getProfile2 =  Provider.of<ServiceProvider>(
                          context,listen: false
                        ).getProfile2(context: context,);
                      });
                    });
                  },
                  leading:
                      const ImageIcon(AssetImage('assets/icons/user_icon.png'),
                          color: Color(0xff31d5c8),
                          //color: Color.fromRGBO(111, 107, 178, 1),
                          size: 30),
                  title: Text(
                    AppLocalizations.of(context)!.profile,
                    style: TextStyle(
                        color: myColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyBills(),
                    ));
                  },
                  leading:
                      const ImageIcon(AssetImage('assets/icons/bills_icon.png'),
                          //color: Color.fromRGBO(111, 107, 178, 1),
                          color: Color(0xff31d5c8),
                          size: 30),
                  title: Text(
                    AppLocalizations.of(context)!.myBills,
                    style: TextStyle(
                        color: myColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyFavoritesScreen(),
                    ));
                  },
                  leading:
                      const ImageIcon(AssetImage('assets/icons/fav_icon.png'),
                          //color: Color.fromRGBO(111, 107, 178, 1),
                          color: Color(0xff31d5c8),
                          size: 30),
                  title: Text(
                    AppLocalizations.of(context)!.myFavorites,
                    style: TextStyle(
                        color: myColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ));
                  },
                  leading: const ImageIcon(
                      AssetImage('assets/icons/settings_icon.png'),
                      //color: Color.fromRGBO(111, 107, 178, 1),
                      color: Color(0xff31d5c8),
                      size: 30),
                  title: Text(
                    AppLocalizations.of(context)!.settings,
                    style: TextStyle(
                        color: myColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    showHelpNosoohBottomSheet(context);
                  },
                  leading: const ImageIcon(
                      AssetImage('assets/icons/question_icon.png'),
                      color: Color(0xff31d5c8),

                      //color: Color.fromRGBO(111, 107, 178, 1),
                      size: 30),
                  title: Text(
                    AppLocalizations.of(context)!.help,
                    style: TextStyle(
                        color: myColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutApp(),
                    ));
                  },
                  leading: const ImageIcon(
                      AssetImage('assets/icons/informations_icon.png'),
                      //color: Color.fromRGBO(111, 107, 178, 1),
                      color: Color(0xff31d5c8),
                      size: 30),
                  title: Text(
                    AppLocalizations.of(context)!.aboutApp,
                    style: TextStyle(
                        color: myColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Provider.of<APIService>(context, listen: false).logout();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const Login2(),
                        ),
                        (route) => false);
                  },
                  leading: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:  Image.asset('assets/icons/logout.png',width: 20
                      ,height: 20,)
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(
                        color: Color.fromRGBO(234, 63, 63, 1),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
