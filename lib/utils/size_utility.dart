import 'package:flutter/material.dart';

class SizeUtility {
  BuildContext context;

  SizeUtility(this.context);

  double get width => MediaQuery.of(context).size.width;

  double get height => MediaQuery.of(context).size.height;
}
