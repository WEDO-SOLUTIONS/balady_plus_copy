import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

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
// UX Cam Events
    if (RemoteConfig.uxCamKey.isNotEmpty) {
      FlutterUxcam.logEventWithProperties(
        event.nameEvent,
        event.toJson(),
      );
    }
  }


  void timeEventFromModel({required EventModel event}) async {
    mixpanel.timeEvent(event.nameEvent);
  }
}
