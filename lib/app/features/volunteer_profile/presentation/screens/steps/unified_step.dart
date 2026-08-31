import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/features/volunteer_profile/presentation/bloc/volunteer_profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../bloc/volunteer_profile_bloc.dart';
import '../../bloc/volunteer_profile_state.dart';

class UnifiedStep extends StatefulWidget {
  const UnifiedStep({super.key});

  @override
  State<UnifiedStep> createState() => _UnifiedStepState();
}

class _UnifiedStepState extends State<UnifiedStep> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedRegionId;
  String? _selectedCityId;

  @override
  void initState() {
    super.initState();
    final state = context.read<VolunteerProfileBloc>().state;
    _phoneController = TextEditingController(text: state.phoneNumber ?? '');
    _emailController = TextEditingController(text: state.email ?? '');
    _selectedRegionId = state.regionId;
    _selectedCityId = state.cityId;
  }

  void _onEmailChanged(String value) {
    context.read<VolunteerProfileBloc>().add(
      UpdatePersonalInfo(
        email: value,
        phoneNumber: _phoneController.text,
        nationalId: context.read<VolunteerProfileBloc>().state.nationalId,
        region: context.read<VolunteerProfileBloc>().state.region,
        regionId: _selectedRegionId,
        city: context.read<VolunteerProfileBloc>().state.city,
        cityId: _selectedCityId,
      ),
    );
  }

  void _onPhoneChanged(String value) {
    context.read<VolunteerProfileBloc>().add(
      UpdatePersonalInfo(
        email: _emailController.text,
        phoneNumber: value,
        nationalId: context.read<VolunteerProfileBloc>().state.nationalId,
        region: context.read<VolunteerProfileBloc>().state.region,
        regionId: _selectedRegionId,
        city: context.read<VolunteerProfileBloc>().state.city,
        cityId: _selectedCityId,
      ),
    );
  }

  void _onRegionChanged(String? value, VolunteerProfileState state) {
    if (value != null) {
      final selectedRegion = state.regionsList.firstWhere(
        (region) => region.tid.toString() == value,
      );
      setState(() {
        _selectedRegionId = value;
        _selectedCityId = null;
      });
      context.read<VolunteerProfileBloc>().add(
        UpdatePersonalInfo(
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          nationalId: state.nationalId,
          region: selectedRegion.name,
          regionId: value,
          city: '',
          cityId: '',
        ),
      );
      context.read<VolunteerProfileBloc>().add(FetchCities(value));
    }
  }

  void _onCityChanged(String? value, VolunteerProfileState state) {
    if (value != null) {
      final selectedCity = state.citiesList.firstWhere(
        (city) => city.tid.toString() == value,
      );
      setState(() {
        _selectedCityId = value;
      });
      context.read<VolunteerProfileBloc>().add(
        UpdatePersonalInfo(
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          nationalId: state.nationalId,
          region: state.region,
          regionId: _selectedRegionId,
          city: selectedCity.name,
          cityId: value,
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<VolunteerProfileBloc, VolunteerProfileState>(
    builder: (context, state) => SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'full_name'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: true,
            initialValue: state.fullName ?? '',
            decoration: InputDecoration(
              hintText: 'full_name'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 15.0,
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'national_id'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: true,
            initialValue: state.nationalId,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: state.isNationalIdFromApi,
              fillColor: Theme.of(context).cardColor,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Text(
            '${'email'.tr()} *',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'example@gmail.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 15.0,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => Helpers.validateEmail(value),
            onChanged: _onEmailChanged,
          ),
          const SizedBox(height: 20),
          Text(
            '${'personal_mobile'.tr()} *',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: '966500000000+',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 15.0,
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) => Helpers.validateMobile(value),
            onChanged: _onPhoneChanged,
          ),
          const SizedBox(height: 20),
          Text(
            '${'region'.tr()} *',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingRegions)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),

              dropdownColor: Theme.of(context).cardColor,
              initialValue: _selectedRegionId?.isEmpty == true
                  ? null
                  : _selectedRegionId,
              decoration: InputDecoration(
                helperStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                hint: Text('region'.tr()),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.regionsList
                  .map(
                    (region) => DropdownMenuItem<String>(
                      value: region.tid.toString(),
                      child: Center(
                        child: Text(
                          region.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => _onRegionChanged(value, state),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'select_region'.tr();
                }
                return null;
              },
            ),
          const SizedBox(height: 16),
          // City (editable, required)
          Text(
            '${'city'.tr()} *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingCities)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              dropdownColor: Theme.of(context).cardColor,
              initialValue: _selectedCityId?.isEmpty == true
                  ? null
                  : _selectedCityId,
              decoration: InputDecoration(
                hint: Text('city'.tr()),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.citiesList
                  .map(
                    (city) => DropdownMenuItem<String>(
                      value: city.tid.toString(),
                      child: Center(
                        child: Text(
                          city.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => _onCityChanged(value, state),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '${'city_select'.tr()} *';
                }
                return null;
              },
            ),
          Text(
            'educational_qualification_required'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingQualifications)
            const Center(child: CircularProgressIndicator())
          else if (state.qualificationsList.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'no_qualifications_available'.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                ),
              ),
            )
          else
            DropdownButtonFormField<String>(
              dropdownColor: Theme.of(context).cardColor,
              initialValue: state.educationalQualificationId?.isEmpty == true
                  ? null
                  : state.educationalQualificationId,
              decoration: InputDecoration(
                hint: Text('choose'.tr()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.qualificationsList
                  .map(
                    (qualification) => DropdownMenuItem<String>(
                      value: qualification.tid.toString(),
                      child: Center(
                        child: Text(
                          qualification.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final selectedQualification = state.qualificationsList
                      .firstWhere(
                        (qualification) =>
                            qualification.tid.toString() == value,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_select_educational_qualification'.tr();
                }
                return null;
              },
            ),
          Text(
            'volunteering_work_field_required'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingVolunteeringFields)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              dropdownColor: Theme.of(context).cardColor,
              initialValue:
                  state.volunteeringFieldsList
                      .where((f) => (f.numberOfServices ?? 0) != 0)
                      .any((f) => f.tid == state.volunteeringWorkFieldId)
                  ? state.volunteeringWorkFieldId
                  : null,
              decoration: InputDecoration(
                hint: Text('choose'.tr()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 15.0,
                ),
              ),
              items: state.volunteeringFieldsList.where((f) => (f.numberOfServices ?? 0) != 0).isEmpty
                  ? [
                      DropdownMenuItem<String>(
                        child: Center(
                          child: Text(
                            'no_volunteering_fields_available'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : state.volunteeringFieldsList
                        .where((f) => (f.numberOfServices ?? 0) != 0)
                        // deduplicate by tid in case API returns duplicates
                        .fold<List<dynamic>>([], (acc, f) => acc.any((e) => e.tid == f.tid) ? acc : (acc..add(f)))
                        .cast<dynamic>()
                        .map((field) => DropdownMenuItem<String>(
                          value: field.tid.toString(),
                          child: Center(
                            child: Text(
                              field.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                        .toList(),
              onChanged: state.volunteeringFieldsList.where((f) => (f.numberOfServices ?? 0) != 0).isEmpty
                  ? null
                  : (value) {
                      if (value != null) {
                        final selectedField = state.volunteeringFieldsList
                            .firstWhere(
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
                        context.read<VolunteerProfileBloc>().add(FetchVolunteeringServices(value));
                      }
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_select_volunteering_work_field'.tr();
                }
                return null;
              },
            ),
          if (state.volunteeringWorkFieldId != null && state.volunteeringWorkFieldId!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'volunteer_service'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (state.isLoadingVolunteeringServices)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<String>(
                dropdownColor: Theme.of(context).cardColor,
                initialValue: state.volunteeringServicesList
                        .any((s) => s.tid == state.volunteeringServiceId)
                    ? state.volunteeringServiceId
                    : null,
                decoration: InputDecoration(
                  hint: Text('choose'.tr()),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                ),
                items: state.volunteeringServicesList.isEmpty
                    ? [
                        DropdownMenuItem<String>(
                          child: Center(
                            child: Text(
                              'no_volunteering_services_available'.tr(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ]
                    : state.volunteeringServicesList
                          // deduplicate by tid in case API returns duplicates
                          .fold<List<dynamic>>([], (acc, s) => acc.any((e) => e.tid == s.tid) ? acc : (acc..add(s)))
                          .cast<dynamic>()
                          .map((service) => DropdownMenuItem<String>(
                            value: service.tid.toString(),
                            child: Center(
                              child: Text(
                                service.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ))
                          .toList(),
                onChanged: state.volunteeringServicesList.isEmpty
                    ? null
                    : (value) {
                        if (value != null) {
                          final selectedService = state.volunteeringServicesList.firstWhere(
                            (service) => service.tid.toString() == value,
                          );
                          context.read<VolunteerProfileBloc>().add(
                            UpdateVolunteeringInterests(
                              skills: state.skills,
                              skillsIds: state.skillsIds,
                              volunteeringLevel: state.volunteeringLevel,
                              volunteeringLevelId: state.volunteeringLevelId,
                              volunteeringWorkField: state.volunteeringWorkField,
                              volunteeringWorkFieldId: state.volunteeringWorkFieldId,
                              volunteeringService: selectedService.name,
                              volunteeringServiceId: value,
                              isIndividualSelected: state.isIndividualSelected,
                              isGroupSelected: state.isGroupSelected,
                            ),
                          );
                        }
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_select_volunteering_service'.tr();
                  }
                  return null;
                },
              ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    ),
  );
}
