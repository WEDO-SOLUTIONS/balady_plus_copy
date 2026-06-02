import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerMapnessLogger implements IMapnessLogger {
  final Talker _talker = Talker();

  Talker get talker => _talker;

  @override
  Future<void> init() async {
    // Already initialized in constructor
  }

  @override
  void log(String line, {MapnessLogLevel logLevel = MapnessLogLevel.info}) {
    _talker.log(line, logLevel: _toTalkerLogLevel(logLevel));
    if (kDebugMode) {
      debugPrint(line);
    }
  }

  @override
  void share() {
    _talker.log('Talker screen should be accessible via the app UI');
    Navigator.of(NavigationService.navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => TalkerScreen(talker: _talker),
      ),
    );
  }

  LogLevel _toTalkerLogLevel(MapnessLogLevel logLevel) {
    switch (logLevel) {
      case MapnessLogLevel.error:
        return LogLevel.error;
      case MapnessLogLevel.critical:
        return LogLevel.critical;
      case MapnessLogLevel.info:
        return LogLevel.info;
      case MapnessLogLevel.debug:
        return LogLevel.debug;
      case MapnessLogLevel.verbose:
        return LogLevel.verbose;
      case MapnessLogLevel.warning:
        return LogLevel.warning;
    }
  }
}
