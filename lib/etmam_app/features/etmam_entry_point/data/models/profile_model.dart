import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart';

class ProfileModel extends Profile {
  ProfileModel(
      {super.actorType,
      super.birthDate,
      super.nationalId,
      super.nationality,
      super.gender,
      super.cityId,
      super.cityName,
      super.email,
      super.familyName,
      super.firstName,
      super.id,
      super.langId,
      super.mobile,
      super.nameAr,
      super.nameEn,
      super.type,
      super.userId});

  factory ProfileModel.fromMap(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        userId: json["userId"],
        nameAr: json["nameAr"],
        nameEn: json["nameEn"],
        firstName: json["firstName"],
        familyName: json["familyName"],
        birthDate: json["birthDate"],
        nationalId: json["nationalId"],
        nationality: json["nationality"],
        gender: json["gender"],
        email: json["email"],
        mobile: json["mobile"],
        cityId: json["cityId"],
        cityName: json["cityName"],
        langId: json["langId"],
        type: json["type"] != null ? TypeModel.fromMap(json["type"]) : null,
        actorType: json["actorType"] != null
            ? TypeModel.fromMap(json["actorType"])
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "nameAr": nameAr,
      "nameEn": nameEn,
      "firstName": firstName,
      "familyName": familyName,
      "birthDate": birthDate,
      "nationalId": nationalId,
      "nationality": nationality,
      "gender": gender,
      "email": email,
      "mobile": mobile,
      "cityId": cityId,
      "cityName": cityName,
      "langId": langId,
      "type": type != null
          ? TypeModel(id: type?.id, name: type?.name).toJson()
          : null,
      "actorType": actorType != null
          ? TypeModel(id: actorType?.id, name: actorType?.name).toJson()
          : null,
    };
  }
}

class TypeModel extends Type {
  TypeModel({super.id, super.name});

  factory TypeModel.fromMap(Map<String, dynamic> json) => TypeModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

extension ProfileModelFromEntity on Profile {
  ProfileModel get toModel => ProfileModel(
      actorType: actorType,
      birthDate: birthDate,
      cityId: cityId,
      cityName: cityName,
      email: email,
      familyName: familyName,
      firstName: firstName,
      id: id,
      nationalId: nationalId,
      nationality: nationality,
      gender: gender,
      langId: langId,
      mobile: mobile,
      nameAr: nameAr,
      nameEn: nameEn,
      type: type,
      userId: userId);
}

extension TypeModelFromEntity on Type {
  TypeModel get toModel => TypeModel(id: id, name: name);
}
