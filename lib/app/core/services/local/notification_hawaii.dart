import 'dart:async';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';



import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'time_zones.dart';
import 'package:url_launcher/url_launcher.dart';
import 'navigation_services.dart';
import 'package:huawei_push/huawei_push.dart';
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

class HawaiiNotificationService {



  static final _notifications = FlutterLocalNotificationsPlugin();
  static final StreamController<String?> selectNotificationStream =
  StreamController<String?>.broadcast();

  static Future<void> init() async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    // The time-zone database is loaded lazily, right before the first scheduled notification (see [TimeZones]).

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
          priority: Priority.high,
          ticker: 'ticker',
          // sound: RawResourceAndroidNotificationSound("azan"),
          channelDescription: "Channel description"),
      iOS: DarwinNotificationDetails(sound: ""),
    );
  }


  static Future<void> showScheduledNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payload,
        required DateTime scheduledDate}) async {
    await TimeZones.ensureInitialized();
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


  Future<void> launchURL(String strUrl) async {
    final Uri url = Uri.parse(strUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void handleMessage(Map<String, dynamic> message) {

    if (message["extras"] != null && message["extras"].containsKey('url')==true) {
      String? url = message["extras"]['url'];
      if(url != null && url.isNotEmpty) {
        launchURL(url);
      }
      return;
    }

    /// Stop Open This For he Work when open Deep Link Need Test On Hawaii
    // if(CommonProperties.userInfo?.idNo != null) {
      // Future.delayed(const Duration(seconds: 2), () {
      //   NavigationService.pushNamed(
      //       routeName: RouteName.notificationsListScreen);
      // });
    // }

  }

   Future<void> configure() async {
    try {
      await Push.setAutoInitEnabled(true);

      Push.getTokenStream.listen(
        _onTokenEvent,
        onError: _onTokenError,
      );
      Push.onNotificationOpenedApp.listen(
        (eee)  {

          _onNotificationOpenedApp(eee);
          print("object");

        } ,
      );

      final dynamic initialNotification = await Push.getInitialNotification();
      _onNotificationOpenedApp(initialNotification);

      Push.onMessageReceivedStream.listen(
        _onMessageReceived,
        onError: _onMessageReceiveError,
      );
      bool backgroundMessageHandler = await Push
          .registerBackgroundMessageHandler(
        backgroundMessageCallback,
      );
    }
    catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }

  }
  void _onTokenEvent(String token) {

    if ( token.isNotEmpty) {
      CommonProperties.fcmToken = token;

      Future.delayed(const Duration(seconds: 15), () {
        CommonFunctions.updateNotificationSettings(token);
      });
    }


  }

  void _onTokenError(Object error) {
    CommonProperties.fcmToken = "";
  }


  void _onNotificationOpenedApp(dynamic initialNotification) {
    if (initialNotification != null) {
      handleMessage(initialNotification);
      //showResult('onNotificationOpenedApp', initialNotification.toString());
    }
  }


  void _onMessageReceived(RemoteMessage remoteMessage) {
    Map? data = remoteMessage.dataOfMap;



    if (data != null && data.isNotEmpty) {


        _notifications.show(
            remoteMessage.hashCode,
           data["title"],
            data['body'],
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



      // Push.localNotification(
      //   <String, String>{
      //     HMSLocalNotificationAttr.TITLE: 'DataMessage Received',
      //     HMSLocalNotificationAttr.MESSAGE: data,
      //   },
      // );

    }

  }

  // void _onMessageReceived(RemoteMessage remoteMessage) {
  //   String? data = remoteMessage.data;
  //   if (data != null) {
  //     Push.localNotification(
  //       <String, String>{
  //         HMSLocalNotificationAttr.TITLE: 'DataMessage Received',
  //         HMSLocalNotificationAttr.MESSAGE: data,
  //       },
  //     );
  //
  //   } else {
  //     Push.showToast( 'No data is present.');
  //   }
  // }

  void backgroundMessageCallback(RemoteMessage remoteMessage) async {
    Map? data = remoteMessage.dataOfMap;


    if (data != null && data.isNotEmpty) {
      _notifications.show(
          remoteMessage.hashCode,
          data["title"],
          data['body'],
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
  }

  void _onMessageReceiveError(Object error) {
    Push.showToast(error.toString());
  }
}
