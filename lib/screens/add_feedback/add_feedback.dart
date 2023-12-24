import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosooh/components/custom_button.dart';
import 'package:nosooh/components/image_picker_dialog.dart';
import 'package:nosooh/screens/add_feedback/preview_feedback.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:nosooh/utils/validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFeedback extends StatefulWidget {
  const AddFeedback({super.key});

  @override
  State<AddFeedback> createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _targetPriceFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _stopLossFormKey = GlobalKey<FormFieldState>();


  dynamic selectedStock;
  final TextEditingController recommendationDate = TextEditingController();
  late final TextEditingController recommendationType =
      TextEditingController(text:AppLocalizations.of(context)!.buy);
  final TextEditingController recommendationStrategy = TextEditingController();
  final TextEditingController targetPrice = TextEditingController();
  final TextEditingController stopLoss = TextEditingController();
  final TextEditingController recommendationTextAr = TextEditingController();
  File? image1;
  File? image2;

  TextEditingController priceAtRecommendation = TextEditingController();
  TextEditingController stockTodayPrice = TextEditingController();
  TextEditingController profitPercentage = TextEditingController();
  TextEditingController recommendationDuration = TextEditingController();
  TextEditingController changeLossPercentage = TextEditingController();
  TextEditingController recommendationStatus = TextEditingController();

  List stocks = [];

  PickedFile? pickedImage;
  PickedFile? pickedImage2;

  @override
  void initState() {
    Provider.of<ServiceProvider>(context, listen: false)
        .getStocks()
        .then((value) {
      setState(() {
        stocks = value['data'];
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
          AppLocalizations.of(context)!.addNewFeedback,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios,color: kMainColor),
        ) ,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                 Text(
                   AppLocalizations.of(context)!.dearUserYouCan,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kMainColor),
                ),
                const SizedBox(
                  height: 50,
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    hintText:  AppLocalizations.of(context)!.companyName,
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
                    hint: Text( AppLocalizations.of(context)!.companyName),
                    value: selectedStock,
                    items: stocks
                        .map((item) => DropdownMenuItem(
                              child: Text(item['stockName']),
                              value: item,
                              onTap: () {
                                setState(() {
                                  selectedStock = item;
                                  priceAtRecommendation.text =
                                      item['stockPrice'].toString();

                                });

                                setState(() {
                                  targetPrice.clear();
                                  recommendationDuration.clear();
                                  profitPercentage.clear();
                                  stopLoss.clear();
                                  changeLossPercentage.clear();
                                  recommendationStrategy.clear();
                                  recommendationTextAr.clear();
                                });
                              },
                            ))
                        .toList(),
                    onChanged: (val) {},
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: emptyFieldValidator,
                  onChanged: (value) {
                    setState(() {
                      _formKey.currentState!.validate();
                    });
                  },
                  controller: priceAtRecommendation,
                  enabled: false,
                  decoration: InputDecoration(
                      label: Text(  AppLocalizations.of(context)!.currentPrice),
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
                InputDecorator(
                  decoration: InputDecoration(
                    fillColor: const Color.fromRGBO(249, 249, 249, 1),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                    hint: Text( AppLocalizations.of(context)!.operation,
                        style:
                        TextStyle(fontSize: 14, color: Colors.black45)),
                    value: recommendationType.text,
                    items: [
                      AppLocalizations.of(context)!.sell,
                      AppLocalizations.of(context)!.buy,
                    ]
                        .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option.toString()),
                      onTap: () {
                        setState(() {
                          recommendationType.text = option;
                          targetPrice.clear();
                          recommendationDuration.clear();
                          profitPercentage.clear();
                          stopLoss.clear();
                          changeLossPercentage.clear();
                          recommendationStrategy.clear();
                          recommendationTextAr.clear();
                        });
                      },
                    ))
                        .toList(),
                    onChanged: (value) {},
                    isDense: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                    itemHeight: 50,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onTap: () {
                    if(selectedStock == null){
                      showMessage(ctx: context, message: AppLocalizations.of(context)!.selectCompanyFirst, title: AppLocalizations.of(context)!.clarification);
                    }
                  },
                  key: _targetPriceFormKey,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                  validator: (value) {
                    final numericRegex =
                    RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

                    if(value!.isEmpty){
                      return AppLocalizations.of(context)!.fieldIsEmptyValidation;
                    }else if(!numericRegex.hasMatch(value)){
                      return AppLocalizations.of(context)!.enterTheFieldCorrectly;

                    }else if(recommendationType.text == AppLocalizations.of(context)!.sell && double.parse(value) > double.parse(priceAtRecommendation.text)){
                      return AppLocalizations.of(context)!.targetPriceIsHigherCurrentPrice;
                    }else if(recommendationType.text == AppLocalizations.of(context)!.buy && double.parse(value) < double.parse(priceAtRecommendation.text)){
                      return AppLocalizations.of(context)!.targetPriceIsLessThanCurrentPrice;
                    }
                  },
                  onChanged: (value) {
                    _targetPriceFormKey.currentState!.validate();

                    setState(() {
                      recommendationDuration.clear();
                      profitPercentage.clear();
                      stopLoss.clear();
                      changeLossPercentage.clear();
                      recommendationStrategy.clear();
                      recommendationTextAr.clear();
                    });
                  },
                  controller: targetPrice,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.targetPrice),
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
                  key: _stopLossFormKey,
                  controller: stopLoss,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                  validator: (value) {
                    final numericRegex =
                    RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

                    if(value!.isEmpty){
                      return AppLocalizations.of(context)!.fieldIsEmptyValidation;
                    }else if(!numericRegex.hasMatch(value)){
                      return AppLocalizations.of(context)!.enterTheFieldCorrectly;

                    }else if(recommendationType.text == AppLocalizations.of(context)!.sell && double.parse(value) < double.parse(priceAtRecommendation.text)){
                      return AppLocalizations.of(context)!.stopLossIsLessThanCurrentPrice;
                    }
                    else if(recommendationType.text == AppLocalizations.of(context)!.buy && double.parse(value) > double.parse(priceAtRecommendation.text)){
                      return AppLocalizations.of(context)!.stopLossIsHigherThanCurrentPrice;
                    }
                  },
                  onChanged: (value) {
                    _stopLossFormKey.currentState!.validate();

                    setState(() {
                      recommendationDuration.clear();
                      profitPercentage.clear();
                      changeLossPercentage.clear();
                      recommendationStrategy.clear();
                      recommendationTextAr.clear();
                    });
                  },
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.stopLoss),
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
                  validator: emptyFieldValidator,
                  readOnly: true,
                  controller: recommendationDuration,
                  onTap: () {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                        DateTime.now().add(const Duration(days: 90)))
                        .then((value) {
                      setState(() {
                        recommendationDuration.text =
                            value.toString().substring(0, 10);
                      });

                     if(selectedStock != null){
                       if(stopLoss.text.isNotEmpty && targetPrice.text.isNotEmpty){

                         print('PERFORMEQUATIONS');
                        calcEquationForChangeLoss();
                         calcEquationForProfitChange();
                         identifyRecommendationStrategy();
                       }else{
                         showMessage(ctx: context, message: AppLocalizations.of(context)!.enterTheTargetPriceAndStopLoss, title: AppLocalizations.of(context)!.clarification);
                       }
                     }else{
                       showMessage(ctx: context, message: AppLocalizations.of(context)!.selectCompanyFirst, title: AppLocalizations.of(context)!.clarification);

                     }
                    });
                  },
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.duration),
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
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down_outlined,
                        color: kSecondColor,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onTap: () {
                    if(recommendationDuration.text.isEmpty){
                      showMessage(ctx: context, message: AppLocalizations.of(context)!.enterDuration, title: AppLocalizations.of(context)!.clarification);
                    }
                  },
                  validator: emptyFieldValidator,

                  controller: profitPercentage,
                  enabled: false,
                  decoration: InputDecoration(
                      label:  Text(AppLocalizations.of(context)!.profitChange),
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
                  onTap: () {
                    if(recommendationDuration.text.isEmpty){
                      showMessage(ctx: context, message: AppLocalizations.of(context)!.enterDuration, title: AppLocalizations.of(context)!.clarification);
                    }
                  },
                  validator: emptyFieldValidator, // Only numbers can be entered
                  controller: changeLossPercentage,
                  enabled: false,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.changeLossPercentage),
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
                  validator: emptyFieldValidator,
                  controller: recommendationStrategy,
                  onTap: () {
                    if(recommendationDuration.text.isEmpty){
                      showMessage(ctx: context, message: AppLocalizations.of(context)!.enterDuration, title: AppLocalizations.of(context)!.clarification);
                    }
                  },
                  enabled: false,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.recommendationType),

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
                ),


                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 5,
                  controller: recommendationTextAr,
                  validator: (value) {
                    
                  },
                  onChanged: (value) {

                  },
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.whatsYourRecommendation),

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
                TextField(
                  onTap: () async{
                    pickedImage = await showImagePickerDialog(context);
                    setState(() {

                    });
                  },
                  controller: TextEditingController(text: pickedImage!= null ? AppLocalizations.of(context)!.imageAttached : ''),
                  readOnly: true,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.attachImage),
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
                      suffixIcon: pickedImage != null ? IconButton(onPressed: (){
                        setState(() {
                          pickedImage = null;
                        });
                      }, icon: Icon(Icons.close,color: kMainColor,) ): Icon(
                        Icons.attachment,
                        color: kSecondColor,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                if(pickedImage!= null)
                  Image.file(File(pickedImage!.path)),
                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 20,
                ),
                if(pickedImage != null)
                TextField(
                  onTap: () async{
                    pickedImage2 = await showImagePickerDialog(context);
                    setState(() {

                    });
                  },
                  controller: TextEditingController(text: pickedImage2!= null ? AppLocalizations.of(context)!.imageAttached : ''),
                  readOnly: true,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.attachAnotherImage),
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
                      suffixIcon: pickedImage2 != null ? IconButton(onPressed: (){
                        setState(() {
                          pickedImage2 = null;
                        });
                      }, icon: Icon(Icons.close,color: kMainColor,) ): Icon(
                        Icons.attachment,
                        color: kSecondColor,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                if(pickedImage2!= null)
                  Image.file(File(pickedImage2!.path)),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  title: AppLocalizations.of(context)!.next,
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      if(selectedStock != null){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PreviewFeedback(recommendation: {
                            'stock': selectedStock,
                            'recommendation_date':
                            DateTime.now().toString().substring(0, 10),
                            'recommendation_type': recommendationType.text,
                            'recommendation_strategy': recommendationStrategy.text,
                            'target_price': targetPrice.text,
                            'stop_loss': stopLoss.text,
                            'recommendation_text_ar': recommendationTextAr.text,
                            'image1': pickedImage != null ? pickedImage!.path : null,
                            'image2': pickedImage2!= null ? pickedImage2!.path : null,
                            'priceAtRecommendation': priceAtRecommendation.text,
                            'stockTodayPrice': priceAtRecommendation.text,
                            'recommendationStrategy': recommendationStrategy.text,
                            'profitPercentage': profitPercentage.text,
                            'recommendationDuration': recommendationDuration.text,
                            'stopLoss': stopLoss.text,
                            'changeLossPercentage': changeLossPercentage.text,
                            'recommendationStatus': recommendationStatus.text,
                          }),
                        ));
                      }else{
                        showMessage(ctx: context, message: AppLocalizations.of(context)!.enterAllFields, title: AppLocalizations.of(context)!.wrong);
                      }
                    }else{
                      return;
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  identifyRecommendationStrategy(){
    if(DateTime.parse(recommendationDuration.text)
        .difference(DateTime.now())
        .inDays >
        6){
      setState(() {
        recommendationStrategy.text = AppLocalizations.of(context)!.investment;
      });
    }else{
      recommendationStrategy.text = AppLocalizations.of(context)!.dayTrading;
    }
  }

  calcEquationForProfitChange() {
    final double profitChangeResult = (((double.parse(targetPrice.text) -
                    double.parse(priceAtRecommendation.text)) /
                double.parse(priceAtRecommendation.text)) *
            100)
        .roundToDouble();

    //Buy
    if (recommendationType.text == AppLocalizations.of(context)!.buy) {
      if (DateTime.parse(recommendationDuration.text)
              .difference(DateTime.now())
              .inDays <
          7) {
        if (profitChangeResult < 1) {
          //Error
         // profitPercentage.text = profitChangeResult.toString();
        showMessage(ctx: context, message: AppLocalizations.of(context)!.profitChangeCalcWrong, title: AppLocalizations.of(context)!.wrong);
        } else {
          profitPercentage.text = profitChangeResult.toString();
        }
      } else if (DateTime.parse(recommendationDuration.text)
              .difference(DateTime.now())
              .inDays >
          6) {

        if (profitChangeResult < 3) {
          //Error
          //profitPercentage.text = profitChangeResult.toString();
          showMessage(ctx: context, message: AppLocalizations.of(context)!.profitChangeCalcWrong, title: AppLocalizations.of(context)!.wrong);

        } else {
          profitPercentage.text = profitChangeResult.toString();
        }
      }
    } else {
      //Sell
      if (DateTime.parse(recommendationDuration.text)
          .difference(DateTime.now())
          .inDays <
          7) {
        if (profitChangeResult > -1) {
          //Error
          //profitPercentage.text = profitChangeResult.toString();
          showMessage(ctx: context, message: AppLocalizations.of(context)!.profitChangeCalcWrong, title: AppLocalizations.of(context)!.wrong);

        } else {
          profitPercentage.text = profitChangeResult.toString();
        }
      } else if (DateTime.parse(recommendationDuration.text)
          .difference(DateTime.now())
          .inDays >
          6) {

        if (profitChangeResult > -3) {
          //Error
          //profitPercentage.text = profitChangeResult.toString();
          showMessage(ctx: context, message:AppLocalizations.of(context)!.profitChangeCalcWrong, title: AppLocalizations.of(context)!.wrong);

        } else {
          profitPercentage.text = profitChangeResult.toString();
        }
      }
    }

    setState(() {});
    print(profitChangeResult);
  }

  calcEquationForChangeLoss(){
    final double changeLossFloat = (((double.parse(stopLoss.text) -
        double.parse(priceAtRecommendation.text)) /
        double.parse(priceAtRecommendation.text)) *
        100)
        .roundToDouble();


    changeLossPercentage.text = changeLossFloat.toString();
    setState(() {});

    print(changeLossFloat);
  }
}
