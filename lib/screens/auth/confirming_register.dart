import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/utils/colors.dart';

import '../../components/custom_button.dart';
import '../../utils/size_utility.dart';

class ConfirmingRegister extends StatefulWidget {
  final String mail;
  const ConfirmingRegister({super.key, required this.mail});

  @override
  State<ConfirmingRegister> createState() => _ConfirmingRegisterState();
}

class _ConfirmingRegisterState extends State<ConfirmingRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.newRegistration,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leadingWidth: SizeUtility(context).width * 0.35,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: SizeUtility(context).width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeUtility(context).height * .10,
                ),
                Image.asset('assets/logos/logo.png',
                    height: 70, fit: BoxFit.cover),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  AppLocalizations.of(context)!.thankYouToJoinEva,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: kMainColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  /*AppLocalizations.of(context)!.enterYourPhoneNumber*/ '${AppLocalizations.of(context)!.weSentLinkToYourEmail} ${widget.mail}',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: kSecondColor),
                ),
                Text(
                  AppLocalizations.of(context)!.pleaseVerifyYourMail,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: kSecondColor),
                ),
                const SizedBox(
                  height: 30,
                ),
                /* Center(
                  child: const SizedBox(
                      height: 200,
                      width: 200,
                      child: Center(child: CircularProgressIndicator())),
                ),*/
                Center(
                  child: Lottie.asset(
                      'assets/animations/confirming_animation.json',
                      width: SizeUtility(context).width * 50 / 100),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomButton(
                    title: AppLocalizations.of(context)!.goToLogin,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
