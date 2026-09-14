import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/volunteer_lookup.dart';

class VolunteerProfileState extends Equatable {
  final int currentStep;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final bool isLoading;
  final bool isPresentationMode;

  // Personal Info
  final String? profileId;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? nationalId;
  final String? dateOfBirth;
  final String? nationality;
  final String? gender;
  final String? maritalStatus;
  final String? nearbyPhoneNumber;
  final String? region;
  final String? regionId;
  final String? city;
  final String? cityId;

  // Track which fields came from API
  final bool isGenderFromApi;
  final bool isMaritalStatusFromApi;
  final bool isNationalIdFromApi;
  final bool isRegionFromApi;
  final bool isCityFromApi;
  final bool isNearbyPhoneNumberFromApi;
  final bool isDateOfBirthFromApi;

  // Address Info
  final String district;
  final String street;
  final String? additionalInfo;

  // Volunteer Info
  final List<String> skills;
  final List<String> interests;
  final String? previousExperience;
  final bool hasCar;
  final bool canTravel;

  // New fields
  final bool isLoadingRegions;
  final bool isLoadingCities;
  final bool isLoadingQualifications;
  final bool isLoadingSpecializations;
  final bool isLoadingLanguages;
  final bool isLoadingSkills;
  final bool isLoadingLvls;
  final bool isLoadingInterests;
  final bool isLoadingVolunteeringFields;
  final bool isLoadingBloodTypes;
  final bool isLoadingDiseases;
  final List<VolunteerLookup> regionsList;
  final List<VolunteerLookup> citiesList;
  final List<VolunteerLookup> qualificationsList;
  final List<VolunteerLookup> specializationsList;
  final List<VolunteerLookup> languagesList;
  final List<VolunteerLookup> skillsList;
  final List<VolunteerLookup> lvlsList;
  final List<VolunteerLookup> interestsList;
  final List<VolunteerLookup> volunteeringFieldsList;
  final List<VolunteerLookup> bloodTypesList;
  final List<VolunteerLookup> diseasesList;

  // Scientific Info fields
  final String? educationalQualification;
  final String? educationalQualificationId;
  final String? specialization;
  final String? specializationId;
  final String? profession;
  final String? workExperience;
  final String? language;
  final String? languageId;
  final String? scientificExperienceSummary;

  // Volunteering Interests fields
  final String? volunteeringLevel;
  final String? volunteeringLevelId;
  final String? volunteeringWorkField;
  final String? volunteeringWorkFieldId;
  final String? volunteeringType; // 'individual' or 'group' or combined
  final String? volunteeringTypeId;
  final bool isIndividualSelected; // New: track individual selection
  final bool isGroupSelected; // New: track group selection
  final List<String> skillsIds; // Store skill IDs for submission

  // Medical Info fields
  final String? bloodType;
  final String? bloodTypeId;
  final String? disease;
  final String? diseaseId;

  // Marital Status ID (for submission)
  final String? maritalStatusId;

  // Social Media Info fields
  final String? xAccount;
  final String? instagramAccount;
  final String? linkedinAccount;
  final String? facebookAccount;

  // CV Upload
  final bool isUploadingCV;
  final String? cvFileName;
  final String? cvFileUrl;
  final String? cvUploadMessage;
  final int? cvFileId; // fid value for final submission

