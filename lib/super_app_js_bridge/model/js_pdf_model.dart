import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:flutter/foundation.dart';

class JsPdfModel implements BaseData {
  String type;
  Uint8List? bytes;
  String? url;


  JsPdfModel({
    required this.type,
    required this.bytes,
    required this.url,
  });

  factory JsPdfModel.fromJson(Map json) {
    return JsPdfModel(
      type: json['type'],
      bytes: json['bytes'],
      url: json['url'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['bytes'] = bytes;
    data['url'] = url;
    return data;
  }
}
