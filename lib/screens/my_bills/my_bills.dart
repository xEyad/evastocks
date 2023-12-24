import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:nosooh/components/bill_container.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../utils/size_utility.dart';

class MyBills extends StatefulWidget {
  const MyBills({super.key});

  @override
  State<MyBills> createState() => _MyBillsState();
}

class _MyBillsState extends State<MyBills> {
  late final _getMyBills =
      Provider.of<ServiceProvider>(context).getMySubscriptions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.myBills,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: kMainColor),
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: _getMyBills,
        builder: (context, snapshot) {
          if (snapshot.connectionState !=ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: (snapshot.data['data'] == null ||
                      (snapshot.data['data'] as List).isEmpty)
                  ? buildEmptyWidget(context)
                  : SingleChildScrollView(
                      child: Column(
                          children: snapshot.data['data']
                              .map<Widget>((bill) => BillContainer(
                                    bill: bill,
                                  ))
                              .toList()),
                    ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Center buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/videos/08.json',
              width: SizeUtility(context).width * 75 / 100, fit: BoxFit.cover),
          const SizedBox(
            height: 30,
          ),
          Text(
            AppLocalizations.of(context)!.emptyBills,
            style: const TextStyle(
                color: kMainColor, fontWeight: FontWeight.w600, fontSize: 25),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
