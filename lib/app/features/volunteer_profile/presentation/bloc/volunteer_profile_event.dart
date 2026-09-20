import 'package:equatable/equatable.dart';

abstract class VolunteerProfileEvent extends Equatable {
  const VolunteerProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadVolunteerProfile extends VolunteerProfileEvent {
  const LoadVolunteerProfile();

  @override
  List<Object?> get props => [];
}

class UpdatePersonalInfo extends VolunteerProfileEvent {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? nationalId;
  final String? dateOfBirth;
  final String? nationality;
  final String? gender;
  final String? maritalStatus;
  final String? maritalStatusId;
  final String? nearbyPhoneNumber;
  final String? region;
  final String? regionId;
  final String? city;
  final String? cityId;

  const UpdatePersonalInfo({
    this.firstName,
    this.middleName,
    this.lastName,
    this.nationalId,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.nationality,
    this.gender,
    this.maritalStatus,
    this.maritalStatusId,
    this.nearbyPhoneNumber,
    this.region,
    this.regionId,
    this.city,
    this.cityId,
  });

  @override
  List<Object?> get props => [
        firstName,
        middleName,
        lastName,
        email,
        phoneNumber,
        nationalId,
        dateOfBirth,
        nationality,
        gender,
        maritalStatus,
        maritalStatusId,
        nearbyPhoneNumber,
        region,
        regionId,
        city,
        cityId,
      ];
}

class UpdateAddressInfo extends VolunteerProfileEvent {
  final String city;
  final String district;
  final String street;
  final String? additionalInfo;

  const UpdateAddressInfo({
    required this.city,
    required this.district,
    required this.street,
    this.additionalInfo,
  });

  @override
  List<Object?> get props => [
        city,
        district,
        street,
        additionalInfo,
      ];
}

class UpdateVolunteerInfo extends VolunteerProfileEvent {
  final List<String> skills;
  final List<String> interests;
  final String? previousExperience;
  final bool hasCar;
  final bool canTravel;

  const UpdateVolunteerInfo({
    required this.skills,
    required this.interests,
    this.previousExperience,
    this.hasCar = false,
    this.canTravel = false,
  });

  @override
  List<Object?> get props => [
        skills,
        interests,
        previousExperience,
        hasCar,
        canTravel,
      ];
}

class UpdateVolunteeringInterests extends VolunteerProfileEvent {
  final List<String>? skills;
  final List<String>? skillsIds;
  final List<String>? interests;
  final String? volunteeringLevel;
  final String? volunteeringLevelId;
  final String? volunteeringWorkField;
  final String? volunteeringWorkFieldId;
  final String? volunteeringService;
  final String? volunteeringServiceId;
  final String? volunteeringDomainServiceId;
  final List<String>? volunteeringDomainServiceNames;
  final String? volunteeringType;
  final bool? isIndividualSelected;
  final bool? isGroupSelected;
  final String? previousExperience;
  final bool? hasCar;
  final bool? canTravel;

  const UpdateVolunteeringInterests({
    this.skills,
    this.skillsIds,
    this.interests,
    this.volunteeringLevel,
    this.volunteeringLevelId,
    this.volunteeringWorkField,
    this.volunteeringWorkFieldId,
    this.volunteeringService,
    this.volunteeringServiceId,
    this.volunteeringDomainServiceId,
    this.volunteeringDomainServiceNames,
    this.volunteeringType,
    this.isIndividualSelected,
    this.isGroupSelected,
    this.previousExperience,
    this.hasCar,
    this.canTravel,
  });

  @override
  List<Object?> get props => [
        skills,
        skillsIds,
        interests,
        volunteeringLevel,
        volunteeringLevelId,
        volunteeringWorkField,
        volunteeringWorkFieldId,
        volunteeringService,
        volunteeringServiceId,
        volunteeringDomainServiceId,
        volunteeringDomainServiceNames,
        volunteeringType,
        isIndividualSelected,
        isGroupSelected,
        previousExperience,
        hasCar,
        canTravel,
      ];
}

class SubmitVolunteerProfile extends VolunteerProfileEvent {
  const SubmitVolunteerProfile();
}

class UpdateVolunteerProfile extends VolunteerProfileEvent {
  const UpdateVolunteerProfile();
}

class ChangeStep extends VolunteerProfileEvent {
  final int step;

