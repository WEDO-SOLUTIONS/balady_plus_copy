import 'dart:convert' show base64Decode, base64Encode;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:intl/intl.dart' show DateFormat;
import 'package:open_file/open_file.dart' show OpenFile;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

import 'package:flutter_bloc/flutter_bloc.dart' show EventTransformer;
import 'package:stream_transform/stream_transform.dart' show RateLimit, Switch;
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;

import '../../features/_shared_feature_/shared_feature_exports.dart'
    show AuthData, BridgeParams, FileInfo;
import '../dependency_injection/dependency_injection_exports.dart' show sl;
import '../services/services_exports.dart' show EntryPointBridge;
import './utils_exports.dart'
    show AppConfig, AppLanguage, MimeType, UIHelper, WithDelay;

class CommonFunctions {
  static EventTransformer<Event> debounce<Event>([Duration? duration]) =>
      (events, mapper) =>
          events.debounce(duration ?? UIHelper.duration).switchMap(mapper);

  static void signOut() {
    final params = sl<BridgeParams>().copyWith(isAuthenticated: false);

    final entryPointBridge = sl<EntryPointBridge>();
    entryPointBridge(params);
  }

  static String fileMimeType(String extension) {
    extension = extension.toLowerCase();
    return MimeType.values.byName(extension).mime;
  }

  static Uint8List dataFromBase64String(String base64String) =>
      Uri.parse(base64String).data!.contentAsBytes();

  static String base64String(Uint8List data) => base64Encode(data);

  static int convertBytesToMB(int bytes) => (bytes / 1048576).round();

  static Future<FileInfo> getFileInfo(PlatformFile file) async {
    final mimeType = fileMimeType(file.extension ?? '');
    final content = await fileToBase64(file.path ?? '', mimeType: mimeType);
    final fileInfo = sl<FileInfo>().copyWith(
      fileBase64: content,
      filePath: file.path,
      fileName: file.name,
      sizeInMB: convertBytesToMB(file.size),
      extension: file.extension,
    );
    return fileInfo.toFuture();
  }

  static Future<String> fileToBase64(
    String filePath, {
    String? mimeType,
  }) async {
    final bytes = await File(filePath).readAsBytes();
    String base64RecordingFile = base64Encode(bytes);
    if (mimeType != null) {
      final baseData = "data:$mimeType;base64,";
      base64RecordingFile = baseData + base64RecordingFile;
    }
    return Future.value(base64RecordingFile);
  }

  static String formatDate(String? date, [Duration? duration]) {
    final dateStr = DateTime.tryParse(date ?? '')?.toLocal();
    return dateStr != null
        ? DateFormat('dd-MM-yyyy')
            .format(dateStr.add(duration ?? const Duration()))
        : '';
  }

  static Future<void> createOpenTempFile(
    String fileName,
    String content,
  ) async {
    // create Temporary File
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$fileName';
    final file = await File(tempDocumentPath).create(recursive: true);
    Uint8List bytes = base64Decode(content);
    file.writeAsBytesSync(bytes);

    // Open File From file path
    OpenFile.open(tempDocumentPath);
  }

  static Future<void> openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static String mapARNumbersToENNumbers(String numbers) {
    Map<String, String> arToEnMapper = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };
    String englishNumbers = '';
    // numbers can be mix between ar and en
    for (int i = 0; i < numbers.length; i++) {
      if (arToEnMapper.containsKey(numbers[i])) {
        englishNumbers += arToEnMapper[numbers[i]]!;
      } else {
        englishNumbers += numbers[i];
      }
    }

    return englishNumbers;
  }

  static bool get isAuthed => sl.isRegistered<AuthData>();
  static bool get isAppAR => AppConfig.languageCode == AppLanguage.ar.name;
}
