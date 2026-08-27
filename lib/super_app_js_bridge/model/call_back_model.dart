import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class CallBackModel implements BaseData {
  String hitUrl;
  String matchedCallback;
  String query;
  String path;

  CallBackModel({
    required this.hitUrl,
    required this.matchedCallback,
    required this.query,
    required this.path,
  });

  factory CallBackModel.fromJson(Map json) {
    return CallBackModel(
      hitUrl: json['hitUrl']?.toString() ?? '',
      matchedCallback: json['matchedCallback']?.toString() ?? '',
      query: json['query']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hitUrl'] = hitUrl;
    data['matchedCallback'] = matchedCallback;
    data['query'] = query;
    data['path'] = path;
    return data;
  }
}
