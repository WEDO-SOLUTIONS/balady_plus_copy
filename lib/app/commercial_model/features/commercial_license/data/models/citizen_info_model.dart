import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

class CitizenInfoModel extends Equatable {
  final int? identityNumber;
  final String? firstName;
  final String? secondName;
  final dynamic thirdName;
  final String? familyName;
  final String? idIssueDate;
  final String? idIssueDateSt;
  final int? idIssuePlaceCode;
  final String? idIssuePlaceDescription;
  final String? idExpiryDate;
  final String? idExpiryDateSt;
  final dynamic dateOfBirth;
  final String? dateOfBirthSt;
  final dynamic placeOfBirth;
  final int? religionCode;
  final String? religionDescription;
  final int? nationalityCode;
  final String? nationalityDescription;
  final int? sexCode;
  final String? sexDescription;
  final int? occupationCode;
  final String? occupationDescription;
  final int? maritalStatusCode;
  final String? maritalStatusDescription;
  final dynamic hafizaNumber;
  final bool? isDead;

  CitizenInfoModel({
    this.identityNumber,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.familyName,
    this.idIssueDate,
    this.idIssueDateSt,
    this.idIssuePlaceCode,
    this.idIssuePlaceDescription,
    this.idExpiryDate,
    this.idExpiryDateSt,
    this.dateOfBirth,
    this.dateOfBirthSt,
    this.placeOfBirth,
    this.religionCode,
    this.religionDescription,
    this.nationalityCode,
    this.nationalityDescription,
    this.sexCode,
    this.sexDescription,
    this.occupationCode,
    this.occupationDescription,
    this.maritalStatusCode,
    this.maritalStatusDescription,
    this.hafizaNumber,
    this.isDead,
  });

  factory CitizenInfoModel.fromJson(Map<String, dynamic> json) =>
      CitizenInfoModel(
        identityNumber: json["identityNumber"],
        firstName: json["firstName"],
        secondName: json["secondName"],
        thirdName: json["thirdName"],
        familyName: json["familyName"],
        idIssueDate: json["idIssueDate"],
        idIssueDateSt: json["idIssueDateSt"],
        idIssuePlaceCode: json["idIssuePlaceCode"],
        idIssuePlaceDescription: json["idIssuePlaceDescription"],
        idExpiryDate: json["idExpiryDate"],
        idExpiryDateSt: json["idExpiryDateSt"],
        dateOfBirth: json["dateOfBirth"],
        dateOfBirthSt: json["dateOfBirthSt"],
        placeOfBirth: json["placeOfBirth"],
        religionCode: json["religionCode"],
        religionDescription: json["religionDescription"],
        nationalityCode: json["nationalityCode"],
        nationalityDescription: json["nationalityDescription"],
        sexCode: json["sexCode"],
        sexDescription: json["sexDescription"],
        occupationCode: json["occupationCode"],
        occupationDescription: json["occupationDescription"],
        maritalStatusCode: json["maritalStatusCode"],
        maritalStatusDescription: json["maritalStatusDescription"],
        hafizaNumber: json["hafizaNumber"],
        isDead: json["isDead"],
      );

  Map<String, dynamic> toJson() => {
        "identityNumber": identityNumber,
        "firstName": firstName,
        "secondName": secondName,
        "thirdName": thirdName,
        "familyName": familyName,
        "idIssueDate": idIssueDate,
        "idIssueDateSt": idIssueDateSt,
        "idIssuePlaceCode": idIssuePlaceCode,
        "idIssuePlaceDescription": idIssuePlaceDescription,
        "idExpiryDate": idExpiryDate,
        "idExpiryDateSt": idExpiryDateSt,
        "dateOfBirth": dateOfBirth,
        "dateOfBirthSt": dateOfBirthSt,
        "placeOfBirth": placeOfBirth,
        "religionCode": religionCode,
        "religionDescription": religionDescription,
        "nationalityCode": nationalityCode,
        "nationalityDescription": nationalityDescription,
        "sexCode": sexCode,
        "sexDescription": sexDescription,
        "occupationCode": occupationCode,
        "occupationDescription": occupationDescription,
        "maritalStatusCode": maritalStatusCode,
        "maritalStatusDescription": maritalStatusDescription,
        "hafizaNumber": hafizaNumber,
        "isDead": isDead,
      };

  @override
  List<Object?> get props => [identityNumber];

  String get fullName =>
      [firstName, secondName, thirdName, familyName].whereNotNull().join(" ");
}
