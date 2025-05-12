import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class JsLocationModel implements BaseData {
  double latitude;
  double longitude;

  JsLocationModel({
    required this.latitude,
    required this.longitude,
  });

  factory JsLocationModel.fromJson(Map<String, dynamic> json) {
    return JsLocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
