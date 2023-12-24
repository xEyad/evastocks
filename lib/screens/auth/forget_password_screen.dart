import 'package:flutter/material.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import '../../utils/functions.dart';
import '../../utils/size_utility.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          /*AppLocalizations.of(context)!.login*/ 'نسيت كلمة المرور',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        //leadingWidth: SizeUtility(context).width * 0.35,
        centerTitle: true,
        leading:  IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios,
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
                    height: SizeUtility(context).height * .10,
                  ),
                  Image.asset('assets/logos/logo.png',
                      height: 70, fit: BoxFit.cover),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    /*AppLocalizations.of(context)!.yourPhoneNumber*/ "هل نسيت كلمة مرورك؟",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kMainColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    /*AppLocalizations.of(context)!.enterYourPhoneNumber*/ 'أدخل بريدك الإلكتروني، لتعيين كلمة مرور جديد',
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
                    decoration: InputDecoration(
                        hintText: 'الايميل',
                        filled: true,
                        fillColor: const Color.fromRGBO(249, 249, 249, 1),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:  BorderSide(
                                color: activeFormFieldBorderColor
                            )),
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
                    height: 60,
                  ),
                  CustomButton(
                      title: /*AppLocalizations.of(context)!.login*/ 'تأكيد',
                      onPressed: sendEmail),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendEmail() async {
    if (_globalKey.currentState!.validate()) {
      await Provider.of<AuthProvider>(context, listen: false)
          .forgetPassword(
        email: emailController.text,
      )
          .then((value) async {
        setState(() {
          _isLoading = false;
        });
        if (value['status']) {
          showMessage(
              backgroundColor: Colors.deepOrange,
              ctx: context,
              message: /*AppLocalizations.of(context)!.tryAgainLater*/
                  value['data']['msg'],
              title: '');
        } else {
          showMessage(
              ctx: context,
              message: /*AppLocalizations.of(context)!.tryAgainLater*/
                  value['data']['msg'],
              title: '');
        }
      });
    } else {
      return;
    }
  }
}
