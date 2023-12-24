import 'package:flutter/material.dart';

import 'colors.dart';

const String myFontBold = 'TajawalBold';
const String myFontMedium = 'TajawalMedium';
const String myFontRegular = 'TajawalRegular';

abstract class Styles {
  static TextStyle textStyle10Medium = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: myFontMedium,
  );
  static TextStyle textStyle12Medium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: formFieldTextErrorColor,
    //fontFamily: myFontMedium,
  );
  static TextStyle textStyle11Bold = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: customBlue,
    fontFamily: myFontBold,
  );
  static TextStyle textStyle12Regular = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: notificationsTimeColor,
    fontFamily: myFontRegular,
  );
  static TextStyle textStyle13Medium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: suvaGreyColor,
    fontFamily: myFontMedium,
  );
  static TextStyle textStyle13Bold = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: myColor,
    //fontFamily: myFontBold,
  );
  static TextStyle textStyle14Medium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: suvaGreyColor,
//    //fontFamily: myFontMedium,
  );
  static TextStyle textStyle14Bold = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    //fontFamily: myFontBold,
  );
  static TextStyle textStyle15Medium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: myColor,
//    //fontFamily: myFontMedium,
    decoration: TextDecoration.none,
  );
  static TextStyle textStyle15Bold = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: myColor,
    //fontFamily: myFontBold,
    decoration: TextDecoration.none,
  );
  static TextStyle textStyle16Medium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: suvaGreyColor,
//    //fontFamily: myFontMedium,
  );
  static TextStyle textStyle16Bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: myColor,
    //fontFamily: myFontBold,
  );
  static TextStyle textStyle17Medium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: myColor,
//    //fontFamily: myFontMedium,
  );
  static TextStyle textStyle18Medium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: suvaGreyColor,
//    //fontFamily: myFontMedium,
  );
  static TextStyle textStyle19Bold = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    color: myColor,
    //fontFamily: myFontBold,
  );
  static TextStyle textStyle20Medium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: customOrangeColor,
//    //fontFamily: myFontMedium,
  );
  static TextStyle textStyle22Medium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: formFieldTextFillColor,
//    //fontFamily: myFontMedium,
  );
  static TextStyle textStyle22Bold = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: myColor,
    //fontFamily: myFontBold,
  );
  static TextStyle textStyle24Medium = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white,
//    //fontFamily: myFontMedium,
  );
  static TextStyle textStyle30Bold = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: myColor,
    //fontFamily: myFontBold,
  );
}
