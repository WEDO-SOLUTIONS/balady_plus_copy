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
    //! convert any mobile number that strats with 966 or +966 to start with 0
    String rawPhone = json['phone'] as String;
    String formattedPhone = rawPhone;

    //* Check if the number starts with 00966, +966, or 966 and convert it to 05
    //* Order matters: check longer prefixes first to avoid false matches
    if (formattedPhone.startsWith('00966')) {
      formattedPhone = '0${formattedPhone.substring(5)}'; //* Drops '00966' and adds '0'
    } else if (formattedPhone.startsWith('+966')) {
      formattedPhone = '0${formattedPhone.substring(4)}'; //* Drops '+966' and adds '0'
    } else if (formattedPhone.startsWith('966')) {
      formattedPhone = '0${formattedPhone.substring(3)}'; //* Drops '966' and adds '0'
    }

    return UserProfileModel(
      email: json['email'] as String,
      name: json['name'] as String,
      phone: formattedPhone, //* Pass the formatted phone here
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
