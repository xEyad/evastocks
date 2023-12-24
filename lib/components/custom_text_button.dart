import 'package:flutter/material.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Color textColor;
  const CustomTextButton({super.key,required this.title,required this.onPressed,this.textColor = kMainColor,});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(title,style: TextStyle(color: textColor,fontWeight: FontWeight.w400,fontSize: 22),),

    style: ButtonStyle(
      fixedSize: MaterialStateProperty.all(Size(SizeUtility(context).width,50)),
    ),);
  }
}
