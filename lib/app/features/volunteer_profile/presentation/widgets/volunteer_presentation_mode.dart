import 'dart:async';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../bloc/volunteer_profile_bloc.dart';
import '../bloc/volunteer_profile_event.dart';
import '../bloc/volunteer_profile_state.dart';


class VolunteerPresentationMode extends StatefulWidget {
  final bool isEditMode;

  const VolunteerPresentationMode({
    Key? key,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<VolunteerPresentationMode> createState() =>
      _VolunteerPresentationModeState();

  // Static method to handle cancel logic
  static void cancelEditMode(BuildContext context, VolunteerProfileBloc bloc,
      Map<String, dynamic> originalValues) {
    print('Static cancelEditMode called');

    // Restore original values
    bloc
      ..add(UpdatePersonalInfo(
        email: originalValues['email'],
        phoneNumber: originalValues['phoneNumber'],
        nationalId: bloc.state.nationalId,
        gender: bloc.state.gender,
        maritalStatus: bloc.state.maritalStatus,
        nearbyPhoneNumber: originalValues['nearbyPhoneNumber'],
        region: originalValues['region'],
        regionId: originalValues['regionId'],
        city: originalValues['city'],
        cityId: originalValues['cityId'],
      ))
      ..add(UpdateScientificInfo(
        educationalQualification: originalValues['educationalQualification'],
        educationalQualificationId:
            originalValues['educationalQualificationId'],
        specialization: originalValues['specialization'],
        specializationId: originalValues['specializationId'],
        profession: originalValues['profession'],
        workExperience: originalValues['workExperience'],
        language: originalValues['language'],
        languageId: originalValues['languageId'],
        scientificExperienceSummary:
            originalValues['scientificExperienceSummary'],
      ))
      ..add(UpdateVolunteeringInterests(
        skills:
            originalValues['skills'] != null ? [originalValues['skills']] : [],
        skillsIds: originalValues['skillsIds'] != null
            ? [originalValues['skillsIds']]
            : [],
        volunteeringLevel: originalValues['volunteeringLevel'],
        volunteeringLevelId: originalValues['volunteeringLevelId'],
        volunteeringWorkField: originalValues['volunteeringWorkField'],
        volunteeringWorkFieldId: originalValues['volunteeringWorkFieldId'],
        isIndividualSelected: originalValues['isIndividualSelected'],
        isGroupSelected: originalValues['isGroupSelected'],
      ))
      ..add(UpdateMedicalInfo(
        bloodType: originalValues['bloodType'],
        bloodTypeId: originalValues['bloodTypeId'],
        disease: originalValues['disease'],
        diseaseId: originalValues['diseaseId'],
      ))
      ..add(UpdateSocialMediaInfo(
        xAccount: originalValues['xAccount'],
        instagramAccount: originalValues['instagramAccount'],
        linkedinAccount: originalValues['linkedinAccount'],
        facebookAccount: originalValues['facebookAccount'],
      ));
  }
}

class _VolunteerPresentationModeState extends State<VolunteerPresentationMode> {
  // Track expanded state for each section
  bool _isPersonalInfoExpanded = true;
  bool _isScientificInfoExpanded = false;
  bool _isVolunteeringInterestsExpanded = false;
  bool _isMedicalInfoExpanded = false;
  bool _isSocialMediaInfoExpanded = false;

  // Edit mode state
  late bool _isEditMode;

  // Store original values for cancel functionality
  late String? _originalEmail;
  late String? _originalPhoneNumber;
  late String? _originalNearbyPhoneNumber;
  late String? _originalProfession;
  late String? _originalScientificExperienceSummary;
  late String? _originalXAccount;
  late String? _originalInstagramAccount;
  late String? _originalLinkedinAccount;
  late String? _originalFacebookAccount;
  late String? _originalCity;
  late String? _originalCityId;
  late String? _originalRegion;
  late String? _originalRegionId;

  // Store original dropdown values
  late String? _originalEducationalQualification;
  late String? _originalEducationalQualificationId;
  late String? _originalSpecialization;
  late String? _originalSpecializationId;
  late String? _originalLanguage;
  late String? _originalLanguageId;
  late String? _originalWorkExperience;
  late String? _originalSkills;
  late String? _originalSkillsIds;
  late String? _originalVolunteeringLevel;
  late String? _originalVolunteeringLevelId;
  late String? _originalInterests;
  late String? _originalVolunteeringWorkField;
  late String? _originalVolunteeringWorkFieldId;
  late bool _originalIsIndividualSelected;
  late bool _originalIsGroupSelected;
  late String? _originalBloodType;
  late String? _originalBloodTypeId;
  late String? _originalDisease;
  late String? _originalDiseaseId;

  // Form controllers for editable fields
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nearbyPhoneController;
  late TextEditingController _professionController;
  late TextEditingController _scientificExperienceController;
  late TextEditingController _xAccountController;
  late TextEditingController _instagramController;
  late TextEditingController _linkedinController;
  late TextEditingController _facebookController;

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.isEditMode;
    print(
        'initState - isEditMode: $_isEditMode, widget.isEditMode: ${widget.isEditMode}');
    _initializeControllers();
    // Initial validation
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _nearbyPhoneController.addListener(_validateForm);
    _professionController.addListener(_validateForm);
    _scientificExperienceController.addListener(_validateForm);
  }

  void _initializeControllers() {
    final state = sl<VolunteerProfileBloc>().state;

    // Initialize controllers
    _emailController = TextEditingController(text: state.email ?? '');
    _phoneController = TextEditingController(text: state.phoneNumber ?? '');
    _nearbyPhoneController =
        TextEditingController(text: state.nearbyPhoneNumber ?? '');
    _professionController = TextEditingController(text: state.profession ?? '');
    _scientificExperienceController =
        TextEditingController(text: state.scientificExperienceSummary ?? '');
    _xAccountController = TextEditingController(text: state.xAccount ?? '');
    _instagramController =
        TextEditingController(text: state.instagramAccount ?? '');
    _linkedinController =
        TextEditingController(text: state.linkedinAccount ?? '');
    _facebookController =
        TextEditingController(text: state.facebookAccount ?? '');

    // Store original values if in edit mode
    if (_isEditMode) {
      print('Initializing in edit mode - storing original values');
      _storeOriginalValues(state);
    }
  }

  void _storeOriginalValues(VolunteerProfileState state) {
    _originalEmail = state.email;
    _originalPhoneNumber = state.phoneNumber;
    _originalNearbyPhoneNumber = state.nearbyPhoneNumber;
    _originalProfession = state.profession;
    _originalScientificExperienceSummary = state.scientificExperienceSummary;
    _originalXAccount = state.xAccount;
    _originalInstagramAccount = state.instagramAccount;
    _originalLinkedinAccount = state.linkedinAccount;
    _originalFacebookAccount = state.facebookAccount;
    _originalCity = state.city;
    _originalCityId = state.cityId;
    _originalRegion = state.region;
    _originalRegionId = state.regionId;

    // Store original dropdown values
    _originalEducationalQualification = state.educationalQualification;
    _originalEducationalQualificationId = state.educationalQualificationId;
    _originalSpecialization = state.specialization;
    _originalSpecializationId = state.specializationId;
    _originalLanguage = state.language;
    _originalLanguageId = state.languageId;
    _originalWorkExperience = state.workExperience;
    _originalSkills = state.skills.isNotEmpty ? state.skills.join(', ') : null;
    _originalSkillsIds =
        state.skillsIds.isNotEmpty ? state.skillsIds.first : null;
    _originalVolunteeringLevel = state.volunteeringLevel;
    _originalVolunteeringLevelId = state.volunteeringLevelId;
    _originalInterests =
        state.interests.isNotEmpty ? state.interests.join(', ') : null;
    _originalVolunteeringWorkField = state.volunteeringWorkField;
    _originalVolunteeringWorkFieldId = state.volunteeringWorkFieldId;
    _originalIsIndividualSelected = state.isIndividualSelected;
    _originalIsGroupSelected = state.isGroupSelected;
    _originalBloodType = state.bloodType;
    _originalBloodTypeId = state.bloodTypeId;
    _originalDisease = state.disease;
    _originalDiseaseId = state.diseaseId;

    // Debug: Print original values
    print('Stored original city: $_originalCity, cityId: $_originalCityId');
    print(
        'Stored original region: $_originalRegion, regionId: $_originalRegionId');
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _phoneController.removeListener(_validateForm);
    _nearbyPhoneController.removeListener(_validateForm);
    _professionController.removeListener(_validateForm);
    _scientificExperienceController.removeListener(_validateForm);
    super.dispose();
  }

  void _saveChanges() {
    final bloc = context.read<VolunteerProfileBloc>();
    final currentState = bloc.state;

    // Update personal info with editable fields
    bloc
      ..add(UpdatePersonalInfo(
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        nationalId: currentState.nationalId,
        gender: currentState.gender,
        maritalStatus: currentState.maritalStatus,
        nearbyPhoneNumber: _nearbyPhoneController.text,
        region: currentState.region,
        regionId: currentState.regionId,
        city: currentState.city,
        cityId: currentState.cityId,
      ))

      // Update scientific info
      ..add(UpdateScientificInfo(
        educationalQualification: currentState.educationalQualification,
        educationalQualificationId: currentState.educationalQualificationId,
        specialization: currentState.specialization,
        specializationId: currentState.specializationId,
        profession: _professionController.text,
        workExperience: currentState.workExperience,
        language: currentState.language,
        languageId: currentState.languageId,
        scientificExperienceSummary: _scientificExperienceController.text,
      ))

      // Update social media info
      ..add(UpdateSocialMediaInfo(
        xAccount: _xAccountController.text,
        instagramAccount: _instagramController.text,
        linkedinAccount: _linkedinController.text,
        facebookAccount: _facebookController.text,
      ))

      // Update the profile on the server without triggering success dialog
      ..add(const UpdateVolunteerProfile());

    // Exit edit mode
    setState(() {
      _isEditMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('volunteer_profile_submit_success'.tr()),
        backgroundColor: const Color(0xFF00796B),
      ),
    );

    // Exit the entire volunteer profile flow after saving
    Navigator.of(context).pop();
  }

  void _cancelEdit() {
    // Debug: Print what we're restoring
    print('Restoring city to: $_originalCity, cityId: $_originalCityId');
    print(
        'Restoring region to: $_originalRegion, regionId: $_originalRegionId');

    // Reset controllers to original values
    _emailController.text = _originalEmail ?? '';
    _phoneController.text = _originalPhoneNumber ?? '';
    _nearbyPhoneController.text = _originalNearbyPhoneNumber ?? '';
    _professionController.text = _originalProfession ?? '';
    _scientificExperienceController.text =
        _originalScientificExperienceSummary ?? '';
    _xAccountController.text = _originalXAccount ?? '';
    _instagramController.text = _originalInstagramAccount ?? '';
    _linkedinController.text = _originalLinkedinAccount ?? '';
    _facebookController.text = _originalFacebookAccount ?? '';

    // Reset bloc state to original values
    final bloc = context.read<VolunteerProfileBloc>();

    // Update personal info with ALL original values
    bloc
      ..add(UpdatePersonalInfo(
        email: _originalEmail,
        phoneNumber: _originalPhoneNumber,
        nationalId: bloc.state.nationalId,
        gender: bloc.state.gender,
        maritalStatus: bloc.state.maritalStatus,
        nearbyPhoneNumber: _originalNearbyPhoneNumber,
        region: _originalRegion,
        regionId: _originalRegionId,
        city: _originalCity,
        cityId: _originalCityId,
      ))

      // Update scientific info
      ..add(UpdateScientificInfo(
        educationalQualification: _originalEducationalQualification,
        educationalQualificationId: _originalEducationalQualificationId,
        specialization: _originalSpecialization,
        specializationId: _originalSpecializationId,
        profession: _originalProfession,
        workExperience: _originalWorkExperience,
        language: _originalLanguage,
        languageId: _originalLanguageId,
        scientificExperienceSummary: _originalScientificExperienceSummary,
      ))

      // Update volunteering interests
      ..add(UpdateVolunteeringInterests(
        skills: _originalSkills != null ? [_originalSkills!] : [],
        skillsIds: _originalSkillsIds != null ? [_originalSkillsIds!] : [],
        volunteeringLevel: _originalVolunteeringLevel,
        volunteeringLevelId: _originalVolunteeringLevelId,
        volunteeringWorkField: _originalVolunteeringWorkField,
        volunteeringWorkFieldId: _originalVolunteeringWorkFieldId,
        isIndividualSelected: _originalIsIndividualSelected,
        isGroupSelected: _originalIsGroupSelected,
      ))

      // Update medical info
      ..add(UpdateMedicalInfo(
        bloodType: _originalBloodType,
        bloodTypeId: _originalBloodTypeId,
        disease: _originalDisease,
        diseaseId: _originalDiseaseId,
      ))

      // Update social media info
      ..add(UpdateSocialMediaInfo(
        xAccount: _originalXAccount,
        instagramAccount: _originalInstagramAccount,
        linkedinAccount: _originalLinkedinAccount,
        facebookAccount: _originalFacebookAccount,
      ));
  }

  Future<void> _pickAndUploadFile(BuildContext context) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          // Check file size (limit to 10MB)
          if (file.size > 10 * 1024 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('file_size_too_large'.tr()),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Trigger upload
          context.read<VolunteerProfileBloc>().add(
                UploadCVFile(
                  filePath: file.path!,
                  fileName: file.name,
                ),
              );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'failed_to_select_file'.tr()}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _validateForm() {
    final state = context.read<VolunteerProfileBloc>().state;
    // Personal Info
    final isEmailValid = Helpers.validateEmail(_emailController.text) == null &&
        _emailController.text.trim().isNotEmpty;
    final isPhoneValid =
        Helpers.validateMobile(_phoneController.text) == null &&
            _phoneController.text.trim().isNotEmpty;
    final isRegionValid = state.regionId != null && state.regionId!.isNotEmpty;
    final isCityValid = state.cityId != null && state.cityId!.isNotEmpty;
    // Scientific Info
    final isQualificationValid = state.educationalQualificationId != null &&
        state.educationalQualificationId!.isNotEmpty;
    final isSpecializationValid =
        state.specializationId != null && state.specializationId!.isNotEmpty;
    final isLanguageValid =
        state.languageId != null && state.languageId!.isNotEmpty;
    final isScientificSummaryValid =
        _scientificExperienceController.text.trim().isNotEmpty;
    // Volunteering Interests
    final isSkillsValid =
        state.skillsIds.isNotEmpty && state.skillsIds.first.isNotEmpty;
    final isVolunteeringLevelValid = state.volunteeringLevelId != null &&
        state.volunteeringLevelId!.isNotEmpty;
    final isVolunteeringWorkFieldValid =
        state.volunteeringWorkFieldId != null &&
            state.volunteeringWorkFieldId!.isNotEmpty;
    final isTypeValid = state.isIndividualSelected || state.isGroupSelected;
    // All required fields must be valid
    final valid = isEmailValid &&
        isPhoneValid &&
        isRegionValid &&
        isCityValid &&
        isQualificationValid &&
        isSpecializationValid &&
        isLanguageValid &&
        isScientificSummaryValid &&
        isSkillsValid &&
        isVolunteeringLevelValid &&
        isVolunteeringWorkFieldValid &&
        isTypeValid;
    if (_isFormValid != valid) {
      setState(() {
        _isFormValid = valid;
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<VolunteerProfileBloc, VolunteerProfileState>(
        listener: (context, state) {
          // Update controllers when state changes (for state restoration)
          if (_isEditMode) {
            _emailController.text = state.email ?? '';
            _phoneController.text = state.phoneNumber ?? '';
            _nearbyPhoneController.text = state.nearbyPhoneNumber ?? '';
            _professionController.text = state.profession ?? '';
            _scientificExperienceController.text =
                state.scientificExperienceSummary ?? '';
            _xAccountController.text = state.xAccount ?? '';
            _instagramController.text = state.instagramAccount ?? '';
            _linkedinController.text = state.linkedinAccount ?? '';
            _facebookController.text = state.facebookAccount ?? '';
            // Validate form on any Bloc state change (for dropdowns/checkboxes)
            // _validateForm();
          }
        },
        child: BlocBuilder<VolunteerProfileBloc, VolunteerProfileState>(
          builder: (context, state) => PopScope(
            canPop: !_isEditMode, // Prevent pop only in edit mode
            onPopInvokedWithResult: (didPop, result) {
              print(
                  'PopScope triggered - didPop: $didPop, isEditMode: $_isEditMode, canPop: ${!_isEditMode}');
              if (!didPop && _isEditMode) {
                print('Canceling edit mode...');
                // Exit edit mode when back button is pressed
                _cancelEdit();
                Navigator.of(context).pop();
              } else {
                print(
                    'Not canceling - didPop: $didPop, isEditMode: $_isEditMode');
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personal Information Section
                        _buildExpandableSection(
                          title: 'lbl_personal_info'.tr(),
                          isExpanded: _isPersonalInfoExpanded,
                          onToggle: () => setState(() =>
                              _isPersonalInfoExpanded =
                                  !_isPersonalInfoExpanded),
                          children: _buildPersonalInfoRows(state),
                        ),

                        const SizedBox(height: 16),

                        // Scientific Information Section
                        _buildExpandableSection(
                          title: 'lbl_scientific_info'.tr(),
                          isExpanded: _isScientificInfoExpanded,
                          onToggle: () => setState(() =>
                              _isScientificInfoExpanded =
                                  !_isScientificInfoExpanded),
                          children: _buildScientificInfoRows(state),
                        ),

                        const SizedBox(height: 16),

                        // Volunteering Interests Section
                        _buildExpandableSection(
                          title: 'lbl_volunteering_interests'.tr(),
                          isExpanded: _isVolunteeringInterestsExpanded,
                          onToggle: () => setState(() =>
                              _isVolunteeringInterestsExpanded =
                                  !_isVolunteeringInterestsExpanded),
                          children: _buildVolunteeringInterestsRows(state),
                        ),

                        const SizedBox(height: 16),

                        // Medical Information Section
                        _buildExpandableSection(
                          title: 'medical_information'.tr(),
                          isExpanded: _isMedicalInfoExpanded,
                          onToggle: () => setState(() =>
                              _isMedicalInfoExpanded = !_isMedicalInfoExpanded),
                          children: _buildMedicalInfoRows(state),
                        ),

                        const SizedBox(height: 16),

                        // Social Media Information Section
                        _buildExpandableSection(
                          title: 'lbl_social_media_info'.tr(),
                          isExpanded: _isSocialMediaInfoExpanded,
                          onToggle: () => setState(() =>
                              _isSocialMediaInfoExpanded =
                                  !_isSocialMediaInfoExpanded),
                          children: _buildSocialMediaRows(state),
                        ),

                        const SizedBox(height: 24), // Bottom spacing
                      ],
                    ),
                  ),
                ),
                if (_isEditMode) _buildSaveButton(),
              ],
            ),
          ),
        ),
      );

  List<Widget> _buildPersonalInfoRows(VolunteerProfileState state) => [
        // Read-only fields (locked)
        _buildInfoRow('national_id'.tr(), state.nationalId ?? '',
            isReadOnly: true),
        _buildInfoRow('full_name'.tr(), state.fullName ?? '', isReadOnly: true),
        _buildInfoRow('lbl_first_name_hint1'.tr(), state.firstName ?? '',
            isReadOnly: true),
        _buildInfoRow('ekram_second_name'.tr(), state.middleName ?? '',
            isReadOnly: true),
        _buildInfoRow('last_name'.tr(), state.lastName ?? '', isReadOnly: true),
        _buildInfoRow('lbl_birth_date'.tr(), state.dateOfBirth ?? '',
            isReadOnly: true),
        _buildInfoRow('personal_gender'.tr(), state.gender ?? '',
            isReadOnly: true),
        _buildInfoRow('nationality'.tr(), state.nationality ?? '',
            isReadOnly: true),
        _buildInfoRow('marital_status'.tr(), state.maritalStatus ?? '',
            isReadOnly: true),

        // Editable fields
        _buildEditableInfoRow('email'.tr(), _emailController,
            keyboardType: TextInputType.emailAddress),
        _buildEditableInfoRow('personal_mobile'.tr(), _phoneController,
            keyboardType: TextInputType.phone),
        _buildEditableInfoRow(
            'relative_phone_number'.tr(), _nearbyPhoneController,
            keyboardType: TextInputType.phone),

        // Location fields - editable in edit mode via dropdowns
        _buildLocationRow('region'.tr(), state.region ?? '',
            isRegion: true, state: state),
        _buildLocationRow('city'.tr(), state.city ?? '',
            isRegion: false, state: state, isLast: true),
      ];

  List<Widget> _buildScientificInfoRows(VolunteerProfileState state) => [
        // Educational Qualification - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'educational_qualification_required'.tr(),
          state.educationalQualification ?? 'not_selected'.tr(),
          _isEditMode ? state.qualificationsList : null,
          state.educationalQualificationId,
          (value) {
            if (value != null) {
              final selectedQualification = state.qualificationsList.firstWhere(
                (qualification) => qualification.tid.toString() == value,
              );
              context.read<VolunteerProfileBloc>().add(
                    UpdateScientificInfo(
                      educationalQualification: selectedQualification.name,
                      educationalQualificationId: value,
                      specialization: state.specialization,
                      specializationId: state.specializationId,
                      profession: state.profession,
                      workExperience: state.workExperience,
                      language: state.language,
                      languageId: state.languageId,
                      scientificExperienceSummary:
                          state.scientificExperienceSummary,
                    ),
                  );
            }
          },
        ),

        // Specialization - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'specialization_required'.tr(),
          state.specialization ?? 'not_selected'.tr(),
          _isEditMode ? state.specializationsList : null,
          state.specializationId,
          (value) {
            if (value != null) {
              final selectedSpecialization =
                  state.specializationsList.firstWhere(
                (specialization) => specialization.tid.toString() == value,
              );
              context.read<VolunteerProfileBloc>().add(
                    UpdateScientificInfo(
                      educationalQualification: state.educationalQualification,
                      educationalQualificationId:
                          state.educationalQualificationId,
                      specialization: selectedSpecialization.name,
                      specializationId: value,
                      profession: state.profession,
                      workExperience: state.workExperience,
                      language: state.language,
                      languageId: state.languageId,
                      scientificExperienceSummary:
                          state.scientificExperienceSummary,
                    ),
                  );
            }
          },
        ),

