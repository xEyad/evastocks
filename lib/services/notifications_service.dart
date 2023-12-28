import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:nosooh/services/navigation_service.dart';
import 'package:provider/provider.dart';


// This is with Firebase_messaging & in_app_notification packages
/*
  in_app_notification: ^1.1.2
  flutter_ringtone_player: ^3.2.0
  firebase_messaging: ^14.6.4

    -- Add to info.plist
  FirebaseMessagingAutoInitEnabled = NO

    -- Add to AndroidManifest.xml
    <meta-data
      android:name="firebase_messaging_auto_init_enabled"
      android:value="false" />
  <meta-data
      android:name="firebase_analytics_collection_enabled"
      android:value="false" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />

     -- and inside the activity
       <intent-filter>
                <action android:name="FLUTTER_NOTIFICATION_CLICK" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>

      */

class PushNotificationService with ChangeNotifier {
  initPushNotification() async {
    await requestNotificationsPermission();
    _initOnBackgroundMessageListener();
    _initOnMessageListener();
    _initFirebaseOnMessageOpenedAppListener();
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN $token");
  }

  setUpInteractedMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      return _handleMessage(initialMessage);
    } else {
      return null;
    }
  }

  requestNotificationsPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  _initOnMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      InAppNotification.show(
        duration: Duration(seconds: 5),
        child: Container(
          width: 200,
          decoration: BoxDecoration(color: Colors.blue,),
          padding: EdgeInsets.all(20),          
          child:Column(
            children: [
              Text(message.notification?.title??"",style: TextStyle(color: Colors.white,fontSize: 20)),
              Text(message.notification?.body??"",style: TextStyle(color: Colors.white,fontSize: 40)),
            ],
          )), // put your widget to be shown here
        context: NavigationService.context!,
        onTap: () {
          _handleMessage(message);
        },
      );
    });
  }

  _initFirebaseOnMessageOpenedAppListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _handleMessage(message);
      }
    });
  }

  _initOnBackgroundMessageListener() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }


}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _handleMessage(message);
}

void _handleMessage(RemoteMessage message) {
  // handle when clicking on notifications here
}
