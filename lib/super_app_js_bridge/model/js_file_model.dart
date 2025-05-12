import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class JsFilesModel implements BaseData {
  String fileBase64;
  String fileName;

  JsFilesModel({
    required this.fileBase64,
    required this.fileName,
  });

  factory JsFilesModel.fromJson(Map<String, dynamic> json) {
    return JsFilesModel(
      fileBase64: json['fileBase64'],
      fileName: json['fileName'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileBase64'] = fileBase64;
    data['fileName'] = fileName;
    return data;
  }
}
