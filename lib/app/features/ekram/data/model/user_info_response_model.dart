import '../../domain/entities/user_info_response.dart';

class UserInfoResponseModel extends UserInfoResponse {
  UserInfoResponseModel({
    super.firstName,
    super.secondName,
    super.thirdName,
    super.familyName,
    super.religionCode,
    super.religionDescription,
    super.nationalityCode,
    super.nationalityDescription,
    super.genderCode,
    super.genderDescription,
  });

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      UserInfoResponseModel(
        firstName: json["firstName"],
        secondName: json["secondName"],
        thirdName: json["thirdName"],
        familyName: json["familyName"],
        religionCode: json["religionCode"],
        religionDescription: json["religionDescription"],
        nationalityCode: json["nationalityCode"],
        nationalityDescription: json["nationalityDescription"],
        genderCode: json["genderCode"],
        genderDescription: json["genderDescription"],
      );
}
