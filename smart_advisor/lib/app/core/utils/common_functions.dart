import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show EventTransformer;
import 'package:stream_transform/stream_transform.dart' show RateLimit, Switch;
import './utils_exports.dart' show AppConfig, AppLanguage;

class CommonFunctions {
  static EventTransformer<Event> debounce<Event>([Duration? duration]) =>
      (events, mapper) => events
          .debounce(duration ?? const Duration(milliseconds: 100))
          .switchMap(mapper);

  static showError(String error) {
    if (error.isNotEmpty) {
      try {
        BotToast.showSimpleNotification(
            title: error,
            backgroundColor: const Color.fromARGB(255, 204, 51, 51),
            hideCloseButton: true,
            duration: const Duration(seconds: 3));
      } catch (_) {}
    }
  }

  static bool get isAppAR =>
      AppConfig.getCurrentLanguageCode() == AppLanguage.ar.name;
}