  const VolunteerProfileState({
    this.currentStep = 0,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isLoading = false,
    this.isPresentationMode = false,
    this.profileId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.nationalId,
    this.dateOfBirth,
    this.nationality,
    this.gender,
    this.maritalStatus,
    this.nearbyPhoneNumber,
    this.region,
    this.regionId,
    this.city,
    this.cityId = '',

    // API fields tracking
    this.isGenderFromApi = false,
    this.isMaritalStatusFromApi = false,
    this.isNationalIdFromApi = false,
    this.isRegionFromApi = false,
    this.isCityFromApi = false,
    this.isNearbyPhoneNumberFromApi = false,
    this.isDateOfBirthFromApi = false,

    // Address Info
    this.district = '',
    this.street = '',
    this.additionalInfo,

    // Volunteer Info
    this.skills = const [],
    this.interests = const [],
    this.previousExperience,
    this.hasCar = false,
    this.canTravel = false,

    // New fields
    this.isLoadingRegions = false,
    this.isLoadingCities = false,
    this.isLoadingQualifications = false,
    this.isLoadingSpecializations = false,
    this.isLoadingLanguages = false,
    this.isLoadingSkills = false,
    this.isLoadingLvls = false,
    this.isLoadingInterests = false,
    this.isLoadingVolunteeringFields = false,
    this.isLoadingBloodTypes = false,
    this.isLoadingDiseases = false,
    this.regionsList = const [],
    this.citiesList = const [],
    this.qualificationsList = const [],
    this.specializationsList = const [],
    this.languagesList = const [],
    this.skillsList = const [],
    this.lvlsList = const [],
    this.interestsList = const [],
    this.volunteeringFieldsList = const [],
    this.bloodTypesList = const [],
    this.diseasesList = const [],

    // Scientific Info fields
    this.educationalQualification,
    this.educationalQualificationId,
    this.specialization,
    this.specializationId,
    this.profession,
    this.workExperience,
    this.language,
    this.languageId,
    this.scientificExperienceSummary,

    // Volunteering Interests fields
    this.volunteeringLevel,
    this.volunteeringLevelId,
    this.volunteeringWorkField,
    this.volunteeringWorkFieldId,
    this.volunteeringType,
    this.volunteeringTypeId,
    this.isIndividualSelected = false,
    this.isGroupSelected = false,
    this.skillsIds = const [],

    // Medical Info fields
    this.bloodType,
    this.bloodTypeId,
    this.disease,
    this.diseaseId,

    // Marital Status ID
    this.maritalStatusId,

    // Social Media Info fields
    this.xAccount,
    this.instagramAccount,
    this.linkedinAccount,
    this.facebookAccount,

    // CV Upload
    this.isUploadingCV = false,
    this.cvFileName,
    this.cvFileUrl,
    this.cvUploadMessage,
    this.cvFileId,
  });

  VolunteerProfileState resetProfileState() {
    return const VolunteerProfileState(
      currentStep: 0,
      isLoading: false,
      isSubmitting: false,
      isSuccess: false,
      isPresentationMode: false,
      // All profile fields reset to null/empty
      profileId: null,
      firstName: null,
      middleName: null,
      lastName: null,
      fullName: null,
      email: null,
      phoneNumber: null,
      nationalId: null,
      dateOfBirth: null,
      nationality: null,
      gender: null,
      maritalStatus: null,
      nearbyPhoneNumber: null,
      region: null,
      regionId: null,
      city: null,
      cityId: null,
      // Scientific info reset
      educationalQualification: null,
      educationalQualificationId: null,
      specialization: null,
      specializationId: null,
      profession: null,
      workExperience: null,
      language: null,
      languageId: null,
      scientificExperienceSummary: null,
      // Volunteering interests reset
      skills: [],
      skillsIds: [],
      volunteeringLevel: null,
      volunteeringLevelId: null,
      volunteeringWorkField: null,
      volunteeringWorkFieldId: null,
      volunteeringType: null,
      volunteeringTypeId: null,
      isIndividualSelected: false,
      isGroupSelected: false,
      interests: [],
      // Medical info reset
      bloodType: null,
      bloodTypeId: null,
      disease: null,
      diseaseId: null,
      // Social media reset
      xAccount: null,
      instagramAccount: null,
      linkedinAccount: null,
      facebookAccount: null,
      // API flags reset
      isGenderFromApi: false,
      isMaritalStatusFromApi: false,
      isNationalIdFromApi: false,
      isRegionFromApi: false,
      isCityFromApi: false,
      isNearbyPhoneNumberFromApi: false,
      isDateOfBirthFromApi: false,
      // CV upload reset
      isUploadingCV: false,
      cvFileName: null,
      cvFileUrl: null,
      cvUploadMessage: null,
      cvFileId: null,
      // Loading states reset
      isLoadingRegions: false,
      isLoadingCities: false,
      isLoadingQualifications: false,
      isLoadingSpecializations: false,
      isLoadingLanguages: false,
      isLoadingSkills: false,
      isLoadingLvls: false,
      isLoadingInterests: false,
      isLoadingVolunteeringFields: false,
      isLoadingBloodTypes: false,
      isLoadingDiseases: false,
      // Lists reset
      regionsList: [],
      citiesList: [],
      qualificationsList: [],
      specializationsList: [],
      languagesList: [],
      skillsList: [],
      lvlsList: [],
      interestsList: [],
      volunteeringFieldsList: [],
      bloodTypesList: [],
      diseasesList: [],
    );
  }

