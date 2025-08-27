import 'dart:io';

import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileMapnessLogger implements IMapnessLogger {
  static late File _logsFile;

  @override
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logsFile = File('${directory.path}/balady-logs.txt');

    await _logsFile.writeAsString('');
  }

  @override
  void log(String line, {MapnessLogLevel logLevel = MapnessLogLevel.debug}) {
    _logsFile.writeAsString('$line\n', mode: FileMode.append);
  }

  @override
  void share() {
    Share.shareXFiles(
      [
        XFile(_logsFile.path),
      ],
    );
  }
}
