import 'package:flutter/material.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/functions.dart';
import 'package:provider/provider.dart';

import '../../components/faq_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  late final Future _getFAQ = Provider.of<ServiceProvider>(context).getFAQ();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          AppLocalizations.of(context)!.faq??'',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: kMainColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: _getFAQ,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data['data'].map<Widget>((faq) {
                        return FAQContainer(
                          qs: faq,

                        );
                      }).toList(),
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(
                height: 50,
              ),
              Text(
               AppLocalizations.of(context)!.contactUs,
                style: TextStyle(
                    color: kSecondColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => whatsapp(context),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Row(children: [
                      ImageIcon(AssetImage('assets/icons/whatsapp_2.png'),
                          color: kMainColor2, size: 25),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'عبر واتساب',
                        style: TextStyle(
                            color: kMainColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
