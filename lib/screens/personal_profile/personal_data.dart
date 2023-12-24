import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/packages/hijri_picker/hijri_calender.dart';
import 'package:nosooh/packages/hijri_picker/hijri_picker.dart';
import 'package:nosooh/screens/personal_profile/complete_your_request.dart';
import 'package:nosooh/screens/personal_profile/finance_data.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

class PersonalData extends StatefulWidget {
  const PersonalData({super.key});

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _identifyNoController = TextEditingController();

  GlobalKey<FormFieldState> idKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> dobKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/personal_data.png',
                        width: 25,
                        color: selectedIconColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.personalInfo,
                        style: const TextStyle(color: selectedIconColor),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: DottedLine(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      lineLength: SizeUtility(context).width * 8 / 100,
                      lineThickness: .8,
                      dashLength: 1.0,
                      dashColor: Colors.transparent,
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: const Color.fromRGBO(111, 107, 178, 1),
                      dashGapRadius: 0.0,
                    ),
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/coin.png',
                        width: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.financialInfo,
                        style:
                            TextStyle(color: Color.fromRGBO(152, 152, 152, 1)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: DottedLine(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      lineLength: SizeUtility(context).width * 8 / 100,
                      lineThickness: .8,
                      dashLength: 1.0,
                      dashColor: Colors.transparent,
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: const Color.fromRGBO(111, 107, 178, 1),
                      dashGapRadius: 0.0,
                    ),
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/warning.png',
                        width: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.riskManagement,
                        style:
                            TextStyle(color: Color.fromRGBO(152, 152, 152, 1)),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context)!.yalla,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: kMainColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.weNeedSomeInfo,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: kSecondColor),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                key: idKey,
                controller: _identifyNoController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                maxLength: 10,
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!.enterYourIdNumber;
                  }
                  return null;
                },
                onChanged: (value) {
                  idKey.currentState!.validate();
                },
                decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color:labelFormFieldColor,
                    ),

                    hintText: AppLocalizations.of(context)!.yourIdNumber,
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
                height: 20,
              ),
              TextFormField(
                key: dobKey,
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!.enterYourDOB;
                  }
                  return null;
                },
                controller: _dobController,
                readOnly: true,
                onTap: () async {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime(1960),
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now())
                      .then((value) {
                    setState(() {
                      _dobController.text = intl.DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(value.toString()));
                      print(_dobController.text);
                      dobKey.currentState!.validate();
                    });
                  });
                 /* if (_identifyNoController.text.startsWith('1')) {
                    final HijriCalendar? picked = await showHijriDatePicker(
                      locale: const Locale('en'),
                      context: context,
                      initialDate: HijriCalendar.now(),
                      lastDate: HijriCalendar.now(),
                      firstDate: HijriCalendar()
                        ..hYear = 1370
                        ..hMonth = 12
                        ..hDay = 25,
                      initialDatePickerMode: DatePickerMode.day,
                    );
                    if (picked != null) {
                      setState(() {
                        _dobController.text = picked.toFormat('dd-mm-yyyy');
                      });
                    }
                  } else {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime(1960),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now())
                        .then((value) {
                      setState(() {
                        _dobController.text = intl.DateFormat('dd-mm-yyyy')
                            .format(DateTime.parse(value.toString()));
                        print(_dobController.text);
                        dobKey.currentState!.validate();
                      });
                    });
                  }*/
                },
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color:labelFormFieldColor,
                    ),

                    hintText: AppLocalizations.of(context)!.yourDOB,
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
                height: 40,
              ),
              CustomButton(
                title: AppLocalizations.of(context)!.next,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await Provider.of<ServiceProvider>(context, listen: false)
                        .updateYakeenAPI(
                            dob: _dobController.text,
                            identityNo: _identifyNoController.text)
                        .then((value) {
                      if (value['status']) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FinanceData(),
                        ));
                      } else {
                        showMessage(
                            ctx: context,
                            message: value['message'],
                            title: AppLocalizations.of(context)!.wrong);
                      }
                    });
                  } else {
                    return;
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Text(
                  AppLocalizations.of(context)!.youAreNotSaudi,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: kSecondColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompleteYourRequest(),));
                    },
                    child:  Text(
                      AppLocalizations.of(context)!.completeYourRequest,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: selectedIconColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
