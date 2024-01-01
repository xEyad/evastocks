import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/screens/Auth/verify_otp.dart';
import 'package:nosooh/screens/auth/register.dart';
import 'package:nosooh/services/auth_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:provider/provider.dart';

import '../../utils/size_utility.dart';
import '../tabs/tabs.dart';
import 'forget_password_screen.dart';

class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State<Login2> createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  Country? _country = Country(
      phoneCode: '966',
      countryCode: 'SA',
      e164Sc: 966,
      geographic: true,
      level: 1,
      name: 'Saudi Arabia',
      example: '512345678',
      displayName: 'Saudi Arabia (SA) [+966]',
      displayNameNoCountryCode: 'Saudi Arabia (SA)',
      e164Key: '966-SA-0');
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.login,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leadingWidth: SizeUtility(context).width * 0.35,
        leading: const BackButton(),
      ),
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: SizeUtility(context).width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset('assets/logos/logo.png',
                      height: 70, fit: BoxFit.cover),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)!.letsLogin,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kMainColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.enterEmailAndPassword,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: kSecondColor),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل بريدك الالكتروني';
                      }
                      return null;
                    },
                    // cursorColor:labelFormFieldColor ,
                    // style: TextStyle(
                    //   color: labelFormFieldColor,
                    // ),
                    
                    decoration: InputDecoration(
                      // labelStyle: TextStyle(
                      //   color: labelFormFieldColor,
                      // ),
                      // hintStyle: TextStyle(
                      //   color: labelFormFieldColor,
                      // ),
                      hintText: AppLocalizations.of(context)!.email,
                      filled: true,
                      fillColor: const Color.fromRGBO(249, 249, 249, 1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(242, 242, 242, 1)
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:  BorderSide(

                              color: activeFormFieldBorderColor
                          )),

                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل كلمة المرور';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  BorderSide(
                                color: activeFormFieldBorderColor
                            )),
                        hintText: AppLocalizations.of(context)!.password,
                        filled: true,
                        fillColor: const Color.fromRGBO(249, 249, 249, 1),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(242, 242, 242, 1))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(242, 242, 242, 1)))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.didYouForgetPassword,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: '',
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff305CD5),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                      title: AppLocalizations.of(context)!.login,
                      onPressed: login2),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.orWith,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: kSecondColor),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if(Platform.isAndroid)
                  InkWell(
                    onTap: () async {
                      final value = await Provider.of<AuthProvider>(context, listen: false)
                          .signInWithGoogle();
                          if (value['status'] == true) {
                           await Provider.of<AuthProvider>(context, listen: false)
                              .updateJWTToken(jwtToken: value['data']['token'])
                              .then((_) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => Tabs(),
                              ),
                              (route) => false,
                            );
                          });
                          } else {
                            showMessage(
                                ctx: context,
                                message: AppLocalizations.of(context)!.tryAgainLater,
                                title: AppLocalizations.of(context)!.wrong);
                          }
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: selectedIconColor, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Google',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: selectedIconColor),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset('assets/icons/gmail.png'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if(Platform.isIOS)
                  InkWell(
                    onTap: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .signInWithApple();
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: selectedIconColor, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Apple',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: selectedIconColor),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset('assets/icons/apple.png',
                            width: 30,
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dontHaveAnAccount,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: kSecondColor),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Register(),
                              ));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.newRegistration,
                          style: const TextStyle(
                              fontSize: 13,
                              fontFamily: '',
                              fontWeight: FontWeight.w600,
                              color: selectedIconColor,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (_globalKey.currentState!.validate()) {
      setState(() {
        Provider.of<AuthProvider>(context, listen: false).countryCode =
            '+${_country!.phoneCode}';
        Provider.of<AuthProvider>(context, listen: false).phoneNumber =
            _phoneController.text.trim();
        _isLoading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false)
          .login()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value['status'] == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const VerifyOTP(),
          ));
        } else {
          showMessage(
              ctx: context,
              message: AppLocalizations.of(context)!.tryAgainLater,
              title: AppLocalizations.of(context)!.wrong);
        }
      });
    } else {
      return;
    }
  }

  login2() async {
    if (_globalKey.currentState!.validate()) {
      await Provider.of<AuthProvider>(context, listen: false)
          .login2(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        setState(() {
          _isLoading = false;
        });
        if (value['status'] == true) {
          await Provider.of<AuthProvider>(context, listen: false)
              .updateJWTToken(jwtToken: value['data']['data']['token'])
              .then((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Tabs(),
              ),
              (route) => false,
            );
          });
        } else {
          print(value.toString());
          showMessage(
              ctx: context,
              message: /*AppLocalizations.of(context)!.tryAgainLater*/
                  value['data']['msg'],
              title: AppLocalizations.of(context)!.wrong);
        }
      });
    } else {
      return;
    }
  }
}
