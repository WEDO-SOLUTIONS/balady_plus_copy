import 'package:mapness/shared/utils/logger/talker_logger.dart';

final IMapnessLogger logger = TalkerMapnessLogger();

enum MapnessLogLevel {
  /// Errors
  error,
  critical,

  /// Messages
  info,
  debug,
  verbose,
  warning,
}

abstract interface class IMapnessLogger {
  /// Initialize the logger. It should not be depended on context.
  Future<void> init();

  /// Log a message.
  /// [line] - the message to log.
  /// [logLevel] - the level of the log. Could be used to filter logs or highlight them.
  void log(String line, {MapnessLogLevel logLevel = MapnessLogLevel.debug});

  /// Share the logs. To show the logs or to export them.
  void share();
}
