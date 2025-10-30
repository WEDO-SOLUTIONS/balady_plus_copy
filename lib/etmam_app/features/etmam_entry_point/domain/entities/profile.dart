import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show GenderType;

class Profile extends Equatable {
  String? id;
  String? userId;
  String? nameAr;
  String? nameEn;
  String? firstName;
  String? familyName;
  String? birthDate;
  String? nationalId;
  String? nationality;
  String? gender;
  String? email;
  String? mobile;
  String? cityId;
  String? cityName;

  String? langId;
  Type? type;
  Type? actorType;

  Profile({
    this.id,
    this.userId,
    this.nameAr,
    this.nameEn,
    this.firstName,
    this.familyName,
    this.birthDate,
    this.nationalId,
    this.nationality,
    this.gender,
    this.email,
    this.mobile,
    this.cityId,
    this.cityName,
    this.langId,
    this.type,
    this.actorType,
  });

  @override
  List<Object?> get props => [id, cityId, cityName, langId];

  GenderType? getGenderType() {
    if (gender != null) {
      if (gender == "1")
        return GenderType.male;
      else if (gender == "2") return GenderType.female;
    }
    return null;
  }
}

class Type {
  Type({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        name: json["name"],
      );
}
