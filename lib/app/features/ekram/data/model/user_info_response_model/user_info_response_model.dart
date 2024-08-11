import 'death_info.dart';
import 'deceased_info.dart';

class UserInfoResponseModel {
  DeathInfo? deathInfo;
  DeceasedInfoModel? deceasedInfo;

  UserInfoResponseModel({this.deathInfo, this.deceasedInfo});

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseModel(
      deathInfo: json['deathInfo'] == null
          ? null
          : DeathInfo.fromJson(json['deathInfo'] as Map<String, dynamic>),
      deceasedInfo: json['deceasedInfo'] == null
          ? null
          : DeceasedInfoModel.fromJson(
              json['deceasedInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'deathInfo': deathInfo?.toJson(),
        'deceasedInfo': deceasedInfo?.toJson(),
      };
}