        // Profession - editable text field
        _buildEditableInfoRow('profession'.tr(), _professionController),

        // Work Experience - dropdown in edit mode
        _buildWorkExperienceRow(state),

        // Language - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'language_required'.tr(),
          state.language ?? 'not_selected'.tr(),
          _isEditMode ? state.languagesList : null,
          state.languageId,
          (value) {
            if (value != null) {
              final selectedLanguage = state.languagesList.firstWhere(
                (language) => language.tid.toString() == value,
              );
              context.read<VolunteerProfileBloc>().add(
                    UpdateScientificInfo(
                      educationalQualification: state.educationalQualification,
                      educationalQualificationId:
                          state.educationalQualificationId,
                      specialization: state.specialization,
                      specializationId: state.specializationId,
                      profession: state.profession,
                      workExperience: state.workExperience,
                      language: selectedLanguage.name,
                      languageId: value,
                      scientificExperienceSummary:
                          state.scientificExperienceSummary,
                    ),
                  );
            }
          },
        ),

        // Scientific Experience Summary - editable text field
        _buildEditableInfoRow('scientific_experience_summary_required'.tr(),
            _scientificExperienceController,
            maxLines: 3),

        // CV file status
        _buildCVUploadRow(state),
      ];

  List<Widget> _buildVolunteeringInterestsRows(VolunteerProfileState state) => [
        // Skills - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'skills_required'.tr(),
          state.skills.isNotEmpty
              ? state.skills.join(', ')
              : 'not_selected'.tr(),
          _isEditMode ? state.skillsList : null,
          state.skillsIds.isNotEmpty ? state.skillsIds.first : null,
          (value) {
            if (value != null) {
              final selectedSkill = state.skillsList.firstWhere(
                (skill) => skill.tid.toString() == value,
              );
              context.read<VolunteerProfileBloc>().add(
                    UpdateVolunteeringInterests(
                      skills: [selectedSkill.name],
                      skillsIds: [value],
                      volunteeringLevel: state.volunteeringLevel,
                      volunteeringLevelId: state.volunteeringLevelId,
                      volunteeringWorkField: state.volunteeringWorkField,
                      volunteeringWorkFieldId: state.volunteeringWorkFieldId,
                      isIndividualSelected: state.isIndividualSelected,
                      isGroupSelected: state.isGroupSelected,
                    ),
                  );
            }
          },
        ),

        // Volunteering Level - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'volunteering_level_required'.tr(),
          state.volunteeringLevel ?? 'not_selected'.tr(),
          _isEditMode ? state.lvlsList : null,
          state.volunteeringLevelId,
          (value) {
            if (value != null) {
              final selectedLevel = state.lvlsList.firstWhere(
                (level) => level.tid.toString() == value,
              );
              context.read<VolunteerProfileBloc>().add(
                    UpdateVolunteeringInterests(
                      skills: state.skills,
                      skillsIds: state.skillsIds,
                      volunteeringLevel: selectedLevel.name,
                      volunteeringLevelId: value,
                      volunteeringWorkField: state.volunteeringWorkField,
                      volunteeringWorkFieldId: state.volunteeringWorkFieldId,
                      isIndividualSelected: state.isIndividualSelected,
                      isGroupSelected: state.isGroupSelected,
                    ),
                  );
            }
          },
        ),

        // Interests - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'interests'.tr(),
          state.interests.isNotEmpty
              ? state.interests.join(', ')
              : 'not_selected'.tr(),
          _isEditMode ? state.interestsList : null,
          state.interests.isNotEmpty
              ? _getInterestIdFromName(
                  state.interests.first, state.interestsList)
              : null,
          (value) {
            context.read<VolunteerProfileBloc>().add(
                  UpdateVolunteeringInterests(
                    interests: value != null ? [value] : [],
                  ),
                );
          },
        ),

        // Volunteering Work Field - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'volunteering_work_field_required'.tr(),
          state.volunteeringWorkField ?? 'not_selected'.tr(),
          _isEditMode ? state.volunteeringFieldsList : null,
          state.volunteeringWorkFieldId,
          (value) {
            if (value != null) {
              final selectedField = state.volunteeringFieldsList.firstWhere(
                (field) => field.tid.toString() == value,
              );
              context.read<VolunteerProfileBloc>().add(
                    UpdateVolunteeringInterests(
                      skills: state.skills,
                      skillsIds: state.skillsIds,
                      volunteeringLevel: state.volunteeringLevel,
                      volunteeringLevelId: state.volunteeringLevelId,
                      volunteeringWorkField: selectedField.name,
                      volunteeringWorkFieldId: value,
                      isIndividualSelected: state.isIndividualSelected,
                      isGroupSelected: state.isGroupSelected,
                    ),
                  );
            }
          },
        ),

        // Volunteering Type Preference - checkboxes in edit mode
        _buildVolunteeringTypeRow(state),
      ];

  List<Widget> _buildMedicalInfoRows(VolunteerProfileState state) => [
        // Blood Type - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'blood_type'.tr(),
          state.bloodType ?? 'not_selected'.tr(),
          _isEditMode ? state.bloodTypesList : null,
          state.bloodTypeId,
          (value) {
            if (value != null) {
              final selectedBloodType = state.bloodTypesList.firstWhere(
                (bloodType) => bloodType.tid.toString() == value,
              );
              context.read<VolunteerProfileBloc>().add(
                    UpdateMedicalInfo(
                      bloodType: selectedBloodType.name,
                      bloodTypeId: value,
                      disease: state.disease,
                      diseaseId: state.diseaseId,
                    ),
                  );
            }
          },
        ),

        // Diseases - dropdown in edit mode
        _buildDropdownOrInfoRow(
          'diseases'.tr(),
          state.disease ?? 'not_selected'.tr(),
          _isEditMode ? state.diseasesList : null,
          state.diseaseId,
          (value) {
            if (value != null) {
              final selectedDisease = state.diseasesList.firstWhere(
                (disease) => disease.tid.toString() == value,
              );
              context.read<VolunteerProfileBloc>().add(
                    UpdateMedicalInfo(
                      bloodType: state.bloodType,
                      bloodTypeId: state.bloodTypeId,
                      disease: selectedDisease.name,
                      diseaseId: value,
                    ),
                  );
            }
          },
          isLast: true,
        ),
      ];

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Section Header (Clickable)
            InkWell(
              onTap: onToggle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00796B).withOpacity(0.05),
                  borderRadius: BorderRadius.vertical(
                    top: const Radius.circular(12),
                    bottom:
                        isExpanded ? Radius.zero : const Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00796B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getSectionIcon(title),
                        color: const Color(0xFF00796B),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00796B),
                        ),
                      ),
                    ),
                    // Expand/Collapse Icon
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isExpanded ? 0.5 : 0,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF00796B),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Section Content (Expandable)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: children,
              ),
            ),
          ],
        ),
      );

  IconData _getSectionIcon(String title) {
    if (title.contains('personal') || title.contains('شخصية')) {
      return Icons.person;
    } else if (title.contains('scientific') || title.contains('علمية')) {
      return Icons.school;
    } else if (title.contains('volunteering') || title.contains('تطوع')) {
      return Icons.volunteer_activism;
    } else if (title.contains('medical') || title.contains('طبية')) {
      return Icons.medical_services;
    } else if (title.contains('social') || title.contains('اجتماعي')) {
      return Icons.share;
    }
    return Icons.info;
  }

  Widget _buildInfoRow(String label, String value,
          {bool isLast = false, bool isReadOnly = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFFF0F0F0),
                  ),
                ),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(12))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed width for label to ensure alignment
            SizedBox(
              width: 120, // Fixed width for consistent alignment
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16), // Consistent spacing
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildEditableInfoRow(String label, TextEditingController controller,
          {TextInputType keyboardType = TextInputType.text,
          int maxLines = 1,
          bool isLast = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFFF0F0F0),
                  ),
                ),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(12))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed width for label to ensure alignment
            SizedBox(
              width: 120, // Fixed width for consistent alignment
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16), // Consistent spacing
            Expanded(
              child: _isEditMode
                  ? TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      maxLines: maxLines,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      controller.text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      );

  Widget _buildLocationRow(String label, String value,
          {required bool isRegion,
          required VolunteerProfileState state,
          bool isLast = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFFF0F0F0),
                  ),
                ),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(12))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed width for label to ensure alignment
            SizedBox(
              width: 120, // Fixed width for consistent alignment
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16), // Consistent spacing
            Expanded(
              child: _isEditMode
                  ? _buildLocationDropdown(isRegion: isRegion, state: state)
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      );

  Widget _buildLocationDropdown(
      {required bool isRegion, required VolunteerProfileState state}) {
    if (isRegion) {
      // Region dropdown
      if (state.isLoadingRegions) {
        return const SizedBox(
          height: 45,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return DropdownButtonFormField<String>(
        value: state.regionId?.isEmpty == true ? null : state.regionId,

        decoration: const InputDecoration(

          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        items: state.regionsList
            .map((region) => DropdownMenuItem<String>(
                  value: region.tid.toString(),
                  child: Center(child: Text(region.name,style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ))),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            final selectedRegion = state.regionsList.firstWhere(
              (region) => region.tid.toString() == value,
            );
            context.read<VolunteerProfileBloc>().add(
                  UpdatePersonalInfo(
                    email: state.email,
                    phoneNumber: state.phoneNumber,
                    nationalId: state.nationalId,
                    gender: state.gender,
                    maritalStatus: state.maritalStatus,
                    nearbyPhoneNumber: state.nearbyPhoneNumber,
                    region: selectedRegion.name,
                    regionId: value,
                    city: '',
                    cityId: '',
                  ),
                );
            context.read<VolunteerProfileBloc>().add(
                  FetchCities(value),
                );
          }
        },
      );
    } else {
      // City dropdown
      if (state.isLoadingCities) {
        return const SizedBox(
          height: 40,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return DropdownButtonFormField<String>(
        value: state.cityId?.isEmpty == true ? null : state.cityId,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        items: state.citiesList
            .map((city) => DropdownMenuItem<String>(
                  value: city.tid.toString(),
                  child:  Center(child: Text(city.name,style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ))),

                ))
            .toList(),
        onChanged: state.regionId?.isEmpty ?? true
            ? null // Disable if no region selected
            : (value) {
                if (value != null) {
                  final selectedCity = state.citiesList.firstWhere(
                    (city) => city.tid.toString() == value,
                  );
                  context.read<VolunteerProfileBloc>().add(
                        UpdatePersonalInfo(
                          email: state.email,
                          phoneNumber: state.phoneNumber,
                          nationalId: state.nationalId,
                          gender: state.gender,
                          maritalStatus: state.maritalStatus,
                          nearbyPhoneNumber: state.nearbyPhoneNumber,
                          region: state.region,
                          regionId: state.regionId,
                          city: selectedCity.name,
                          cityId: value,
                        ),
                      );
                }
              },
      );
    }
  }

  String _getWorkExperienceText(String? experience) {
    if (experience == null || experience.isEmpty) return '';

    final years = int.tryParse(experience) ?? 0;
    if (years == 0) {
      return 'no_experience'.tr();
    } else if (years == 1) {
      return 'one_year'.tr();
    } else {
      return '$years سنوات'; // years in Arabic
    }
  }

  String _getVolunteeringTypeText(VolunteerProfileState state) {
    if (state.isIndividualSelected && state.isGroupSelected) {
      return '${'individual'.tr()} / ${'group'.tr()}';
    } else if (state.isIndividualSelected) {
      return 'individual'.tr();
    } else if (state.isGroupSelected) {
      return 'group'.tr();
    }
    return 'not_selected'.tr();
  }

  String? _getInterestIdFromName(
      String interestName, List<dynamic> interestsList) {
    try {
      final interest = interestsList.firstWhere(
        (interest) => interest.name == interestName,
        orElse: () => null,
      );
      return interest?.tid?.toString();
    } catch (e) {
      return null;
    }
  }

  // Helper method to build dropdown or info row based on edit mode
  Widget _buildDropdownOrInfoRow(
          String label,
          String value,
          List<dynamic>? items,
          String? selectedValue,
          Function(String?)? onChanged,
          {bool isLast = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFFF0F0F0),
                  ),
                ),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(12))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _isEditMode && items != null
                  ? DropdownButtonFormField<String>(
                      value:
                          selectedValue?.isEmpty == true ? null : selectedValue,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item.tid.toString(),
                                child: Text(item.name),
                              ))
                          .toList(),
                      onChanged: onChanged,
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      );

  // Helper method for work experience row (special case with years)
  Widget _buildWorkExperienceRow(VolunteerProfileState state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF0F0F0),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                'work_experience'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _isEditMode
                  ? DropdownButtonFormField<String>(
                      value: state.workExperience?.isEmpty == true ||
                              state.workExperience == 'null'
                          ? null
                          : state.workExperience,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: List.generate(51, (index) => index)
                          .map((year) => DropdownMenuItem<String>(
                                value: year.toString(),
                                child: Text(
                                    '$year ${year == 0 ? 'no_experience'.tr() : year == 1 ? 'one_year'.tr() : 'years'.tr()}'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        context.read<VolunteerProfileBloc>().add(
                              UpdateScientificInfo(
                                educationalQualification:
                                    state.educationalQualification,
                                educationalQualificationId:
                                    state.educationalQualificationId,
                                specialization: state.specialization,
                                specializationId: state.specializationId,
                                profession: state.profession,
                                workExperience: value,
                                language: state.language,
                                languageId: state.languageId,
                                scientificExperienceSummary:
                                    state.scientificExperienceSummary,
                              ),
                            );
                      },
                    )
                  : Text(
                      _getWorkExperienceText(state.workExperience),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      );

  // Helper method for volunteering type preference (checkboxes)
  Widget _buildVolunteeringTypeRow(VolunteerProfileState state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                'volunteering_type_preference'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _isEditMode
                  ? Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                value: state.isIndividualSelected,
                                onChanged: (value) {
                                  context.read<VolunteerProfileBloc>().add(
                                        UpdateVolunteeringInterests(
                                          skills: state.skills,
                                          skillsIds: state.skillsIds,
                                          volunteeringLevel:
                                              state.volunteeringLevel,
                                          volunteeringLevelId:
                                              state.volunteeringLevelId,
                                          volunteeringWorkField:
                                              state.volunteeringWorkField,
                                          volunteeringWorkFieldId:
                                              state.volunteeringWorkFieldId,
                                          isIndividualSelected: value ?? false,
                                          isGroupSelected:
                                              state.isGroupSelected,
                                        ),
                                      );
                                },
                                activeColor: const Color(0xFF00A693),
                              ),
                              Text('individual'.tr()),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                value: state.isGroupSelected,
                                onChanged: (value) {
                                  context.read<VolunteerProfileBloc>().add(
                                        UpdateVolunteeringInterests(
                                          skills: state.skills,
                                          skillsIds: state.skillsIds,
                                          volunteeringLevel:
                                              state.volunteeringLevel,
                                          volunteeringLevelId:
                                              state.volunteeringLevelId,
                                          volunteeringWorkField:
                                              state.volunteeringWorkField,
                                          volunteeringWorkFieldId:
                                              state.volunteeringWorkFieldId,
                                          isIndividualSelected:
                                              state.isIndividualSelected,
                                          isGroupSelected: value ?? false,
                                        ),
                                      );
                                },
                                activeColor: const Color(0xFF00A693),
                              ),
                              Text('group'.tr()),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Text(
                      _getVolunteeringTypeText(state),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      );

  List<Widget> _buildSocialMediaRows(VolunteerProfileState state) {
    final List<Widget> rows = [];

    // In edit mode, show all social media fields
    if (_isEditMode) {
      rows.addAll([
        _buildEditableInfoRow('x_account'.tr(), _xAccountController),
        _buildEditableInfoRow('instagram_account'.tr(), _instagramController),
        _buildEditableInfoRow('linkedin_account'.tr(), _linkedinController),
        _buildEditableInfoRow('facebookAccount'.tr(), _facebookController,
            isLast: true),
      ]);
    } else {
      // In view mode, show all fields with appropriate values
      rows.addAll([
        _buildInfoRow('x_account'.tr(), state.xAccount ?? 'not_provided'.tr(),
            isReadOnly: true),
        _buildInfoRow('instagram_account'.tr(),
            state.instagramAccount ?? 'not_provided'.tr(),
            isReadOnly: true),
        _buildInfoRow('linkedin_account'.tr(),
            state.linkedinAccount ?? 'not_provided'.tr(),
            isReadOnly: true),
        _buildInfoRow('facebookAccount'.tr(),
            state.facebookAccount ?? 'not_provided'.tr(),
            isReadOnly: true, isLast: true),
      ]);
    }

    return rows;
  }

  // Helper method to build CV upload row
  Widget _buildCVUploadRow(VolunteerProfileState state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                'resume_cv'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _isEditMode
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current CV status
                        if (state.cvFileName != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.file_present,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.cvFileName!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 8),
                        // Upload button
                        ElevatedButton(
                          onPressed: () => _pickAndUploadFile(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: const Color(0xFF00796B),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.upload_file,
                                  color: Colors.white, size: 16),

                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8),
                                child: Text(
                                  state.cvFileName != null
                                      ? 'change_cv'.tr()
                                      : 'attach_cv'.tr(),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Upload status
                        if (state.isUploadingCV)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'uploading_cv'.tr(),
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                  : Text(
                      state.cvFileName ?? 'not_attached'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      );

  Widget _buildSaveButton() => Container(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ElevatedButton(
              onPressed: _isFormValid ? _saveChanges : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'save'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
}
