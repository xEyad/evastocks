import 'package:flutter/material.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/screens/about_app/about_app.dart';
import 'package:nosooh/screens/auth/login_2.dart';
import 'package:nosooh/screens/my_bills/my_bills.dart';
import 'package:nosooh/screens/profile/profile.dart';
import 'package:nosooh/screens/settings/settings.dart';
import 'package:nosooh/screens/tabs/tabs.dart';
import 'package:nosooh/services/api_service.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late final _getProfile = Provider.of<ServiceProvider>(context,).getProfile();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Tabs(),));
        },child: Container(width: SizeUtility(context).width * .30)),
        Container(
          width: SizeUtility(context).width * .70,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80,),

             FutureBuilder(
               future: _getProfile,
               builder: (context, snapshot) {
                 if(snapshot.hasData){
                   return  Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,

                       children: [
                          ClipOval(child: SizedBox.fromSize(size:const Size.fromRadius(45),child: Image.network(snapshot.data!['data'].first['image'],fit: BoxFit.cover,height: 80,errorBuilder: (context, error, stackTrace) =>  Image.asset('assets/images/user.png',height: 80),))),
                         const SizedBox(height: 10,),
                         Text(snapshot.data!['data'].first['name'],style: const TextStyle(color: kMainColor,fontSize: 25,fontWeight: FontWeight.w500),),
                         const SizedBox(height: 2,),
                          Text(snapshot.data!['data'].first['userName'],style: const TextStyle(color: kSecondColor,fontSize: 15,fontWeight: FontWeight.w400),),

                       ],
                     ),
                   );
                 }
                 return const SizedBox();
               },

             ),
              const SizedBox(height: 50,),
              ListTile(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(),));

              },leading: const ImageIcon(AssetImage('assets/icons/user.png'),color: Color.fromRGBO(111, 107, 178, 1),size: 30),title: Text(AppLocalizations.of(context)!.profile,style: const TextStyle(
                color: kMainColor,
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),),trailing: const Icon(Icons.arrow_forward_ios,size: 20),),
              const SizedBox(height: 20,),

              ListTile(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyBills(),));
              },leading: const ImageIcon(AssetImage('assets/icons/my_bills.png'),color: Color.fromRGBO(111, 107, 178, 1),size: 30),title: Text(AppLocalizations.of(context)!.myBills,style: const TextStyle(
                color: kMainColor,
                fontSize: 18,
                  fontWeight: FontWeight.w500

              ),),trailing: const Icon(Icons.arrow_forward_ios,size: 20),),
              const SizedBox(height: 20,),

              ListTile(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings(),));

              },leading: const ImageIcon(AssetImage('assets/icons/setting.png'),color: Color.fromRGBO(111, 107, 178, 1),size: 30),title: Text(AppLocalizations.of(context)!.settings,style: const TextStyle(
                color: kMainColor,
                fontSize: 18,
                  fontWeight: FontWeight.w500

              ),),trailing: const Icon(Icons.arrow_forward_ios,size: 20),),
              const SizedBox(height: 20,),
              ListTile(onTap: (){
                showHelpNosoohBottomSheet(context);
              },leading: const ImageIcon(AssetImage('assets/icons/question.png'),color: Color.fromRGBO(111, 107, 178, 1),size: 30),title: Text(AppLocalizations.of(context)!.help,style: const TextStyle(
                color: kMainColor,
                fontSize: 18,
                  fontWeight: FontWeight.w500

              ),),trailing: const Icon(Icons.arrow_forward_ios,size: 20),),
              const SizedBox(height: 20,),

              ListTile(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutApp(),));

              },leading: const ImageIcon(AssetImage('assets/icons/information.png'),color: Color.fromRGBO(111, 107, 178, 1),size: 30),title: Text(AppLocalizations.of(context)!.aboutApp,style: const TextStyle(
                color: kMainColor,
                fontSize: 18,
                  fontWeight: FontWeight.w500

              ),),trailing: const Icon(Icons.arrow_forward_ios,size: 20),),
             const Spacer(),

              InkWell(
                onTap: (){
                  Provider.of<APIService>(context,listen: false).logout();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login2(),), (route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  child: Row(
                    children: [
                      const ImageIcon(AssetImage('assets/icons/logout.png'),color: Color.fromRGBO(234, 63, 63, 1)),
                      const SizedBox(width: 10,),
                      Text(AppLocalizations.of(context)!.logout,style: const TextStyle(color: Color.fromRGBO(234, 63, 63, 1),fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,)


            ],
          ),
        ),
      ],
    );
  }
}
