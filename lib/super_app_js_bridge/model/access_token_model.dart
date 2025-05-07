import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class AccessTokenModel implements BaseData {
  String accessToken;

  AccessTokenModel({required this.accessToken});

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(
      accessToken: json['access_token'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    return data;
  }
}
