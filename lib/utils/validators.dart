import 'package:flutter/material.dart';



  String? phoneNumberValidator(String? val) {
    if (val!.isEmpty) {
      return 'أدخل رقم الهاتف';
    } else if (!isNumeric(val)) {
      return 'الرقم غير صحيح';
    } else {
      return null;
    }
  }

  String? passwordValidator(String? val) {
    if (val!.isEmpty) {
      return 'ادخل كلمة المرور';
    } else {
      return null;
    }
  }

  String? emptyFieldValidator(String? val) {
    if (val!.isEmpty) {
      return 'لا يمكن ترك حقل فارغ';
    } else {
      return null;
    }
  }

  String? fullNameValidator(String? val) {
    if (val!.isEmpty) {
      return 'لا يمكن ترك حقل فارغ';
    } else {
      return null;
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

