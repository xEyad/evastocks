import 'package:flutter/material.dart';
import 'package:nosooh/utils/size_utility.dart';

class GenericAppBar extends StatelessWidget {
  final String title;
  const GenericAppBar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          Row(
            children: [
              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage('assets/icons/help.png')))
            ],
          ),
        ],
      ),
    );
  }
}