  VolunteerProfileState copyWith({
    int? currentStep,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool? isLoading,
    bool? isPresentationMode,
    String? profileId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? nationalId,
    String? dateOfBirth,
    String? nationality,
    String? gender,
    String? maritalStatus,
    String? nearbyPhoneNumber,
    String? region,
    String? regionId,
    String? city,
    String? cityId,
    bool? isGenderFromApi,
    bool? isMaritalStatusFromApi,
    bool? isNationalIdFromApi,
    bool? isRegionFromApi,
    bool? isCityFromApi,
    bool? isNearbyPhoneNumberFromApi,
    bool? isDateOfBirthFromApi,
    String? district,
    String? street,
    String? additionalInfo,
    List<String>? skills,
    List<String>? interests,
    String? previousExperience,
    bool? hasCar,
    bool? canTravel,
    bool? isLoadingRegions,
    bool? isLoadingCities,
    bool? isLoadingQualifications,
    bool? isLoadingSpecializations,
    bool? isLoadingLanguages,
    bool? isLoadingSkills,
    bool? isLoadingLvls,
    bool? isLoadingInterests,
    bool? isLoadingVolunteeringFields,
    bool? isLoadingBloodTypes,
    bool? isLoadingDiseases,
    List<VolunteerLookup>? regionsList,
    List<VolunteerLookup>? citiesList,
    List<VolunteerLookup>? qualificationsList,
    List<VolunteerLookup>? specializationsList,
    List<VolunteerLookup>? languagesList,
    List<VolunteerLookup>? skillsList,
    List<VolunteerLookup>? lvlsList,
    List<VolunteerLookup>? interestsList,
    List<VolunteerLookup>? volunteeringFieldsList,
    List<VolunteerLookup>? bloodTypesList,
    List<VolunteerLookup>? diseasesList,
    String? educationalQualification,
    String? educationalQualificationId,
    String? specialization,
    String? specializationId,
    String? profession,
    String? workExperience,
    String? language,
    String? languageId,
    String? scientificExperienceSummary,
    String? volunteeringLevel,
    String? volunteeringLevelId,
    String? volunteeringWorkField,
    String? volunteeringWorkFieldId,
    String? volunteeringType,
    String? volunteeringTypeId,
    bool? isIndividualSelected,
    bool? isGroupSelected,
    List<String>? skillsIds,
    String? bloodType,
    String? bloodTypeId,
    String? disease,
    String? diseaseId,
    String? maritalStatusId,
    // Social Media Info fields
    String? xAccount,
    String? instagramAccount,
    String? linkedinAccount,
    String? facebookAccount,
    // CV Upload
    bool? isUploadingCV,
    String? cvFileName,
    String? cvFileUrl,
    String? cvUploadMessage,
    int? cvFileId,
  }) => VolunteerProfileState(
    currentStep: currentStep ?? this.currentStep,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage,
    isLoading: isLoading ?? this.isLoading,
    isPresentationMode: isPresentationMode ?? this.isPresentationMode,
    profileId: profileId ?? this.profileId,
    firstName: firstName ?? this.firstName,
    middleName: middleName ?? this.middleName,
    lastName: lastName ?? this.lastName,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    nationalId: nationalId ?? this.nationalId,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    nationality: nationality ?? this.nationality,
    gender: gender ?? this.gender,
    maritalStatus: maritalStatus ?? this.maritalStatus,
    nearbyPhoneNumber: nearbyPhoneNumber ?? this.nearbyPhoneNumber,
    region: region ?? this.region,
    regionId: regionId ?? this.regionId,
    city: city ?? this.city,
    cityId: cityId ?? this.cityId,
    isGenderFromApi: isGenderFromApi ?? this.isGenderFromApi,
    isMaritalStatusFromApi: isMaritalStatusFromApi ?? this.isMaritalStatusFromApi,
    isNationalIdFromApi: isNationalIdFromApi ?? this.isNationalIdFromApi,
    isRegionFromApi: isRegionFromApi ?? this.isRegionFromApi,
    isCityFromApi: isCityFromApi ?? this.isCityFromApi,
    isNearbyPhoneNumberFromApi: isNearbyPhoneNumberFromApi ?? this.isNearbyPhoneNumberFromApi,
    isDateOfBirthFromApi: isDateOfBirthFromApi ?? this.isDateOfBirthFromApi,
    district: district ?? this.district,
    street: street ?? this.street,
    additionalInfo: additionalInfo ?? this.additionalInfo,
    skills: skills ?? this.skills,
    interests: interests ?? this.interests,
    previousExperience: previousExperience ?? this.previousExperience,
    hasCar: hasCar ?? this.hasCar,
    canTravel: canTravel ?? this.canTravel,
    isLoadingRegions: isLoadingRegions ?? this.isLoadingRegions,
    isLoadingCities: isLoadingCities ?? this.isLoadingCities,
    isLoadingQualifications: isLoadingQualifications ?? this.isLoadingQualifications,
    isLoadingSpecializations: isLoadingSpecializations ?? this.isLoadingSpecializations,
    isLoadingLanguages: isLoadingLanguages ?? this.isLoadingLanguages,
    isLoadingSkills: isLoadingSkills ?? this.isLoadingSkills,
    isLoadingLvls: isLoadingLvls ?? this.isLoadingLvls,
    isLoadingInterests: isLoadingInterests ?? this.isLoadingInterests,
    isLoadingVolunteeringFields: isLoadingVolunteeringFields ?? this.isLoadingVolunteeringFields,
    isLoadingBloodTypes: isLoadingBloodTypes ?? this.isLoadingBloodTypes,
    isLoadingDiseases: isLoadingDiseases ?? this.isLoadingDiseases,
    regionsList: regionsList ?? this.regionsList,
    citiesList: citiesList ?? this.citiesList,
    qualificationsList: qualificationsList ?? this.qualificationsList,
    specializationsList: specializationsList ?? this.specializationsList,
    languagesList: languagesList ?? this.languagesList,
    skillsList: skillsList ?? this.skillsList,
    lvlsList: lvlsList ?? this.lvlsList,
    interestsList: interestsList ?? this.interestsList,
    volunteeringFieldsList: volunteeringFieldsList ?? this.volunteeringFieldsList,
    bloodTypesList: bloodTypesList ?? this.bloodTypesList,
    diseasesList: diseasesList ?? this.diseasesList,
    educationalQualification: educationalQualification ?? this.educationalQualification,
    educationalQualificationId: educationalQualificationId ?? this.educationalQualificationId,
    specialization: specialization ?? this.specialization,
    specializationId: specializationId ?? this.specializationId,
    profession: profession ?? this.profession,
    workExperience: workExperience ?? this.workExperience,
    language: language ?? this.language,
    languageId: languageId ?? this.languageId,
    scientificExperienceSummary: scientificExperienceSummary ?? this.scientificExperienceSummary,
    volunteeringLevel: volunteeringLevel ?? this.volunteeringLevel,
    volunteeringLevelId: volunteeringLevelId ?? this.volunteeringLevelId,
    volunteeringWorkField: volunteeringWorkField ?? this.volunteeringWorkField,
    volunteeringWorkFieldId: volunteeringWorkFieldId ?? this.volunteeringWorkFieldId,
    volunteeringType: volunteeringType ?? this.volunteeringType,
    volunteeringTypeId: volunteeringTypeId ?? this.volunteeringTypeId,
    isIndividualSelected: isIndividualSelected ?? this.isIndividualSelected,
    isGroupSelected: isGroupSelected ?? this.isGroupSelected,
    skillsIds: skillsIds ?? this.skillsIds,
    bloodType: bloodType ?? this.bloodType,
    bloodTypeId: bloodTypeId ?? this.bloodTypeId,
    disease: disease ?? this.disease,
    diseaseId: diseaseId ?? this.diseaseId,
    maritalStatusId: maritalStatusId ?? this.maritalStatusId,
    // Social Media Info fields
    xAccount: xAccount ?? this.xAccount,
    instagramAccount: instagramAccount ?? this.instagramAccount,
    linkedinAccount: linkedinAccount ?? this.linkedinAccount,
    facebookAccount: facebookAccount ?? this.facebookAccount,
    // CV Upload
    isUploadingCV: isUploadingCV ?? this.isUploadingCV,
    cvFileName: cvFileName ?? this.cvFileName,
    cvFileUrl: cvFileUrl ?? this.cvFileUrl,
    cvUploadMessage: cvUploadMessage ?? this.cvUploadMessage,
    cvFileId: cvFileId ?? this.cvFileId,
  );

