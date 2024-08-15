import 'dart:async';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:url_launcher/url_launcher.dart';

import 'navigation_services.dart';

/// A notification action which triggers a App navigation event
String navigationActionId = 'id_3';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_//print
  //print('notification(${notificationResponse.id}) action tapped: '
  // '${notificationResponse.actionId} with'
  // ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_//print
    //.print(
    //  'notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  static init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    if (initScheduled) {
      tz.initializeTimeZones();
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    }

    await _notifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
    );
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails("channel id", "channel name",
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          // sound: RawResourceAndroidNotificationSound("azan"),
          channelDescription: "Channel description"),
      iOS: DarwinNotificationDetails(sound: ""),
    );
  }

  // static Future showNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payload,
  // }) async =>
  //     _notifications.show(
  //       id,
  //       title,
  //       body,
  //       _notificationDetails(),
  //       payload: payload,
  //     );

  static Future<void> showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {
    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        _notificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static void cancel(int id) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();

  static void configure() async {
    try {
      await Firebase.initializeApp();
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }


    // Set the background messaging handler early on, as a named top-level function
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getToken().then((value) {
      if (value != null && value.isNotEmpty) {
        CommonProperties.fcmToken = value;

        Future.delayed(const Duration(seconds: 15), () {
          CommonFunctions.updateNotificationSettings(value);
        });
      }
    });

    Future<void> launchURL(String strUrl) async {
      final Uri url = Uri.parse(strUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    void handleMessage(RemoteMessage message) {
      print("open notication clciked");
      if (message.data.containsKey('url')) {
        final url = message.data['url'];
        launchURL(url);
        return;
      }
      Future.delayed(const Duration(seconds: 2), () {
        NavigationService.pushNamed(routeName: RouteName.notificationsListScreen);
      });

    }
    // FirebaseMessaging.instance.subscribeToTopic("all").then((value) {});
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
       // Future.delayed(const Duration(seconds: 2), () {
          handleMessage(message);
       // });
      }
    });

    // showNotification(Map<String, dynamic> msg) {
    //   var androidNotification = AndroidNotificationDetails(
    //     'channelId',
    //     'channelName',
    //   );
    //   DarwinNotificationDetails iOSPlatformChannelSpecifics =
    //       DarwinNotificationDetails();
    //   var notificationDetails = NotificationDetails(
    //       android: androidNotification, iOS: iOSPlatformChannelSpecifics);
    //   _notifications.show(0, msg['notification']['title'],
    //       msg['notification']['body'], notificationDetails);
    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                CommonFunctions.generateUUID(),
                "Notification",
                channelDescription: "Notification",

                playSound: true,


                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'mipmap/ic_launcher',
              ),
            ));
      }
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        handleMessage(message);
    });
  }
}
