import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class UserProfileModel implements BaseData {
  String email;
  String name;
  String phone;
  String nameAr;
  String token;


  UserProfileModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.nameAr,
    required this.token,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      nameAr: json['nameAr'] as String,
      token: json['token'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['nameAr'] = nameAr;
    data['token'] = token;
    return data;
  }
}
