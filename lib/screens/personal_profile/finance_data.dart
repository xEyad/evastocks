import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/screens/personal_profile/risk_recognition.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

class FinanceData extends StatefulWidget {
  const FinanceData({super.key});

  @override
  State<FinanceData> createState() => _FinanceDataState();
}

class _FinanceDataState extends State<FinanceData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController socialStatus =
      TextEditingController();
  final TextEditingController familyMembers = TextEditingController();
  final TextEditingController annualIncome = TextEditingController();
  final TextEditingController totalWealth = TextEditingController();
  dynamic bank;

  late final Future _getFinanceData =
      Provider.of<ServiceProvider>(context, listen: false).getFinanceData();
  Map banks = {};
  Map socialStatusList = {};
  Map familyMemberList = {};
  Map totalWealthList = {};
  Map annualIncomeList = {};
  Map educationalLevelList = {};

 /* late List incomes = [
    AppLocalizations.of(context)!.lessThan100000,
    AppLocalizations.of(context)!.from100000To1000000,
    AppLocalizations.of(context)!.from1000000To10000000,
    AppLocalizations.of(context)!.higherThan100000,
  ];
*/
  @override
  void initState() {
    _getFinanceData.then((value) {
      print(value);
      setState(() {
        banks = value['data']['bankType'];
        socialStatusList = value['data']['socialStatus'];
        totalWealthList = value['data']['totalWealth'];
        annualIncomeList = value['data']['annualIncome'];
        educationalLevelList = value['data']['educationalLevel'];
        familyMemberList = value['data']['familyMembers'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
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
                      Image.asset('assets/icons/coin.png',
                          width: 25, color: selectedIconColor),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.financialInfo,
                        style: TextStyle(color: selectedIconColor),
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
              InputDecorator(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.socialStatus,
                  filled: true,
                  fillColor: const Color.fromRGBO(249, 249, 249, 1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                ),
                child: DropdownButton<dynamic>(
                  hint: Text(AppLocalizations.of(context)!.socialStatus),
                 value: socialStatus.text.isEmpty ? null :  socialStatus.text,
                  items: socialStatusList.keys
                      .map((item) => DropdownMenuItem(
                            value: item,
                            onTap: () {
                              setState(() {
                                socialStatus.text = item;
                              });
                            },
                            child: Text(socialStatusList[item]),
                          ))
                      .toList(),
                  onChanged: (val) {},
                  isDense: true,
                  isExpanded: true,
                  underline: SizedBox(),
                  itemHeight: 50,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
             InputDecorator(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.familyCount,
                  filled: true,
                  fillColor: const Color.fromRGBO(249, 249, 249, 1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                ),
                child: DropdownButton<dynamic>(
                  hint: Text(AppLocalizations.of(context)!.familyCount),
                  value: familyMembers.text.isEmpty ? null : familyMembers.text,
                  items: familyMemberList.keys
                      .map((item) => DropdownMenuItem(
                            child: Text(familyMemberList[item]),
                            value: item,
                            onTap: () {
                              setState(() {
                                familyMembers.text = item;
                              });
                            },
                          ))
                      .toList(),
                  onChanged: (val) {},
                  isDense: true,
                  isExpanded: true,
                  underline: SizedBox(),
                  itemHeight: 50,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              InputDecorator(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.annualIncome,
                  filled: true,
                  fillColor: const Color.fromRGBO(249, 249, 249, 1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                ),
                child: DropdownButton<dynamic>(
                  hint: Text(AppLocalizations.of(context)!.annualIncome),
                  value: annualIncome.text.isEmpty ? null : annualIncome.text,
                  items: annualIncomeList.keys
                      .map((item) => DropdownMenuItem(
                            child: Text(annualIncomeList[item], textDirection: TextDirection.ltr),
                            value: item,
                            onTap: () {
                              setState(() {
                                annualIncome.text = item;
                              });
                            },
                          ))
                      .toList(),
                  onChanged: (val) {},
                  isDense: true,
                  isExpanded: true,
                  underline: SizedBox(),
                  itemHeight: 50,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              InputDecorator(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.netSavings,
                  filled: true,
                  fillColor: const Color.fromRGBO(249, 249, 249, 1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                ),
                child: DropdownButton<dynamic>(
                  hint: Text(AppLocalizations.of(context)!.netSavings),
                  value: totalWealth.text.isEmpty ? null : totalWealth.text,
                  items: totalWealthList.keys
                      .map((item) => DropdownMenuItem(
                            child: Text(totalWealthList[item], textDirection: TextDirection.ltr),
                            value: item,
                            onTap: () {
                              setState(() {
                                totalWealth.text = item;
                              });
                            },
                          ))
                      .toList(),
                  onChanged: (val) {},
                  isDense: true,
                  isExpanded: true,
                  underline: SizedBox(),
                  itemHeight: 50,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.yourBank,
                  filled: true,
                  fillColor: const Color.fromRGBO(249, 249, 249, 1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(242, 242, 242, 1))),
                ),
                child: DropdownButton<dynamic>(
                  hint: Text(AppLocalizations.of(context)!.yourBank),
                  value: bank.toString().isEmpty ? null : bank,
                  items: banks.keys
                      .map((item) => DropdownMenuItem(
                            child: Text(banks[item]),
                            value: item,
                            onTap: () {
                              setState(() {
                                bank = item;
                              });
                            },
                          ))
                      .toList(),
                  onChanged: (val) {},
                  isDense: true,
                  isExpanded: true,
                  underline: SizedBox(),
                  itemHeight: 50,
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              CustomButton(
                title: AppLocalizations.of(context)!.next,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (familyMembers.text.isNotEmpty &&
                        annualIncome.text.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RiskRecognition( socialStatus: socialStatus.text,
                            familyMembers: familyMembers.text,
                            annualIncome: annualIncome.text,
                            totalWealth: totalWealth.text,
                            bankType: bank.toString()),
                      ));
                    } else {
                      showMessage(
                          ctx: context,
                          message: AppLocalizations.of(context)!.enterAllFields,
                          title: AppLocalizations.of(context)!.clarification);
                    }
                  } else {
                    return;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
