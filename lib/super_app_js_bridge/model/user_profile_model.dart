import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';

class UserProfileModel implements BaseData {
  String email;
  String name;
  String phone;
  String nameAr;

  UserProfileModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.nameAr,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {

    return UserProfileModel(
      email: json['mail'] as String,
      name: json['en_name'] as String,
      phone: json['phone'] as String,
      nameAr: json['ar_name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['name_ar'] = nameAr;
    return data;
  }
}
