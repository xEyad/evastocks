import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/screens/about_app/subs_cancel_terms.dart';
import 'package:nosooh/screens/about_app/terms_and_conditions.dart';
import 'package:nosooh/screens/payment/payment_view.dart';
import 'package:nosooh/screens/personal_profile/finance_data.dart';
import 'package:nosooh/screens/personal_profile/personal_data.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:provider/provider.dart';

class Payment extends StatefulWidget {
  final String? planId;
  final String? listName;
  const Payment({super.key, this.planId, this.listName});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late final _getPlans = Provider.of<ServiceProvider>(context, listen: false)
      .getPlans(planId: widget.planId!);

  String selectedPayment = 'mada';
  bool _isLoading = true;
  final TextEditingController _couponController = TextEditingController();

  dynamic list;
  String message = '';

  String? planId;
  double amount = 0;
  double discountPercentage = 0;
  double discountAmount = 0;
  double priceAfterDiscount = 0;
  double VATAmount = 0;
  double VATPercentage = 0;
  double total = 0;
  bool _isCouponError = false;
  String? validCoupon;
  @override
  void initState() {
    _getPlans.then((value) {
      setState(() {
        _isLoading = false;
        list = value['data']['data'];
        message = value['data']['msg'];
        if (value['data']['data'].isNotEmpty) {
          planId = value['data']['data']['planId'].toString();
          amount = double.parse(value['data']['data']['amount'].toString());
          discountPercentage = double.parse(
              value['data']['data']['discountPercentage'].toString());
          discountAmount =
              double.parse(value['data']['data']['discountAmount'].toString());
          priceAfterDiscount = double.parse(
              value['data']['data']['priceAfterDiscount'].toString());
          VATAmount =
              double.parse(value['data']['data']['VATAmount'].toString());
          VATPercentage =
              double.parse(value['data']['data']['VATPercentage'].toString());
          total = double.parse(value['data']['data']['total'].toString());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.payment,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios, color: kMainColor),
          ),
        ),
        body: _isLoading
            ? SizedBox()
            : list.isEmpty
                ? Center(
                    child: Text(message),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.subDetails,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: kMainColor),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                         Image.asset(

                                                'assets/icons/list_name.png',

                                            height: 30,width: 30),
                                        const SizedBox(width: 20),
                                        Text(
                                          widget.listName ?? '',
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: kMainColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/icons/calendar-new.png',
                                            height: 30,width: 30),
                                        const SizedBox(width: 20),
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .subDuration,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: kMainColor),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .oneMonth,
                                              style:  TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      49, 213, 200, 1)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          //hide coupon


                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: DottedBorder(
                              color: const Color.fromRGBO(0, 0, 0, .16),
                              dashPattern: [10, 10],
                              strokeWidth: 1.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: TextField(
                                  controller: _couponController,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .enterCoupon,
                                    filled: true,
                                    fillColor:
                                        const Color.fromRGBO(253, 253, 253, 1),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,

                                    suffixIcon: Container(
                                      width: 80,
                                      color: _isCouponError? Color.fromRGBO(231, 0, 0, 0.2) : null,
                                      child: IconButton(
                                          onPressed: () async {
                                            await Provider.of<ServiceProvider>(
                                                    context,
                                                    listen: false)
                                                .checkCoupon(
                                                    coupon:
                                                        _couponController.text,
                                                    planId: planId.toString())
                                                .then((value) {
                                              if (value['status'] == false){
                                                setState(() {
                                                  _isCouponError = true;
                                                });
                                                showMessage(
                                                    ctx: context,
                                                    message: value['message'],
                                                    title: 'توضيح');

                                                setState(() {
                                                  list = value['data']['data'];
                                                  message = value['data']['msg'];
                                                  planId = value['data']['data']['plan_id']
                                                      .toString();
                                                  amount = double.parse(
                                                      value['data']['data']['amount']
                                                          .toString());
                                                  discountPercentage =
                                                      double.parse(value['data']
                                                      ['data']
                                                      [
                                                      'discount_per']
                                                          .toString());
                                                  discountAmount = double.parse(
                                                      value['data']['data']
                                                      ['discount_amount']
                                                          .toString());
                                                  priceAfterDiscount =
                                                      double.parse(value['data']
                                                      ['data']
                                                      [
                                                      'price_after_discount']
                                                          .toString());
                                                  VATAmount = double.parse(
                                                      value['data']['data']
                                                      ['vat_amount']
                                                          .toString());
                                                  VATPercentage = double.parse(
                                                      value['data']['data']
                                                      ['vat_per']
                                                          .toString());
                                                  total = double.parse(
                                                      value['data']['data']
                                                      ['total']
                                                          .toString());
                                                });
                                              } else {
                                                setState(() {
                                                  _isCouponError = false;
                                                  validCoupon = _couponController.text;
                                                  list = value['data']['data'];
                                                  message = value['data']['msg'];
                                                  planId = value['data']['data']['plan_id']
                                                      .toString();
                                                  amount = double.parse(
                                                      value['data']['data']['amount']
                                                          .toString());
                                                  discountPercentage =
                                                      double.parse(value['data']
                                                              ['data']
                                                          [
                                                              'discount_per']
                                                          .toString());
                                                  discountAmount = double.parse(
                                                      value['data']['data']
                                                          ['discount_amount']
                                                          .toString());
                                                  priceAfterDiscount =
                                                      double.parse(value['data']
                                                              ['data']
                                                          [
                                                              'price_after_discount']
                                                          .toString());
                                                  VATAmount = double.parse(
                                                      value['data']['data']
                                                          ['vat_amount']
                                                          .toString());
                                                  VATPercentage = double.parse(
                                                      value['data']['data']
                                                          ['vat_per']
                                                          .toString());
                                                  total = double.parse(
                                                      value['data']['data']
                                                          ['total']
                                                          .toString());
                                                });
                                              }
                                            });
                                          },
                                          icon: Text(_isCouponError ?AppLocalizations.of(context)!
                                              .wrongCode:  AppLocalizations.of(context)!
                                              .apply,style: TextStyle(fontSize: 12,color: _isCouponError? HexColor('#E70000'): null),)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.dontHaveCode,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: kSecondColor),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              InkWell(
                                  onTap: () {
                                    whatsapp(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .contactWhatsApp,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(48, 92, 213, 1),
                                        decoration: TextDecoration.underline),
                                  )),
                            ],
                          ),


                          const SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.startDate,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            color: kSecondColor),
                                      ),
                                      Text(
                                        '${DateTime.now().toString().substring(0, 10)}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: kMainColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.endDate,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            color: kSecondColor),
                                      ),
                                      Text(
                                        '${DateTime.now().add(const Duration(days: 91)).toString().substring(0, 10)}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: kMainColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.total,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            color: kSecondColor),
                                      ),
                                      Text(
                                        '${amount} ${AppLocalizations.of(context)!.sr}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: kMainColor),
                                      ),
                                    ],
                                  ),
                                  //discount

                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.discount,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            color: kSecondColor),
                                      ),
                                      Text(
                                        '- ${discountAmount} ${AppLocalizations.of(context)!.sr}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: kMainColor),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.vat,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            color: kSecondColor),
                                      ),
                                      Text(
                                        '${VATAmount} ${AppLocalizations.of(context)!.sr}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: kMainColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.egmali,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: kMainColor),
                                      ),
                                      Text(
                                        '${total} ${AppLocalizations.of(context)!.sr}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: kMainColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            AppLocalizations.of(context)!.paymentGateway,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: kMainColor),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPayment = 'mada';
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset('assets/icons/mada.png',
                                            width: 50, fit: BoxFit.fitWidth),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.mada,
                                          style: const TextStyle(
                                              color: kMainColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Spacer(),
                                        if (selectedPayment == 'mada')
                                          const Icon(Icons.check,color: kMainColor2),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPayment = 'visa';
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/visa.png',
                                          width: 50,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.visa,
                                          style: const TextStyle(
                                              color: kMainColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Spacer(),
                                        if (selectedPayment == 'visa')
                                          const Icon(Icons.check,color: kMainColor2),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  if (Platform.isIOS) const Divider(),
                                  if (Platform.isIOS)
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  if (Platform.isIOS)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedPayment = 'apple';
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/logos/apple.jpg',
                                            width: 50,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .applePay,
                                            style: const TextStyle(
                                                color: kMainColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const Spacer(),
                                          if (selectedPayment == 'apple')
                                            const Icon(Icons.check,color: kMainColor2),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsAndConditions(),
                                ));
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .termsAndConditionsAndPrivacyPolicy,
                                style: const TextStyle(
                                    color: Color.fromRGBO(48, 92, 213, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SubsCancelTerms(),
                                ));
                              },
                              child: Text(
                                AppLocalizations.of(context)!.subCancelTerms,
                                style: const TextStyle(
                                    color: Color.fromRGBO(48, 92, 213, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomButton(
                            title: AppLocalizations.of(context)!.subNow,
                            onPressed: () async {
                              await Provider.of<ServiceProvider>(context,
                                      listen: false)
                                  .subscribe(
                                cardType: selectedPayment == 'apple'
                                    ? '3'
                                    : selectedPayment == 'mada'
                                        ? '1'
                                        : '2',
                                planId: planId.toString(),
                                coupon: validCoupon
                              )
                                  .then((val) {
                                if (val['data']['msg'] == 'Need Yakeen') {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const PersonalData(),
                                  ));
                                } else if (val['data']['msg'] == 'Need KYC') {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const FinanceData(),
                                  ));
                                } else {
                                  if (val['data']['msg']
                                      .toString()
                                      .contains('successfully')) {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => PaymentView(
                                          hyperLink: val['data']['data']
                                              ['hyperpay']),
                                    ));
                                  } else {
                                    showMessage(
                                      ctx: context,
                                      title: 'Something went wrong',
                                      message: val['data']['msg'],
                                    );
                                  }
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ));
  }
}
