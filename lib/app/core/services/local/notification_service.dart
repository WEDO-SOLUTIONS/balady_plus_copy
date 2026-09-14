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
import 'package:flutter_insider/flutter_insider.dart';
import 'navigation_services.dart';
import 'package:flutter/foundation.dart';

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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['source'] == 'Insider') {
    FlutterInsider.Instance.handleNotification(<String, dynamic>{"data": message.data});
  }
}

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

  static Future<void> init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    if (initScheduled) {
      tz.initializeTimeZones();
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    }

    await _notifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
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
      android: AndroidNotificationDetails(
        "channel id",
        "channel name",
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        // sound: RawResourceAndroidNotificationSound("azan"),
        channelDescription: "Channel description",
      ),
      iOS: DarwinNotificationDetails(sound: ""),
    );
  }

  static Future<void> showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        _notificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  static void cancel(int id) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();

  static Future<void> configure() async {
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
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    Future.delayed(const Duration(seconds: 15), () {
      FirebaseMessaging.instance.getToken().then((value) {
        debugPrint("FMC Token : $value");
        if (value != null && value.isNotEmpty) {
          CommonProperties.fcmToken = value;
          CommonFunctions.updateNotificationSettings(value);
        }
      });
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
      if (message.data.containsKey('url')) {
        return;
      }
      Future.delayed(const Duration(seconds: 2), () {
        // Open notifications List Screen  if user is login and have the idNo
        if (CommonProperties.userInfo?.idNo != null) {
          NavigationService.pushNamed(routeName: RouteName.notificationsListScreen);
        }
      });
    }

    // FirebaseMessaging.instance.subscribeToTopic("all").then((value) {});
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        // Future.delayed(const Duration(seconds: 2), () {
        handleMessage(message);
        // });
      }
    });

    // Register Background Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data['source'] == 'Insider') {
        FlutterInsider.Instance.handleNotification(<String, dynamic>{"data": message.data});
      } else {
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
                icon: 'mipmap/ic_launcher',
              ),
            ),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });
  }
}