  const ChangeStep(this.step);

  @override
  List<Object?> get props => [step];
}

class FetchRegions extends VolunteerProfileEvent {
  const FetchRegions();
}

class FetchCities extends VolunteerProfileEvent {
  final String regionId;

  const FetchCities(this.regionId);

  @override
  List<Object> get props => [regionId];
}

class FetchQualifications extends VolunteerProfileEvent {
  const FetchQualifications();
}

class UpdateScientificInfo extends VolunteerProfileEvent {
  final String? educationalQualification;
  final String? educationalQualificationId;
  final String? specialization;
  final String? specializationId;
  final String? profession;
  final String? workExperience;
  final String? language;
  final String? languageId;
  final String? scientificExperienceSummary;
  // TODO: Add field for CV attachment if needed

  const UpdateScientificInfo({
    this.educationalQualification,
    this.educationalQualificationId,
    this.specialization,
    this.specializationId,
    this.profession,
    this.workExperience,
    this.language,
    this.languageId,
    this.scientificExperienceSummary,
  });

  @override
  List<Object?> get props => [
        educationalQualification,
        educationalQualificationId,
        specialization,
        specializationId,
        profession,
        workExperience,
        language,
        languageId,
        scientificExperienceSummary,
      ];
}

class FetchSpecializations extends VolunteerProfileEvent {
  const FetchSpecializations();
}

class FetchLanguages extends VolunteerProfileEvent {
  const FetchLanguages();
}

class FetchSkills extends VolunteerProfileEvent {
  const FetchSkills();
}

class FetchLvls extends VolunteerProfileEvent {
  const FetchLvls();
}

class FetchInterests extends VolunteerProfileEvent {
  const FetchInterests();
}

class FetchVolunteeringFields extends VolunteerProfileEvent {
  const FetchVolunteeringFields();
}

class FetchVolunteeringServices extends VolunteerProfileEvent {
  final String parentId;
  const FetchVolunteeringServices(this.parentId);

  @override
  List<Object?> get props => [parentId];
}

class FetchBloodTypes extends VolunteerProfileEvent {
  const FetchBloodTypes();
}

class FetchDiseases extends VolunteerProfileEvent {
  const FetchDiseases();
}

class UpdateMedicalInfo extends VolunteerProfileEvent {
  final String? bloodType;
  final String? bloodTypeId;
  final String? disease;
  final String? diseaseId;

  const UpdateMedicalInfo({
    this.bloodType,
    this.bloodTypeId,
    this.disease,
    this.diseaseId,
  });

  @override
  List<Object?> get props => [
        bloodType,
        bloodTypeId,
        disease,
        diseaseId,
      ];
}

class UploadCVFile extends VolunteerProfileEvent {
  final String filePath;
  final String fileName;

  const UploadCVFile({
    required this.filePath,
    required this.fileName,
  });

  @override
  List<Object?> get props => [filePath, fileName];
}

class UpdateSocialMediaInfo extends VolunteerProfileEvent {
  final String? xAccount;
  final String? instagramAccount;
  final String? linkedinAccount;
  final String? facebookAccount;

  const UpdateSocialMediaInfo({
    this.xAccount,
    this.instagramAccount,
    this.linkedinAccount,
    this.facebookAccount,
  });

  @override
  List<Object?> get props => [
        xAccount,
        instagramAccount,
        linkedinAccount,
        facebookAccount,
      ];
}

class SwitchToPresentationMode extends VolunteerProfileEvent {
  final bool isPresentationMode;

  const SwitchToPresentationMode(this.isPresentationMode);

  @override
  List<Object?> get props => [isPresentationMode];
}
