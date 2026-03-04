import 'dart:typed_data';

import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class JsFilesModel implements BaseData {
  String fileBase64;
  String fileName;
  // Uint8List fileBytes;
  String filePath;

  JsFilesModel({
    required this.fileBase64,
    required this.fileName,
    // required this.fileBytes,
    required this.filePath,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileBase64'] = fileBase64;
    data['fileName'] = fileName;
    // data['fileBytes'] = fileBytes;
    data['filePath'] = filePath;
    return data;
  }
}
