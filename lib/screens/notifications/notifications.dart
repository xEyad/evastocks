import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/components/help_nosooh.dart';
import 'package:nosooh/services/service_provider.dart';
import 'package:nosooh/utils/colors.dart';
import 'package:nosooh/utils/size_utility.dart';
import 'package:provider/provider.dart';

import '../../models/notifications_mode/notifications_model.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late final _getNotifications =
      Provider.of<ServiceProvider>(context).getNotifications2();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: kMainColor),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                showHelpNosoohBottomSheet(context);
              },
              child:
                  Image.asset('assets/icons/help.png', height: 40, width: 40)),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Notifications(),
                ));
              },
              child: Image.asset('assets/icons/notification.png',
                  height: 26, width: 26)),
          const SizedBox(
            width: 20,
          )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: kMainColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _getNotifications,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data!['data'] != null){
                NotificationData? notificationsModel =
                NotificationData.fromJson(snapshot.data?['data']);
                print(notificationsModel.read.length);
                return SingleChildScrollView(
                  child: Column(
                    children: [

                      const NotificationDayContainer(
                        day: 'جديد',
                      ),
                      if(notificationsModel.unread.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('لا يوجد اشعارات جديدة'),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return NotificationTileContainer(
                              notification: notificationsModel.unread[index]);
                        },
                        itemCount: notificationsModel.unread.length,
                      ),
                      const NotificationDayContainer(
                        day: 'الأقدم',
                      ),
                      if(notificationsModel.read.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('لا يوجد اشعارات جديدة'),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return NotificationTileContainer(
                              notification: notificationsModel.read[index]);
                        },
                        itemCount: notificationsModel.read.length,
                      ),
                    ],
                  ),
                );
              }else{
                return    const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('لا يوجد اشعارات جديدة'),
                  ),
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class NotificationTileContainer extends StatelessWidget {
  NotificationItem notification;
  NotificationTileContainer({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          children: [
            Image.asset(notification.type == 'ratings_added'? 'assets/icons/like_filled.png' : notification.type == 'ratings_updated'? 'assets/icons/rating_updated.png' : notification.type == 'ratings_removed'? 'assets/icons/rating_removed.png': 'assets/icons/customer_sat.png',
                height: 40, color: kMainColor2),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${notification.createdAt}',
                  style: TextStyle(color: unSelectedNavIconColor, fontSize: 14),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                    width: SizeUtility(context).width * 75 / 100,
                    child: Text(
                      '${notification.message}',
                      style: const TextStyle(
                          color: kMainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NotificationDayContainer extends StatelessWidget {
  final String day;
  const NotificationDayContainer({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: SizeUtility(context).width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(234, 234, 234, 1),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        "${day}",
        style: const TextStyle(
            color: Color.fromRGBO(81, 81, 81, 1),
            fontWeight: FontWeight.w500,
            fontSize: 17),
      ),
    );
  }
}
