import 'base_entity.dart';
import 'domain_service_entity.dart';

class Profile {
  final String? id;
  final String? fullName;
  final String? lastName;
  final String? middleName;
  final String? firstName;
  final String? birthDate;
  final BaseEntity? bloodType;
  final String? breif;
  final BaseEntity? city;
  final BaseEntity? diseases;
  final String? email;
  final String? facebookAccount;
  final String? gender;
  final String? instagramAccount;
  final BaseEntity? interests;
  final String? job;
  final String? languageLevel;
  final List<BaseEntity>? languages;
  final String? linkedinAccount;
  final String? maritalStatus;
  final String? nationalId;
  final String? nationality;
  final BaseEntity? qualification;
  final BaseEntity? region;
  final List<BaseEntity>? skills;
  final BaseEntity? specialization;
  final List<BaseEntity>? volunteeringFields;
  final List<DomainServiceEntity>? volunteeringDomainServices;
  final BaseEntity? volunteeringLevel;
  final BaseEntity? volunteeringType;
  final String? xAccount;
  final String? phone;
  final String? relativePhone;
  final String? scientificExpertise;
  final String? fieldRegisterInterest;

  const Profile({
    required this.id,
    required this.fullName,
    required this.lastName,
    required this.middleName,
    required this.firstName,
    required this.birthDate,
    required this.breif,
    required this.email,
    required this.facebookAccount,
    required this.gender,
    required this.instagramAccount,
    required this.job,
    required this.languageLevel,
    required this.languages,
    required this.linkedinAccount,
    required this.maritalStatus,
    required this.nationalId,
    required this.nationality,
    required this.skills,
    required this.volunteeringFields,
    required this.volunteeringDomainServices,
    required this.xAccount,
    required this.bloodType,
    required this.city,
    required this.diseases,
    required this.interests,
    required this.qualification,
    required this.region,
    required this.specialization,
    required this.volunteeringLevel,
    required this.volunteeringType,
    required this.phone,
    required this.relativePhone,
    required this.scientificExpertise,
    required this.fieldRegisterInterest,
  });
}
