
import '../../../domain/entities/profile_entity/profile_entity.dart';
import 'base_model.dart';
import 'domain_service_model.dart';

class ProfileModel extends Profile {
  ProfileModel({
    super.id,
    super.fullName,
    super.lastName,
    super.middleName,
    super.firstName,
    super.birthDate,
    super.breif,
    super.email,
    super.facebookAccount,
    super.gender,
    super.instagramAccount,
    super.job,
    super.languageLevel,
    super.languages,
    super.linkedinAccount,
    super.maritalStatus,
    super.nationalId,
    super.nationality,
    super.skills,
    super.volunteeringFields,
    super.volunteeringDomainServices,
    super.xAccount,
    super.bloodType,
    super.city,
    super.diseases,
    super.interests,
    super.qualification,
    super.region,
    super.specialization,
    super.volunteeringLevel,
    super.volunteeringType,
    super.phone,
    super.relativePhone,
    super.scientificExpertise,
    super.fieldRegisterInterest,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'],
        fullName: json['fullName'],
        lastName: json['lastName'],
        middleName: json['middleName'],
        firstName: json['firstName'],
        birthDate: json['birthDate'],
        bloodType: json['bloodType'] != null
            ? BaseModel.fromJson(json['bloodType'])
            : null,
        breif: json['breif'],
        city: json['city'] != null ? BaseModel.fromJson(json['city']) : null,
        diseases: json['diseases'] != null
            ? BaseModel.fromJson(json['diseases'])
            : null,
        email: json['email'],
        facebookAccount: json['facebookAccount'],
        gender: json['gender'],
        instagramAccount: json['instagramAccount'],
        interests: json['interests'] != null
            ? BaseModel.fromJson(json['interests'])
            : null,
        job: json['job'],
        languageLevel: json['languageLevel'],
        languages: (json['languages'] as List?)
            ?.map((e) => BaseModel.fromJson(e))
            .toList(),
        linkedinAccount: json['linkedinAccount'],
        maritalStatus: json['maritalStatus'],
        nationalId: json['nationalId'],
        nationality: json['nationality'],
        qualification: json['qualification'] != null
            ? BaseModel.fromJson(json['qualification'])
            : null,
        region: json['region'] != null && (json['region'] as List).isNotEmpty
            ? BaseModel.fromJson((json['region'] as List).first)
            : null,
        skills: (json['skills'] as List?)
            ?.map((e) => BaseModel.fromJson(e))
            .toList(),
        specialization: json['specialization'] != null
            ? BaseModel.fromJson(json['specialization'])
            : null,
        volunteeringFields: (json['volunteeringFields'] as List?)
            ?.map((e) => BaseModel.fromJson(e))
            .toList(),
        volunteeringDomainServices: (json['volunteeringDomainServices'] as List?)
            ?.map((e) => DomainServiceModel.fromJson(e))
            .toList(),
        volunteeringLevel: json['volunteeringLevel'] != null
            ? BaseModel.fromJson(json['volunteeringLevel'])
            : null,
        volunteeringType: json['volunteeringType'] != null
            ? BaseModel.fromJson(json['volunteeringType'])
            : null,
        xAccount: json['xAccount'],
        phone: json['phone'],
        relativePhone: json['relativePhone'],
        scientificExpertise: json['scientificExpertise'],
        fieldRegisterInterest: json['fieldRegisterInterest'],
      );
}
