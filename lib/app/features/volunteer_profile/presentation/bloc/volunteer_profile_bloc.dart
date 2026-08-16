import 'dart:async';

import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:bloc/bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../domain/use_cases/get_blood_types.dart';
import '../../domain/use_cases/get_cities.dart';
import '../../domain/use_cases/get_diseases.dart';
import '../../domain/use_cases/get_interests.dart';
import '../../domain/use_cases/get_launguages.dart';
import '../../domain/use_cases/get_lvls.dart';
import '../../domain/use_cases/get_profile.dart';
import '../../domain/use_cases/get_qualifications.dart';
import '../../domain/use_cases/get_regions.dart';
import '../../domain/use_cases/get_skills.dart';
import '../../domain/use_cases/get_specializations.dart';
import '../../domain/use_cases/get_volunteering_fields.dart';
import '../../domain/use_cases/get_volunteering_services.dart';
import '../../domain/use_cases/submit_profile.dart';
import '../../domain/use_cases/upload_cv.dart';

import 'volunteer_profile_event.dart';
import 'volunteer_profile_state.dart';

class VolunteerProfileBloc
    extends Bloc<VolunteerProfileEvent, VolunteerProfileState> {
  final GetProfile getProfile;
  final GetRegions getRegions;
  final GetCities getCities;
  final GetQualifications getQualifications;
  final GetSpecializations getSpecializations;
  final GetLaunguages getLaunguages;
  final GetSkills getSkills;
  final GetLvls getLvls;
  final GetInterests getInterests;
  final GetVolunteeringFields getVolunteeringFields;
  final GetVolunteeringServices getVolunteeringServices;
  final GetBloodTypes getBloodTypes;
  final GetDiseases getDiseases;
  final UploadCV uploadCV;
  final SubmitProfile submitProfile;

  VolunteerProfileBloc({
    required this.getProfile,
    required this.getRegions,
    required this.getCities,
    required this.getQualifications,
    required this.getSpecializations,
    required this.getLaunguages,
    required this.getSkills,
    required this.getLvls,
    required this.getInterests,
    required this.getVolunteeringFields,
    required this.getVolunteeringServices,
    required this.getBloodTypes,
    required this.getDiseases,
    required this.uploadCV,
    required this.submitProfile,
  }) : super(const VolunteerProfileState()) {
    on<LoadVolunteerProfile>(_onLoadVolunteerProfile);
    on<UpdatePersonalInfo>(_onUpdatePersonalInfo);
    on<UpdateAddressInfo>(_onUpdateAddressInfo);
    on<UpdateVolunteerInfo>(_onUpdateVolunteerInfo);
    on<UpdateVolunteeringInterests>(_onUpdateVolunteeringInterests);
    on<UpdateScientificInfo>(_onUpdateScientificInfo);
    on<SubmitVolunteerProfile>(_onSubmitVolunteerProfile);
    on<UpdateVolunteerProfile>(_onUpdateVolunteerProfile);
    on<ChangeStep>(_onChangeStep);
    on<FetchRegions>(_onFetchRegions);
    on<FetchCities>(_onFetchCities);
    on<FetchQualifications>(_onFetchQualifications);
    on<FetchSpecializations>(_onFetchSpecializations);
    on<FetchLanguages>(_onFetchLanguages);
    on<FetchSkills>(_onFetchSkills);
    on<FetchLvls>(_onFetchLvls);
    on<FetchInterests>(_onFetchInterests);
    on<FetchVolunteeringFields>(_onFetchVolunteeringFields);
    on<FetchVolunteeringServices>(_onFetchVolunteeringServices);
    on<FetchBloodTypes>(_onFetchBloodTypes);
    on<FetchDiseases>(_onFetchDiseases);
    on<UpdateMedicalInfo>(_onUpdateMedicalInfo);
    on<UpdateSocialMediaInfo>(_onUpdateSocialMediaInfo);
    on<SwitchToPresentationMode>(_onSwitchToPresentationMode);
    on<UploadCVFile>(_onUploadCVFile);
  }

  /// Resets all profile data to initial state

  Future<void> _onLoadVolunteerProfile(
    LoadVolunteerProfile event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    try {
      // Reset state and set loading

      emit(state.resetProfileState().copyWith(isLoading: true));

      final result = await getProfile(NoParams());

      result.fold(
        (failure) {
          emit(state.copyWith(
              isLoading: false, errorMessage: 'failed_to_load_profile'.tr()));
        },
        (profile) {
          // Check if fields exist in the API response
          final hasGender =
              profile.gender != null && profile.gender!.isNotEmpty;
          final hasMaritalStatus = profile.maritalStatus != null &&
              profile.maritalStatus!.isNotEmpty;
          final hasNationalId =
              profile.nationalId != null && profile.nationalId!.isNotEmpty;

          // Parse birthdate from string if available

          // Map scientific info fields
          String? educationalQualificationId;
          String? specializationId;
          String? languageId;
          if (profile.qualification?.id != null) {
            educationalQualificationId = profile.qualification!.id.toString();
          }
          if (profile.specialization?.id != null) {
            specializationId = profile.specialization!.id.toString();
          }
          if (profile.languages != null &&
              profile.languages!.isNotEmpty &&
              profile.languages!.first.id != null) {
            languageId = profile.languages!.first.id.toString();
          }

          // Map volunteering fields
          String? volunteeringLevelId;
          String? volunteeringWorkFieldId;
          String? volunteeringTypeId;
          List<String> skillsIds = [];
          if (profile.volunteeringLevel?.id != null) {
            volunteeringLevelId = profile.volunteeringLevel!.id.toString();
          }
          if (profile.volunteeringFields != null &&
              profile.volunteeringFields!.isNotEmpty &&
              profile.volunteeringFields!.first.id != null) {
            volunteeringWorkFieldId =
                profile.volunteeringFields!.first.id.toString();
          }
          if (profile.volunteeringType?.id != null) {
            volunteeringTypeId = profile.volunteeringType!.id.toString();
          }
          if (profile.skills != null) {
            skillsIds = profile.skills!
                .where((skill) => skill.id != null)
                .map((skill) => skill.id.toString())
                .toList();
          }

          // Determine individual and group selections based on existing volunteeringType
          bool isIndividualSelected = false;
          bool isGroupSelected = false;
          if (profile.volunteeringType?.name != null) {
            final typeName = profile.volunteeringType!.name!;
            if (typeName == 'جماعي/فردي') {
              // Combined type - both selected
              isIndividualSelected = true;
              isGroupSelected = true;
            } else if (typeName.toLowerCase().contains('individual') ||
                typeName.contains('فردي')) {
              isIndividualSelected = true;
            } else if (typeName.toLowerCase().contains('group') ||
                typeName.contains('جماعي')) {
              isGroupSelected = true;
            }
          }

          // Map medical info fields
          String? bloodTypeId;
          String? diseaseId;
          if (profile.bloodType != null) {
            bloodTypeId = profile.bloodType!.id?.toString();
          }
          if (profile.diseases != null) {
            diseaseId = profile.diseases!.id?.toString();
          }

          // Map region and city IDs from the API response
          String? regionId;
          String? cityId;
          if (profile.region?.id != null) {
            regionId = profile.region!.id.toString();
          }
          if (profile.city?.id != null) {
            cityId = profile.city!.id.toString();
          }

          // Determine if we should enter presentation mode
          // Presentation mode is enabled when language field is not null/empty
          final isPresentationMode = profile.languages != null &&
              profile.languages!.isNotEmpty &&
              profile.languages!.first.name != null &&
              profile.languages!.first.name!.isNotEmpty;

          emit(state.copyWith(
            isLoading: false,
            isPresentationMode: isPresentationMode,
            profileId: profile.id,
            firstName: profile.firstName,
            middleName: profile.middleName,
            lastName: profile.lastName,
            fullName: profile.fullName,
            email: profile.email ?? '',
            phoneNumber: profile.phone ?? '',
            nationalId: profile.nationalId ?? '',
            dateOfBirth: profile.birthDate,
            nationality: profile.nationality,
            gender: profile.gender,
            maritalStatus: profile.maritalStatus,
            nearbyPhoneNumber: profile.relativePhone ?? '',
            region: profile.region?.name ?? '',
            regionId: regionId,
            city: profile.city?.name ?? '',
            cityId: cityId,

            // Scientific Info fields
            educationalQualification: profile.qualification?.name,
            educationalQualificationId: educationalQualificationId,
            specialization: profile.specialization?.name,
            specializationId: specializationId,
            profession: profile.job,
            workExperience: profile.scientificExpertise,
            language: profile.languages?.isNotEmpty == true
                ? profile.languages!.first.name
                : null,
            languageId: languageId,
            scientificExperienceSummary: profile.breif,

            // Volunteering Interests fields
            skills: profile.skills
                    ?.where((skill) => skill.name != null)
                    .map((skill) => skill.name!)
                    .toList() ??
                [],
            skillsIds: skillsIds,
            volunteeringLevel: profile.volunteeringLevel?.name,
            volunteeringLevelId: volunteeringLevelId,
            volunteeringWorkField:
                profile.volunteeringFields?.isNotEmpty == true
                    ? profile.volunteeringFields!.first.name
                    : null,
            volunteeringWorkFieldId: volunteeringWorkFieldId,
            volunteeringType: profile.volunteeringType?.name,
            volunteeringTypeId: volunteeringTypeId,
            isIndividualSelected: isIndividualSelected,
            isGroupSelected: isGroupSelected,
            volunteeringDomainServiceNames: profile.volunteeringDomainServices
                    ?.where((s) => s.parentName != null)
                    .map((s) => s.parentName!)
                    .toList() ??
                [],
            volunteeringDomainServiceId: profile.volunteeringDomainServices
                    ?.isNotEmpty ==
                true
                ? profile.volunteeringDomainServices!.first.parentId?.toString()
                : null,
            interests: profile.interests?.name != null
                ? [profile.interests!.name!]
                : [],

            // Medical Info fields
            bloodType: profile.bloodType?.name,
            bloodTypeId: bloodTypeId,
            disease: profile.diseases?.name,
            diseaseId: diseaseId,

            // Social Media fields
            xAccount: profile.xAccount,
            instagramAccount: profile.instagramAccount,
            linkedinAccount: profile.linkedinAccount,
            facebookAccount: profile.facebookAccount,

            // Set API flags based on field existence
            isGenderFromApi: hasGender,
            isMaritalStatusFromApi: hasMaritalStatus,
            isNationalIdFromApi: hasNationalId,
          ));

          // Automatically fetch lookups when profile is loaded
          add(const FetchRegions());
          add(const FetchQualifications());
          add(const FetchSpecializations());
          add(const FetchLanguages());
          add(const FetchSkills());
          add(const FetchLvls());
          add(const FetchInterests());
          add(const FetchVolunteeringFields());
          add(const FetchBloodTypes());
          add(const FetchDiseases());
          // Fetch child services for the pre-selected domain so the dropdown pre-selects correctly
          final domainId = profile.volunteeringDomainServices?.isNotEmpty == true
              ? profile.volunteeringDomainServices!.first.parentId?.toString()
              : null;
          if (domainId != null) add(FetchVolunteeringServices(domainId));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage: '${'failed_to_load_profile'.tr()}: $e'));
    }
  }

  Future<void> _onFetchRegions(
    FetchRegions event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingRegions: true, regionsList: []));
    final result = await getRegions(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingRegions: false,
          errorMessage: 'failed_to_load_regions'.tr())),
      (regions) {
        // Use the regionId we already have from the API response
        // or try to match by name as fallback
        String? finalRegionId = state.regionId;

        // If we don't have regionId but have region name, try to match
        if ((finalRegionId == null || finalRegionId.isEmpty) &&
            state.region?.isNotEmpty == true) {
          try {
            final matchingRegion = regions.firstWhere(
              (region) => region.name.trim() == state.region?.trim(),
            );
            finalRegionId = matchingRegion.tid.toString();
          } catch (e) {
            // Try partial matching as fallback
            try {
              final partialMatch = regions.firstWhere(
                (region) =>
                    region.name.contains(state.region!) ||
                    state.region!.contains(region.name),
              );
              finalRegionId = partialMatch.tid.toString();
            } catch (e2) {
              // No match found
            }
          }
        }

        emit(state.copyWith(
          isLoadingRegions: false,
          regionsList: regions,
          regionId: finalRegionId,
        ));

        // If we have a region ID, load its cities
        if (finalRegionId != null && finalRegionId.isNotEmpty) {
          add(FetchCities(finalRegionId));
        }
      },
    );
  }

  Future<void> _onFetchCities(
    FetchCities event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingCities: true, citiesList: []));
    final result = await getCities(event.regionId);
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingCities: false, errorMessage: 'failed_to_load_cities'.tr())),
      (cities) {
        // Use the cityId we already have from the API response
        // or try to match by name as fallback
        String? finalCityId = state.cityId;

        // If we don't have cityId but have city name, try to match
        if ((finalCityId == null || finalCityId.isEmpty) &&
            state.city?.isNotEmpty == true) {
          try {
            final matchingCity = cities.firstWhere(
              (city) => city.name.trim() == state.city?.trim(),
            );
            finalCityId = matchingCity.tid.toString();
          } catch (e) {
            // Try partial matching as fallback
            try {
              final partialMatch = cities.firstWhere(
                (city) =>
                    city.name.contains(state.city!) ||
                    state.city!.contains(city.name),
              );
              finalCityId = partialMatch.tid.toString();
            } catch (e2) {
              // No match found - let user select manually
            }
          }
        }

        emit(state.copyWith(
          isLoadingCities: false,
          citiesList: cities,
          cityId: finalCityId,
        ));
      },
    );
  }

  Future<void> _onFetchQualifications(
    FetchQualifications event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingQualifications: true, qualificationsList: []));
    final result = await getQualifications(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingQualifications: false,
          errorMessage: 'failed_to_load_qualifications'.tr())),
      (qualifications) => emit(state.copyWith(
          isLoadingQualifications: false, qualificationsList: qualifications)),
    );
  }

  Future<void> _onFetchSpecializations(
    FetchSpecializations event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state
        .copyWith(isLoadingSpecializations: true, specializationsList: []));
    final result = await getSpecializations(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingSpecializations: false,
          errorMessage: 'failed_to_load_specializations'.tr())),
      (specializations) => emit(state.copyWith(
          isLoadingSpecializations: false,
          specializationsList: specializations)),
    );
  }

  Future<void> _onFetchLanguages(
    FetchLanguages event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingLanguages: true, languagesList: []));
    final result = await getLaunguages(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingLanguages: false,
          errorMessage: 'failed_to_load_languages'.tr())),
      (languages) => emit(
          state.copyWith(isLoadingLanguages: false, languagesList: languages)),
    );
  }

  Future<void> _onFetchSkills(
    FetchSkills event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingSkills: true, skillsList: []));
    final result = await getSkills(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingSkills: false, errorMessage: 'failed_to_load_skills'.tr())),
      (skills) =>
          emit(state.copyWith(isLoadingSkills: false, skillsList: skills)),
    );
  }

  Future<void> _onFetchLvls(
    FetchLvls event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingLvls: true, lvlsList: []));
    final result = await getLvls(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingLvls: false, errorMessage: 'failed_to_load_levels'.tr())),
      (levels) => emit(state.copyWith(isLoadingLvls: false, lvlsList: levels)),
    );
  }

  Future<void> _onFetchInterests(
    FetchInterests event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingInterests: true, interestsList: []));
    final result = await getInterests(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingInterests: false,
          errorMessage: 'failed_to_load_interests'.tr())),
      (interests) => emit(
          state.copyWith(isLoadingInterests: false, interestsList: interests)),
    );
  }

  Future<void> _onFetchVolunteeringFields(
    FetchVolunteeringFields event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(
        isLoadingVolunteeringFields: true, volunteeringFieldsList: []));
    final result = await getVolunteeringFields(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingVolunteeringFields: false,
          errorMessage: 'failed_to_load_volunteering_fields'.tr())),
      (fields) => emit(state.copyWith(
          isLoadingVolunteeringFields: false, volunteeringFieldsList: fields)),
    );
  }

  Future<void> _onFetchVolunteeringServices(
    FetchVolunteeringServices event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingVolunteeringServices: true, volunteeringServicesList: []));
    final result = await getVolunteeringServices(event.parentId);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingVolunteeringServices: false, errorMessage: 'failed_to_load_volunteering_services'.tr()),
      ),
      (services) => emit(state.copyWith(isLoadingVolunteeringServices: false, volunteeringServicesList: services)),
    );
  }

  void _onUpdatePersonalInfo(
    UpdatePersonalInfo event,
    Emitter<VolunteerProfileState> emit,
  ) {
    emit(state.copyWith(
      firstName: event.firstName ?? state.firstName,
      middleName: event.middleName ?? state.middleName,
      lastName: event.lastName ?? state.lastName,
      email: event.email ?? state.email,
      phoneNumber: event.phoneNumber ?? state.phoneNumber,
      nationalId: event.nationalId ?? state.nationalId,
      dateOfBirth: event.dateOfBirth ?? state.dateOfBirth,
      nationality: event.nationality ?? state.nationality,
      gender: event.gender ?? state.gender,
      maritalStatus: event.maritalStatus ?? state.maritalStatus,
      maritalStatusId: event.maritalStatusId ?? state.maritalStatusId,
      nearbyPhoneNumber: event.nearbyPhoneNumber ?? state.nearbyPhoneNumber,
      region: event.region ?? state.region,
      regionId: event.regionId ?? state.regionId,
      city: event.city ?? state.city,
      cityId: event.cityId ?? state.cityId,
    ));
  }

  void _onUpdateAddressInfo(
    UpdateAddressInfo event,
    Emitter<VolunteerProfileState> emit,
  ) {
    emit(state.copyWith(
      city: event.city,
      district: event.district,
      street: event.street,
      additionalInfo: event.additionalInfo,
    ));
  }

  void _onUpdateVolunteerInfo(
    UpdateVolunteerInfo event,
    Emitter<VolunteerProfileState> emit,
  ) {
    emit(state.copyWith(
      skills: event.skills,
      interests: event.interests,
      previousExperience: event.previousExperience,
      hasCar: event.hasCar,
      canTravel: event.canTravel,
    ));
  }

  void _onUpdateVolunteeringInterests(
    UpdateVolunteeringInterests event,
    Emitter<VolunteerProfileState> emit,
  ) {
    // Determine individual and group selections
    final bool isIndividualSelected =
        event.isIndividualSelected ?? state.isIndividualSelected;
    final bool isGroupSelected = event.isGroupSelected ?? state.isGroupSelected;

    // Determine the correct volunteeringType and volunteeringTypeId based on selection combination
    String? volunteeringType;
    String? volunteeringTypeId;

    if (isIndividualSelected && isGroupSelected) {
      // Both selected - use combined value
      volunteeringType = 'جماعي/فردي';
      volunteeringTypeId = '53';
    } else if (isIndividualSelected) {
      // Only individual selected
      volunteeringType = 'individual';
      // Find the individual type ID from volunteeringFieldsList or use a default
      // You may need to adjust this based on your actual API values
      volunteeringTypeId = null; // Will be determined when we fetch lookup data
    } else if (isGroupSelected) {
      // Only group selected
      volunteeringType = 'group';
      // Find the group type ID from volunteeringFieldsList or use a default
      // You may need to adjust this based on your actual API values
      volunteeringTypeId = null; // Will be determined when we fetch lookup data
    } else {
      // Neither selected
      volunteeringType = null;
      volunteeringTypeId = null;
    }

    emit(state.copyWith(
      skills: event.skills ?? state.skills,
      skillsIds: event.skillsIds ?? state.skillsIds,
      interests: event.interests ?? state.interests,
      volunteeringLevel: event.volunteeringLevel ?? state.volunteeringLevel,
      volunteeringLevelId:
          event.volunteeringLevelId ?? state.volunteeringLevelId,
      volunteeringWorkField:
          event.volunteeringWorkField == null && event.volunteeringDomainServiceId != null
              ? null
              : event.volunteeringWorkField ?? state.volunteeringWorkField,
      volunteeringWorkFieldId:
          event.volunteeringWorkFieldId == null && event.volunteeringDomainServiceId != null
              ? null
              : event.volunteeringWorkFieldId ?? state.volunteeringWorkFieldId,
        volunteeringService: event.volunteeringService ?? state.volunteeringService,
        volunteeringServiceId: event.volunteeringServiceId ?? state.volunteeringServiceId,
        volunteeringDomainServiceId: event.volunteeringDomainServiceId ?? state.volunteeringDomainServiceId,
        volunteeringDomainServiceNames: event.volunteeringDomainServiceNames ?? state.volunteeringDomainServiceNames,
      volunteeringType: volunteeringType,
      volunteeringTypeId: volunteeringTypeId,
      isIndividualSelected: isIndividualSelected,
      isGroupSelected: isGroupSelected,
      previousExperience: event.previousExperience ?? state.previousExperience,
      hasCar: event.hasCar ?? state.hasCar,
      canTravel: event.canTravel ?? state.canTravel,
    ));
  }

  void _onUpdateMedicalInfo(
    UpdateMedicalInfo event,
    Emitter<VolunteerProfileState> emit,
  ) {
    emit(state.copyWith(
      bloodType: event.bloodType ?? state.bloodType,
      bloodTypeId: event.bloodTypeId ?? state.bloodTypeId,
      disease: event.disease ?? state.disease,
      diseaseId: event.diseaseId ?? state.diseaseId,
    ));
  }

  void _onUpdateSocialMediaInfo(
    UpdateSocialMediaInfo event,
    Emitter<VolunteerProfileState> emit,
  ) {
    emit(state.copyWith(
      xAccount: event.xAccount ?? state.xAccount,
      instagramAccount: event.instagramAccount ?? state.instagramAccount,
      linkedinAccount: event.linkedinAccount ?? state.linkedinAccount,
      facebookAccount: event.facebookAccount ?? state.facebookAccount,
    ));
  }

  void _onSwitchToPresentationMode(
    SwitchToPresentationMode event,
    Emitter<VolunteerProfileState> emit,
  ) {
    emit(state.copyWith(isPresentationMode: event.isPresentationMode));
  }

  Future<void> _onFetchBloodTypes(
    FetchBloodTypes event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingBloodTypes: true, bloodTypesList: []));
    final result = await getBloodTypes(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingBloodTypes: false,
          errorMessage: 'failed_to_load_blood_types'.tr())),
      (bloodTypes) => emit(state.copyWith(
          isLoadingBloodTypes: false, bloodTypesList: bloodTypes)),
    );
  }

  Future<void> _onFetchDiseases(
    FetchDiseases event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingDiseases: true, diseasesList: []));
    final result = await getDiseases(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          isLoadingDiseases: false,
          errorMessage: 'failed_to_load_diseases'.tr())),
      (diseases) => emit(
          state.copyWith(isLoadingDiseases: false, diseasesList: diseases)),
    );
  }

  void _onUpdateScientificInfo(
    UpdateScientificInfo event,
    Emitter<VolunteerProfileState> emit,
  ) {
    emit(state.copyWith(
      educationalQualification:
          event.educationalQualification ?? state.educationalQualification,
      educationalQualificationId:
          event.educationalQualificationId ?? state.educationalQualificationId,
      specialization: event.specialization ?? state.specialization,
      specializationId: event.specializationId ?? state.specializationId,
      profession: event.profession ?? state.profession,
      workExperience: event.workExperience ?? state.workExperience,
      language: event.language ?? state.language,
      languageId: event.languageId ?? state.languageId,
      scientificExperienceSummary: event.scientificExperienceSummary ??
          state.scientificExperienceSummary,
    ));
  }

  Future<void> _onSubmitVolunteerProfile(
    SubmitVolunteerProfile event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    if (
        // !state.isPersonalInfoValid ||
        //   !state.isScientificInfoValid ||
        //   !state.isVolunteeringInterestsValid ||
        //   !state.isMedicalInfoValid ||
        //   !state.isSocialMediaInfoValid ||
        !state.isUnifiedStepValid) {
      emit(
          state.copyWith(errorMessage: 'please_fill_all_required_fields'.tr()));
      return;
    }
    emit(state.copyWith(isSubmitting: true));

    try {
      // Build profile data based on the API structure - using IDs instead of names
      final profileData = <String, dynamic>{
        'type': 'volunteer',
        'email': state.email,
        'phone': state.phoneNumber,
        'secondPhone': state.nearbyPhoneNumber,
        'maritalStatus': state.maritalStatusId, // Use ID instead of name
        'city': state.cityId,
        'region': state.regionId,
        'xLink': state.xAccount,
        'instagramAccount': state.instagramAccount,
        'facebookAccount': state.facebookAccount,
        'linkedInAccount': state.linkedinAccount,
        'qualification':
            state.educationalQualificationId, // Use ID instead of name
        'ademicQualification': state
            .educationalQualificationId, // Note: API has typo "ademicQualification"
        'specialization': state.specializationId, // Use ID instead of name
        'scientificExpertise':
            state.workExperience, // Years of experience (0-50)
        'breif': state.scientificExperienceSummary,
        'job': state.profession,
        'bloodType': state.bloodTypeId, // Use ID instead of name
        'diseases': state.diseaseId, // Use ID instead of name
        'volunteeringLevel':
            state.volunteeringLevelId, // Use ID instead of name
        'volunteeringType': state.volunteeringTypeId, // Use ID instead of name
        'languages': state.languageId, // Use ID instead of name
        'skills': state.skillsIds.isNotEmpty
            ? state.skillsIds.first
            : null, // Use ID instead of name
        'volunteering': state.volunteeringServiceId, // Use ID instead of name
        'volunteerCV': state.cvFileId?.toString(),
      };

      // Remove null values to avoid sending empty fields
      profileData.removeWhere((key, value) => value == null || value == '');

      // Use the profile ID from the loaded profile
      final profileId = state.profileId;

      if (profileId == null || profileId.isEmpty) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'profile_id_not_found'.tr(),
        ));
        return;
      }

      final result = await submitProfile(SubmitProfileParams(
        profileData: profileData,
        profileId: profileId,
      ));

      result.fold(
        (failure) => emit(state.copyWith(
          isSubmitting: false,
          errorMessage:
              '${'failed_to_submit_profile'.tr()}: ${failure.toString()}',
        )),
        (_) => emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: '${'failed_to_submit_profile'.tr()}: $e',
      ));
    }
  }

  Future<void> _onUpdateVolunteerProfile(
    UpdateVolunteerProfile event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      // Build profile data based on the API structure - using IDs instead of names
      final profileData = <String, dynamic>{
        'type': 'volunteer',
        'email': state.email,
        'phone': state.phoneNumber,
        'secondPhone': state.nearbyPhoneNumber,
        'maritalStatus': state.maritalStatusId, // Use ID instead of name
        'city': state.cityId,
        'region': state.regionId,
        'xLink': state.xAccount,
        'instagramAccount': state.instagramAccount,
        'facebookAccount': state.facebookAccount,
        'linkedInAccount': state.linkedinAccount,
        'qualification':
            state.educationalQualificationId, // Use ID instead of name
        'ademicQualification': state
            .educationalQualificationId, // Note: API has typo "ademicQualification"
        'specialization': state.specializationId, // Use ID instead of name
        'scientificExpertise':
            state.workExperience, // Years of experience (0-50)
        'breif': state.scientificExperienceSummary,
        'job': state.profession,
        'bloodType': state.bloodTypeId, // Use ID instead of name
        'diseases': state.diseaseId, // Use ID instead of name
        'volunteeringLevel':
            state.volunteeringLevelId, // Use ID instead of name
        'volunteeringType': state.volunteeringTypeId, // Use ID instead of name
        'languages': state.languageId, // Use ID instead of name
        'skills': state.skillsIds.isNotEmpty
            ? state.skillsIds.first
            : null, // Use ID instead of name
        'volunteering': state.volunteeringWorkFieldId, // Use ID instead of name
        'volunteerCV': state.cvFileId?.toString(),
      };

      // Remove null values to avoid sending empty fields
      profileData.removeWhere((key, value) => value == null || value == '');

      // Use the profile ID from the loaded profile
      final profileId = state.profileId;

      if (profileId == null || profileId.isEmpty) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'profile_id_not_found'.tr(),
        ));
        return;
      }

      final result = await submitProfile(SubmitProfileParams(
        profileData: profileData,
        profileId: profileId,
      ));

      result.fold(
        (failure) => emit(state.copyWith(
          isSubmitting: false,
          errorMessage:
              '${'failed_to_update_profile'.tr()}: ${failure.toString()}',
        )),
        (_) => emit(state.copyWith(
          isSubmitting: false,
          // Note: NOT setting isSuccess to true to avoid triggering the success dialog
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: '${'failed_to_update_profile'.tr()}: $e',
      ));
    }
  }

  void _onChangeStep(
    ChangeStep event,
    Emitter<VolunteerProfileState> emit,
  ) {
    if (event.step < 0 || event.step > 5) {
      return;
    }

    // Always emit step change first
    emit(state.copyWith(currentStep: event.step));

    // Check if we need to fetch data for scientific info step (step 1)
    if (event.step == 1) {
      final needsQualifications =
          state.qualificationsList.isEmpty && !state.isLoadingQualifications;
      final needsSpecializations =
          state.specializationsList.isEmpty && !state.isLoadingSpecializations;
      final needsLanguages =
          state.languagesList.isEmpty && !state.isLoadingLanguages;

      // Trigger fetch events instead of calling async methods directly
      if (needsQualifications) {
        add(const FetchQualifications());
      }
      if (needsSpecializations) {
        add(const FetchSpecializations());
      }
      if (needsLanguages) {
        add(const FetchLanguages());
      }
    }
    // Check if we need to fetch data for volunteering interests step (step 2)
    else if (event.step == 2) {
      final needsSkills = state.skillsList.isEmpty && !state.isLoadingSkills;
      final needsLvls = state.lvlsList.isEmpty && !state.isLoadingLvls;
      final needsInterests =
          state.interestsList.isEmpty && !state.isLoadingInterests;
      final needsVolunteeringFields = state.volunteeringFieldsList.isEmpty &&
          !state.isLoadingVolunteeringFields;

      // Trigger fetch events instead of calling async methods directly
      if (needsSkills) {
        add(const FetchSkills());
      }
      if (needsLvls) {
        add(const FetchLvls());
      }
      if (needsInterests) {
        add(const FetchInterests());
      }
      if (needsVolunteeringFields) {
        add(const FetchVolunteeringFields());
      }
    }
    // Check if we need to fetch data for medical info step (step 3)
    else if (event.step == 3) {
      final needsBloodTypes =
          state.bloodTypesList.isEmpty && !state.isLoadingBloodTypes;
      final needsDiseases =
          state.diseasesList.isEmpty && !state.isLoadingDiseases;

      // Trigger fetch events instead of calling async methods directly
      if (needsBloodTypes) {
        add(const FetchBloodTypes());
      }
      if (needsDiseases) {
        add(const FetchDiseases());
      }
    }
  }

  Future<void> _onUploadCVFile(
    UploadCVFile event,
    Emitter<VolunteerProfileState> emit,
  ) async {
    emit(state.copyWith(isUploadingCV: true));

    final fileDataItem = FileDataItem(
      fileName: event.fileName,
      filePath: event.filePath,
      fileBase64: '', // We'll use the file path directly for binary upload
    );

    final result = await uploadCV(fileDataItem);

    result.fold(
      (failure) => emit(state.copyWith(
        isUploadingCV: false,
        cvUploadMessage: '${'failed_to_upload_cv'.tr()}: ${failure.toString()}',
      )),
      (response) => emit(state.copyWith(
        isUploadingCV: false,
        cvFileName: response.fileName ?? event.fileName,
        cvFileUrl: response.fileUrl,
        cvFileId: response.fileId, // Store fid for final submission
        cvUploadMessage: 'cv_uploaded_successfully'.tr(),
      )),
    );
  }
}
