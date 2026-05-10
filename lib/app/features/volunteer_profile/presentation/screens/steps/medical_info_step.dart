import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/volunteer_profile_bloc.dart';
import '../../bloc/volunteer_profile_event.dart';
import '../../bloc/volunteer_profile_state.dart';

class MedicalInfoStep extends StatefulWidget {
  const MedicalInfoStep({super.key});

  @override
  State<MedicalInfoStep> createState() => _MedicalInfoStepState();
}

class _MedicalInfoStepState extends State<MedicalInfoStep> {
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
            'medical_information'.tr(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            'lbl_fill_required_fields'.tr(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Blood Type Dropdown
          Text(
            'blood_type'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingBloodTypes)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              initialValue: state.bloodTypeId,
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
              items: state.bloodTypesList.isEmpty
                  ? [
                      DropdownMenuItem<String>(
                        child: Center(
                          child: Text(
                            'no_blood_types_available'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : state.bloodTypesList
                        .map(
                          (bloodType) => DropdownMenuItem<String>(
                            value: bloodType.tid.toString(),
                            child: Center(
                              child: Text(
                                bloodType.name,
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
              onChanged: state.bloodTypesList.isEmpty
                  ? null
                  : (value) {
                      if (value != null) {
                        final selectedBloodType = state.bloodTypesList
                            .firstWhere(
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
          const SizedBox(height: 16),

          // Diseases Dropdown
          Text(
            'diseases'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (state.isLoadingDiseases)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              initialValue: state.diseaseId,
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
              items: state.diseasesList.isEmpty
                  ? [
                      DropdownMenuItem<String>(
                        child: Center(
                          child: Text(
                            'no_diseases_available'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : state.diseasesList
                        .map(
                          (disease) => DropdownMenuItem<String>(
                            value: disease.tid.toString(),
                            child: Center(
                              child: Text(
                                disease.name,
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
              onChanged: state.diseasesList.isEmpty
                  ? null
                  : (value) {
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
            ),
          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}