  @override
  List<Object?> get props => [
    currentStep,
    isSubmitting,
    isSuccess,
    errorMessage,
    isLoading,
    isPresentationMode,
    profileId,
    firstName,
    middleName,
    lastName,
    fullName,
    email,
    phoneNumber,
    nationalId,
    dateOfBirth,
    nationality,
    gender,
    maritalStatus,
    nearbyPhoneNumber,
    region,
    regionId,
    city,
    cityId,
    isGenderFromApi,
    isMaritalStatusFromApi,
    isNationalIdFromApi,
    isRegionFromApi,
    isCityFromApi,
    isNearbyPhoneNumberFromApi,
    isDateOfBirthFromApi,
    district,
    street,
    additionalInfo,
    skills,
    interests,
    previousExperience,
    hasCar,
    canTravel,
    isLoadingRegions,
    isLoadingCities,
    isLoadingQualifications,
    isLoadingSpecializations,
    isLoadingLanguages,
    isLoadingSkills,
    isLoadingLvls,
    isLoadingInterests,
    isLoadingVolunteeringFields,
    isLoadingBloodTypes,
    isLoadingDiseases,
    regionsList,
    citiesList,
    qualificationsList,
    specializationsList,
    languagesList,
    skillsList,
    lvlsList,
    interestsList,
    volunteeringFieldsList,
    bloodTypesList,
    diseasesList,
    educationalQualification,
    educationalQualificationId,
    specialization,
    specializationId,
    profession,
    workExperience,
    language,
    languageId,
    scientificExperienceSummary,
    volunteeringLevel,
    volunteeringLevelId,
    volunteeringWorkField,
    volunteeringWorkFieldId,
    volunteeringType,
    volunteeringTypeId,
    isIndividualSelected,
    isGroupSelected,
    skillsIds,
    bloodType,
    bloodTypeId,
    disease,
    diseaseId,
    maritalStatusId,
    // Social Media Info fields
    xAccount,
    instagramAccount,
    linkedinAccount,
    facebookAccount,
    // CV Upload
    isUploadingCV,
    cvFileName,
    cvFileUrl,
    cvUploadMessage,
    cvFileId,
  ];

