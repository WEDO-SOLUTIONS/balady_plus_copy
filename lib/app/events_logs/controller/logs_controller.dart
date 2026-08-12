import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/event_model.dart';
import '../models/event_super_properties.dart';
import '../models/people_profile_properties.dart';

class LogsViewModel {
  static late final Mixpanel mixpanel;

  LogsViewModel._privateConstructor();

  static final LogsViewModel _instance = LogsViewModel._privateConstructor();

  factory LogsViewModel() {
    return _instance;
  }

  // void sendEvent(String name, {Map<String, dynamic>? data}) async {
  //   mixpanel.track(name, properties: data);
  // }

  void clearUserProperties() async {
    mixpanel.clearSuperProperties();
  }

  void setPeopleProfileProperties(PeopleProfileProperties properties) {
    mixpanel.identify('${properties.userId}');
    properties.toJson().forEach((key, value) {
      mixpanel.getPeople().set(key, value);
    });
  }

  void setRegisterSuperProperties(EventSuperProperties properties) async {
    mixpanel.registerSuperProperties(properties.toJson());
  }

  void sendEventFromModel({required EventModel event}) async {
    try {
      Sentry.captureException(SentryException(type: event.nameEvent, value: event.message, unknown: event.toJson()));
    } catch (e) {
      print("Error From INSIDE FRAME_WORK");
      print("--------------------------------");
      print("Error :  $e");
    }
  }

  void timeEventFromModel({required EventModel event}) async {
    mixpanel.timeEvent(event.nameEvent);
  }
}
