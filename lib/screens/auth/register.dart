import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/services/auth_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:provider/provider.dart';

import '../../utils/size_utility.dart';
import '../../utils/validators.dart';
import 'confirming_register.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.newRegistration,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        // leadingWidth: SizeUtility(context).width * 0.35,
        //   leading: const BackButton(),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kMainColor,
          ),
        ),
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
                    AppLocalizations.of(context)!.letsRegister,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kMainColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.registerNewAccountInEva,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: kSecondColor),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!
                            .enterTheFieldCorrectly;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  BorderSide(
                                color: activeFormFieldBorderColor
                            )),
                        hintText: AppLocalizations.of(context)!.name,
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
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!
                            .enterTheFieldCorrectly;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  BorderSide(
                                color: activeFormFieldBorderColor
                            )),
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
                                color: Color.fromRGBO(242, 242, 242, 1)))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    // textDirection: TextDirection.ltr,
                    validator: phoneNumberValidator,
                    controller: phoneController,
                    maxLength: _country!.example.length,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(

                        hintText:
                            ' ' + AppLocalizations.of(context)!.phoneNumber,
                        hintTextDirection: TextDirection.ltr,
                        filled: true,
                        fillColor: const Color.fromRGBO(249, 249, 249, 1),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 2, right: 2, top: 2, bottom: 2),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              width: 120,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  color: Color.fromRGBO(240, 240, 240, 1)),
                              child: InkWell(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    useSafeArea: true,
                                    onSelect: (Country country) {
                                      print(country.toJson());
                                      setState(() {
                                        _country = country;
                                      });
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      _country!.phoneCode,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: kSecondColor),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _country!.flagEmoji,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: kSecondColor),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(Icons.keyboard_arrow_down,
                                        color: Color.fromRGBO(141, 141, 141, 1))
                                  ],
                                ),
                              )),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(242, 242, 242, 1))),
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
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!
                            .enterTheFieldCorrectly;
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
                  /*
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل رقم الجوال';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'رقم جوال',
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
                  */

                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                          title: AppLocalizations.of(context)!.newRegistration,
                          onPressed: register),
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
                      await Provider.of<AuthProvider>(context, listen: false)
                          .signInWithGoogle();
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
                        AppLocalizations.of(context)!.alreadyHaveAnAccount,
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
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: TextStyle(
                              fontSize: 13,
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

  register() async {
    if (_globalKey.currentState!.validate()) {
      setState(() {
        Provider.of<AuthProvider>(context, listen: false).countryCode =
            '+${_country!.phoneCode}';
        Provider.of<AuthProvider>(context, listen: false).phoneNumber =
            phoneController.text.trim();
        _isLoading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false)
          .register(
        password: passwordController.text,
        email: emailController.text,
        //TODO: change name here
        name: nameController.text,
      )
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value['status'] == true) {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => const VerifyOTP(),
          // ));
          showMessage(
              backgroundColor: selectedIconColor,
              ctx: context,
              message: /*AppLocalizations.of(context)!.tryAgainLater*/
                  value['data']['msg'],
              title: AppLocalizations.of(context)!.success);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ConfirmingRegister(mail: emailController.text),
              ));
        } else {
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
