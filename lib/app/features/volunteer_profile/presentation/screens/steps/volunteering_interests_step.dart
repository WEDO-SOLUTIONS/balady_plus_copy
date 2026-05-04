import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../bloc/volunteer_profile_bloc.dart';
import '../../bloc/volunteer_profile_event.dart';
import '../../bloc/volunteer_profile_state.dart';

class VolunteeringInterestsStep extends StatefulWidget {
  const VolunteeringInterestsStep({super.key});

  @override
  State<VolunteeringInterestsStep> createState() =>
      _VolunteeringInterestsStepState();
}

class _VolunteeringInterestsStepState extends State<VolunteeringInterestsStep> {
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
            'lbl_volunteering_interests'.tr(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            'lbl_fill_required_fields'.tr(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Skills (Required)
          Text(
            'skills_required'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingSkills)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              initialValue: state.skillsIds.isNotEmpty
                  ? state.skillsIds.first
                  : null,
              decoration: InputDecoration(
                hint: Text('choose'.tr()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.skillsList.isEmpty
                  ? [
                      DropdownMenuItem<String>(
                        child: Center(
                          child: Text(
                            'no_skills_available'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : state.skillsList
                        .map(
                          (skill) => DropdownMenuItem<String>(
                            value: skill.tid.toString(),
                            child: Center(
                              child: Text(
                                skill.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              onChanged: state.skillsList.isEmpty
                  ? null
                  : (value) {
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
                            volunteeringWorkFieldId:
                                state.volunteeringWorkFieldId,
                            isIndividualSelected: state.isIndividualSelected,
                            isGroupSelected: state.isGroupSelected,
                          ),
                        );
                      }
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_select_skills'.tr();
                }
                return null;
              },
            ),
          const SizedBox(height: 16),

          // Volunteering Level (Required)
          Text(
            'volunteering_level_required'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingLvls)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              initialValue: state.volunteeringLevelId,
              decoration: InputDecoration(
                hint: Text('choose'.tr()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.lvlsList.isEmpty
                  ? [
                      DropdownMenuItem<String>(
                        child: Center(
                          child: Text(
                            'no_levels_available'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : state.lvlsList
                        .map(
                          (level) => DropdownMenuItem<String>(
                            value: level.tid.toString(),
                            child: Center(
                              child: Text(
                                level.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              onChanged: state.lvlsList.isEmpty
                  ? null
                  : (value) {
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
                            volunteeringWorkFieldId:
                                state.volunteeringWorkFieldId,
                            isIndividualSelected: state.isIndividualSelected,
                            isGroupSelected: state.isGroupSelected,
                          ),
                        );
                      }
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_select_volunteering_level'.tr();
                }
                return null;
              },
            ),
          const SizedBox(height: 16),

          // Interests (Optional)
          Text(
            'interests'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingInterests)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              initialValue: state.interests.isNotEmpty
                  ? state.interests.first
                  : null,
              decoration: InputDecoration(
                hint: Text('choose'.tr()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.interestsList.isEmpty
                  ? [
                      DropdownMenuItem<String>(
                        child: Center(
                          child: Text(
                            'no_interests_available'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : state.interestsList
                        .map(
                          (interest) => DropdownMenuItem<String>(
                            value: interest.name,
                            child: Center(
                              child: Text(
                                interest.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              onChanged: state.interestsList.isEmpty
                  ? null
                  : (value) {
                      context.read<VolunteerProfileBloc>().add(
                        UpdateVolunteeringInterests(
                          interests: value != null ? [value] : [],
                        ),
                      );
                    },
              // No validator - interests is optional
            ),
          const SizedBox(height: 16),

          // Volunteering Work Field (Required)
          Text(
            'volunteering_work_field_required'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingVolunteeringFields)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              initialValue: state.volunteeringWorkFieldId,
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
              items: state.volunteeringFieldsList.isEmpty
                  ? [
                      DropdownMenuItem<String>(
                        child: Center(
                          child: Text(
                            'no_volunteering_fields_available'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : state.volunteeringFieldsList
                        .map(
                          (field) => DropdownMenuItem<String>(
                            value: field.tid.toString(),
                            child: Center(
                              child: Text(
                                field.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              onChanged: state.volunteeringFieldsList.isEmpty
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
                      }
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_select_volunteering_work_field'.tr();
                }
                return null;
              },
            ),
          const SizedBox(height: 16),

          // Volunteering Type Preference
          Text(
            'volunteering_type_preference'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
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
                            volunteeringLevel: state.volunteeringLevel,
                            volunteeringLevelId: state.volunteeringLevelId,
                            volunteeringWorkField: state.volunteeringWorkField,
                            volunteeringWorkFieldId:
                                state.volunteeringWorkFieldId,
                            isIndividualSelected: value ?? false,
                            isGroupSelected: state.isGroupSelected,
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
                            volunteeringLevel: state.volunteeringLevel,
                            volunteeringLevelId: state.volunteeringLevelId,
                            volunteeringWorkField: state.volunteeringWorkField,
                            volunteeringWorkFieldId:
                                state.volunteeringWorkFieldId,
                            isIndividualSelected: state.isIndividualSelected,
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
          ),
          const SizedBox(height: 80),
        ],
      ),
    ),
  );
}
