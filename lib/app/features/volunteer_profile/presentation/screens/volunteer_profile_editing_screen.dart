import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../bloc/volunteer_profile_bloc.dart';
import '../widgets/volunteer_presentation_mode.dart';

class VolunteerProfileEditingScreen extends StatefulWidget {
  final VolunteerProfileBloc volunteerProfileBloc;

  const VolunteerProfileEditingScreen({
    required this.volunteerProfileBloc,
    super.key,
  });

  @override
  State<VolunteerProfileEditingScreen> createState() =>
      _VolunteerProfileEditingScreenState();
}

class _VolunteerProfileEditingScreenState
    extends State<VolunteerProfileEditingScreen> {
  Map<String, dynamic>? originalValues;
  @override
  void initState() {
    super.initState();
    final currentState = widget.volunteerProfileBloc.state;
    originalValues = {
      'email': currentState.email,
      'phoneNumber': currentState.phoneNumber,
      'nearbyPhoneNumber': currentState.nearbyPhoneNumber,
      'profession': currentState.profession,
      'scientificExperienceSummary': currentState.scientificExperienceSummary,
      'xAccount': currentState.xAccount,
      'instagramAccount': currentState.instagramAccount,
      'linkedinAccount': currentState.linkedinAccount,
      'facebookAccount': currentState.facebookAccount,
      'city': currentState.city,
      'cityId': currentState.cityId,
      'region': currentState.region,
      'regionId': currentState.regionId,
      'educationalQualification': currentState.educationalQualification,
      'educationalQualificationId': currentState.educationalQualificationId,
      'specialization': currentState.specialization,
      'specializationId': currentState.specializationId,
      'language': currentState.language,
      'languageId': currentState.languageId,
      'workExperience': currentState.workExperience,
      'skills': currentState.skills.isNotEmpty
          ? currentState.skills.join(', ')
          : null,
      'skillsIds': currentState.skillsIds.isNotEmpty
          ? currentState.skillsIds.first
          : null,
      'volunteeringLevel': currentState.volunteeringLevel,
      'volunteeringLevelId': currentState.volunteeringLevelId,
      'volunteeringWorkField': currentState.volunteeringWorkField,
      'volunteeringWorkFieldId': currentState.volunteeringWorkFieldId,
      'isIndividualSelected': currentState.isIndividualSelected,
      'isGroupSelected': currentState.isGroupSelected,
      'bloodType': currentState.bloodType,
      'bloodTypeId': currentState.bloodTypeId,
      'disease': currentState.disease,
      'diseaseId': currentState.diseaseId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // This will be called when back button is pressed
        print('WillPopScope triggered in edit mode');
        // Restore original values
        VolunteerPresentationMode.cancelEditMode(
          context,
          widget.volunteerProfileBloc,
          originalValues!,
        );
        return true; // Allow pop
      },
      child: Theme(
        data: Theme.of(NavigationService.navigatorKey.currentState!.context),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              tooltip: 'a11yBack'.tr(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                VolunteerPresentationMode.cancelEditMode(
                  context,
                  widget.volunteerProfileBloc,
                  originalValues!,
                );
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'volunteer_edit_info_title'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocProvider.value(
            value: widget.volunteerProfileBloc,
            child: const VolunteerPresentationMode(isEditMode: true),
          ),
        ),
      ),
    );
  }
}
