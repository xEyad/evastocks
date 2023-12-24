import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/screens/personal_profile/all_done.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

class RiskRecognition extends StatefulWidget {
  final String socialStatus;
  final String familyMembers;
  final String annualIncome;
  final String totalWealth;
  final String bankType;
  const RiskRecognition({super.key,required this.totalWealth, required this.familyMembers , required this.annualIncome, required this.socialStatus,required this.bankType});

  @override
  State<RiskRecognition> createState() => _RiskRecognitionState();
}

class _RiskRecognitionState extends State<RiskRecognition> {
  bool? _first;
  bool? _second;
  bool? _third;
  bool? _fourth;
  bool _fifth = true;

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
          icon: const Icon(Icons.arrow_back_ios, color: kMainColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Image.asset('assets/icons/personal_data.png',
                        width: 25, color: selectedIconColor),
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
                    Image.asset('assets/icons/warning.png',
                        width: 25, color: selectedIconColor),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.riskManagement,
                      style: const TextStyle(color: selectedIconColor),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              AppLocalizations.of(context)!.estipyan,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700, color: kMainColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)!.andThisIsForDistor,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: kSecondColor),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.firstQs,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: kMainColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _first = true;
                    });
                  },
                  child: Row(
                    children: [
                      _first != null
                          ? Visibility(
                              visible: _first!,
                              replacement: const Icon(
                                Icons.radio_button_unchecked,
                                color: kMainColor,
                              ),
                              child: const ImageIcon(
                                AssetImage('assets/icons/checked_radio.png'),
                                color: kMainColor2,
                              ),
                            )
                          : const Icon(
                              Icons.radio_button_unchecked,
                              color: kMainColor,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.yes,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _first = false;
                    });
                  },
                  child: Row(
                    children: [
                      _first != null
                          ? Visibility(
                              visible: !_first!,
                              replacement: const Icon(
                                Icons.radio_button_unchecked,
                                color: kMainColor,
                              ),
                              child: const ImageIcon(
                                AssetImage('assets/icons/checked_radio.png'),
                                color: kMainColor2,
                              ),
                            )
                          : const Icon(
                              Icons.radio_button_unchecked,
                              color: kMainColor,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.no,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.secondQs,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: kMainColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _second = true;
                    });
                  },
                  child: Row(
                    children: [
                      _second != null
                          ? Visibility(
                              visible: _second!,
                              replacement: const Icon(
                                Icons.radio_button_unchecked,
                                color: kMainColor,
                              ),
                              child: const ImageIcon(
                                AssetImage('assets/icons/checked_radio.png'),
                                color: kMainColor2,
                              ),
                            )
                          : const Icon(
                              Icons.radio_button_unchecked,
                              color: kMainColor,
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.yes,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _second = false;
                    });
                  },
                  child: Row(
                    children: [
                      _second != null
                          ? Visibility(
                              visible: !_second!,
                              replacement: const Icon(
                                Icons.radio_button_unchecked,
                                color: kMainColor,
                              ),
                              child: const ImageIcon(
                                AssetImage('assets/icons/checked_radio.png'),
                                color: kMainColor2,
                              ),
                            )
                          : const Icon(
                              Icons.radio_button_unchecked,
                              color: kMainColor,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.no,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.thirdQs,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: kMainColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _third = true;
                    });
                  },
                  child: Row(
                    children: [
                      _third != null
                          ? Visibility(
                              visible: _third!,
                              replacement: const Icon(
                                Icons.radio_button_unchecked,
                                color: kMainColor,
                              ),
                              child: const ImageIcon(
                                AssetImage('assets/icons/checked_radio.png'),
                                color: kMainColor2,
                              ),
                            )
                          : const Icon(
                              Icons.radio_button_unchecked,
                              color: kMainColor,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.yes,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _third = false;
                    });
                  },
                  child: Row(
                    children: [
                      _third != null
                          ? Visibility(
                              visible: !_third!,
                              replacement: const Icon(
                                Icons.radio_button_unchecked,
                                color: kMainColor,
                              ),
                              child: const ImageIcon(
                                AssetImage('assets/icons/checked_radio.png'),
                                color: kMainColor2,
                              ),
                            )
                          : const Icon(
                              Icons.radio_button_unchecked,
                              color: kMainColor,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.no,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.fourthQs,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: kMainColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _fourth = true;
                    });
                  },
                  child: Row(
                    children: [
                      _fourth != null
                          ? Visibility(
                              visible: _fourth!,
                              replacement: const Icon(
                                Icons.radio_button_unchecked,
                                color: kMainColor,
                              ),
                              child: const ImageIcon(
                                AssetImage('assets/icons/checked_radio.png'),
                                color: kMainColor2,
                              ),
                            )
                          : const Icon(
                              Icons.radio_button_unchecked,
                              color: kMainColor,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.yes,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _fourth = false;
                    });
                  },
                  child: Row(
                    children: [
                      _fourth != null
                          ? Visibility(
                              visible: !_fourth!,
                              replacement: const Icon(
                                Icons.radio_button_unchecked,
                                color: kMainColor,
                              ),
                              child: const ImageIcon(
                                AssetImage('assets/icons/checked_radio.png'),
                                color: kMainColor2,
                              ),
                            )
                          : const Icon(
                              Icons.radio_button_unchecked,
                              color: kMainColor,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.no,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kMainColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            CustomButton(
              title: AppLocalizations.of(context)!.next,
              onPressed: () async{
                if ((_first ?? false) &&
                    (_second ?? false) &&
                    (_third ?? false) &&
                    (_fourth ?? false)) {


                  await Provider.of<ServiceProvider>(context, listen: false)
                      .addKYC(
                      socialStatus: widget.socialStatus,
                      familyMembers: widget.familyMembers,
                      annualIncome: widget.annualIncome,
                      totalWealth: widget.totalWealth,
                      bankType: widget.bankType)
                      .then((value) {
                    if (value['status']) {

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AllDone(),
                      ));

                    } else {
                      showMessage(
                          ctx: context,
                          message: value['data'],
                          title: AppLocalizations.of(context)!.wrong);
                    }
                  });
                } else {
                  showMessage(
                      ctx: context,
                      message:
                          AppLocalizations.of(context)!.youHaveToReadAllDangers,
                      title: AppLocalizations.of(context)!.clarification);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
