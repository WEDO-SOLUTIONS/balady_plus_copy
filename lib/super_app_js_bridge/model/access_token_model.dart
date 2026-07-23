import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class AccessTokenModel implements BaseData {
  String accessToken;

  AccessTokenModel({required this.accessToken});

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(accessToken: json['accessToken'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    return data;
  }
}

class CookiesModel implements BaseData {
  String cookies;

  CookiesModel({required this.cookies});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cookies'] = cookies;
    return data;
  }
}

class RideHailingKeyModel implements BaseData {
  String rideHailingKey;

  RideHailingKeyModel({required this.rideHailingKey});

  factory RideHailingKeyModel.fromJson(Map<String, dynamic> json) {
    return RideHailingKeyModel(rideHailingKey: json['rideHailingKey'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rideHailingKey'] = rideHailingKey;
    return data;
  }
}
