import 'package:flutter/material.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/constants.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubsCancelTerms extends StatefulWidget {
  const SubsCancelTerms({super.key});

  @override
  State<SubsCancelTerms> createState() => _SubsCancelTermsState();
}

class _SubsCancelTermsState extends State<SubsCancelTerms> {
  late final Future _getContent = Provider.of<ServiceProvider>(context).getContent(key: subscriptionCancelKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.subCancelTerms,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: kMainColor),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios,color: kMainColor),
        ) ,
      ),
      body:  Column(
        children: [
          SizedBox(height: 20,),

          SizedBox(
            width: SizeUtility(context).width,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child:FutureBuilder(
                  future: _getContent,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data['data'].isNotEmpty){
                        return Text(snapshot.data['data'].first['value'] ,style: const TextStyle(color: Color.fromRGBO(81, 81, 81, 1,)),);
                      }
                      return const Text('لم تتضم إضافة البيانات من الخادم');
                    }
                    return const SizedBox();
                  },
                )
            ),
          ),
        ],
      ),
    );
  }
}