  bool _isValidField(String? field) => field?.trim().isNotEmpty ?? false;
  bool isEmailValid(String? email) {
    if (email?.trim().isEmpty ?? true) {
      return false;
    }
    return Helpers.validateEmail(email) == null;
  }

  bool isPhoneValid(String? phone) {
    if (phone?.trim().isEmpty ?? true) {
      return false;
    }
    return Helpers.validateMobile(phone) == null;
  }

  bool get isPersonalInfoValid =>
      _isValidField(nationalId) &&
      _isValidField(fullName) &&
      _isValidField(firstName) &&
      _isValidField(lastName) &&
      _isValidField(dateOfBirth) &&
      _isValidField(gender) &&
      _isValidField(nationality) &&
      isEmailValid(email) &&
      isPhoneValid(phoneNumber) &&
      _isValidField(regionId) &&
      _isValidField(cityId);

  bool get isUnifiedStepValid =>
      _isValidField(nationalId) &&
      _isValidField(fullName) &&
      isEmailValid(email) &&
      isPhoneValid(phoneNumber) &&
      _isValidField(regionId) &&
      _isValidField(cityId) &&
      _isValidField(educationalQualificationId) &&
      _isValidField(volunteeringWorkFieldId);
  // Note: nearbyPhoneNumber (relative phone) is optional

  bool get isScientificInfoValid =>
      educationalQualification?.isNotEmpty == true &&
      specialization?.isNotEmpty == true &&
      language?.isNotEmpty == true &&
      scientificExperienceSummary?.isNotEmpty == true;

  bool get isVolunteeringInterestsValid =>
      skills.isNotEmpty &&
      volunteeringLevel?.isNotEmpty == true &&
      volunteeringWorkField?.isNotEmpty == true &&
      (isIndividualSelected || isGroupSelected); // At least one type must be selected

  bool get isMedicalInfoValid => true; // Medical info fields are optional

  bool get isSocialMediaInfoValid => true; // Placeholder step - always valid

  bool get isCurrentStepValid {
    switch (currentStep) {
      case 0:
        return isUnifiedStepValid;
      // case 0:
      //   return isPersonalInfoValid;
      // case 1:
      //   return isScientificInfoValid;
      // case 2:
      //   return isVolunteeringInterestsValid;
      // case 3:
      //   return isMedicalInfoValid;
      // case 4:
      //   return isSocialMediaInfoValid;
      default:
        return false;
    }
  }
}

class VolunteerProfileLoading extends VolunteerProfileState {
  const VolunteerProfileLoading() : super(isLoading: true);

  @override
  List<Object?> get props => [isLoading];
}

class VolunteerProfileSuccess extends VolunteerProfileState {
  const VolunteerProfileSuccess() : super(isSuccess: true);

  @override
  List<Object?> get props => [isSuccess];
}

class VolunteerProfileError extends VolunteerProfileState {
  const VolunteerProfileError(this.message) : super(errorMessage: message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class VolunteerSkillsUpdated extends VolunteerProfileState {
  const VolunteerSkillsUpdated(List<String> skills) : super(skills: skills, isLoading: false, errorMessage: null);

  @override
  List<Object?> get props => [skills, isLoading, errorMessage];
}

class VolunteerInterestsUpdated extends VolunteerProfileState {
  const VolunteerInterestsUpdated(List<String> interests)
    : super(interests: interests, isLoading: false, errorMessage: null);

  @override
  List<Object?> get props => [interests, isLoading, errorMessage];
}
