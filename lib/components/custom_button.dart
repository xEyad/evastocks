import 'package:flutter/material.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Color backgroundColor;
  final double fontSize;
  final double? width;
  final double height;
  final double? borderRadius;
  const CustomButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.backgroundColor = kMainColor2,
      this.fontSize = 19,
      this.width,
      this.height = 60,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        )),
        backgroundColor: MaterialStateProperty.all(
            onPressed == null ? Colors.grey : backgroundColor),
        fixedSize: MaterialStateProperty.all(
            Size(width ?? SizeUtility(context).width, height)),
      ),
      child: Text(title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500)),
    );
  }
}
