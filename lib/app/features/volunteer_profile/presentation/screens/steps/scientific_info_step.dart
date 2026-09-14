import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../bloc/volunteer_profile_bloc.dart';
import '../../bloc/volunteer_profile_event.dart';
import '../../bloc/volunteer_profile_state.dart';

class ScientificInfoStep extends StatelessWidget {
  const ScientificInfoStep({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<VolunteerProfileBloc, VolunteerProfileState>(
    builder: (context, state) => SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('scientific_data'.tr(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Text('lbl_fill_required_fields'.tr(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
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
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('no_qualifications_available'.tr(), style: const TextStyle(color: Colors.grey)),
            )
          else
            DropdownButtonFormField<String>(
              initialValue: state.educationalQualificationId?.isEmpty == true ? null : state.educationalQualificationId,
              decoration: InputDecoration(
                hint: Text('choose'.tr()),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.qualificationsList
                  .map(
                    (qualification) => DropdownMenuItem<String>(
                      value: qualification.tid.toString(),
                      child: Center(
                        child: Text(
                          qualification.name,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
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
                      scientificExperienceSummary: state.scientificExperienceSummary,
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
          const SizedBox(height: 16),
          Text('specialization_required'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (state.isLoadingSpecializations)
            const Center(child: CircularProgressIndicator())
          else if (state.specializationsList.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('no_specializations_available'.tr(), style: const TextStyle(color: Colors.grey)),
            )
          else
            DropdownButtonFormField<String>(
              initialValue: state.specializationId?.isEmpty == true ? null : state.specializationId,
              decoration: InputDecoration(
                hint: Text('choose'.tr()),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.specializationsList
                  .map(
                    (specialization) => DropdownMenuItem<String>(
                      value: specialization.tid.toString(),
                      child: Center(
                        child: Text(
                          specialization.name,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final selectedSpecialization = state.specializationsList.firstWhere(
                    (specialization) => specialization.tid.toString() == value,
                  );
                  context.read<VolunteerProfileBloc>().add(
                    UpdateScientificInfo(
                      educationalQualification: state.educationalQualification,
                      educationalQualificationId: state.educationalQualificationId,
                      specialization: selectedSpecialization.name,
                      specializationId: value,
                      profession: state.profession,
                      workExperience: state.workExperience,
                      language: state.language,
                      languageId: state.languageId,
                      scientificExperienceSummary: state.scientificExperienceSummary,
                    ),
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_select_specialization'.tr();
                }
                return null;
              },
            ),
          const SizedBox(height: 16),
          Text('profession'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: state.profession == 'null' ? '' : state.profession,
            decoration: InputDecoration(
              hintText: 'enter_profession'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
            ),
            onChanged: (value) {
              context.read<VolunteerProfileBloc>().add(
                UpdateScientificInfo(
                  educationalQualification: state.educationalQualification,
                  educationalQualificationId: state.educationalQualificationId,
                  specialization: state.specialization,
                  specializationId: state.specializationId,
                  profession: value,
                  workExperience: state.workExperience,
                  language: state.language,
                  languageId: state.languageId,
                  scientificExperienceSummary: state.scientificExperienceSummary,
                ),
              );
            },
            // No validator - profession is optional
          ),
          const SizedBox(height: 16),
          Text('work_experience'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: state.workExperience?.isEmpty == true || state.workExperience == 'null'
                ? null
                : state.workExperience,
            decoration: InputDecoration(
              hintText: 'choose_years_of_experience'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
            items: List.generate(51, (index) => index)
                .map(
                  (year) => DropdownMenuItem<String>(
                    value: year.toString(),
                    child: Center(
                      child: Text(
                        '$year ${year == 0
                            ? 'no_experience'.tr()
                            : year == 1
                            ? 'one_year'.tr()
                            : 'years'.tr()}',
                        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              context.read<VolunteerProfileBloc>().add(
                UpdateScientificInfo(
                  educationalQualification: state.educationalQualification,
                  educationalQualificationId: state.educationalQualificationId,
                  specialization: state.specialization,
                  specializationId: state.specializationId,
                  profession: state.profession,
                  workExperience: value,
                  language: state.language,
                  languageId: state.languageId,
                  scientificExperienceSummary: state.scientificExperienceSummary,
                ),
              );
            },
            // No validator - work experience is optional
          ),
          const SizedBox(height: 16),
          Text('language_required'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (state.isLoadingLanguages)
            const Center(child: CircularProgressIndicator())
          else if (state.languagesList.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('no_languages_available'.tr(), style: const TextStyle(color: Colors.grey)),
            )
          else
            DropdownButtonFormField<String>(
              initialValue: state.languageId?.isEmpty == true ? null : state.languageId,
              decoration: InputDecoration(
                hint: Text('choose'.tr()),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              items: state.languagesList
                  .map(
                    (language) => DropdownMenuItem<String>(
                      value: language.tid.toString(),
                      child: Center(
                        child: Text(
                          language.name,
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final selectedLanguage = state.languagesList.firstWhere(
                    (language) => language.tid.toString() == value,
                  );
                  context.read<VolunteerProfileBloc>().add(
                    UpdateScientificInfo(
                      educationalQualification: state.educationalQualification,
                      educationalQualificationId: state.educationalQualificationId,
                      specialization: state.specialization,
                      specializationId: state.specializationId,
                      profession: state.profession,
                      workExperience: state.workExperience,
                      language: selectedLanguage.name,
                      languageId: value,
                      scientificExperienceSummary: state.scientificExperienceSummary,
                    ),
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_select_language'.tr();
                }
                return null;
              },
            ),
          const SizedBox(height: 16),
          Text(
            'scientific_experience_summary_required'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: state.scientificExperienceSummary == 'null' ? '' : state.scientificExperienceSummary,
            decoration: InputDecoration(
              hintText: 'write_scientific_experience_summary'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_enter_scientific_experience_summary'.tr();
              }
              return null;
            },
            onChanged: (value) {
              context.read<VolunteerProfileBloc>().add(
                UpdateScientificInfo(
                  educationalQualification: state.educationalQualification,
                  educationalQualificationId: state.educationalQualificationId,
                  specialization: state.specialization,
                  specializationId: state.specializationId,
                  profession: state.profession,
                  workExperience: state.workExperience,
                  language: state.language,
                  languageId: state.languageId,
                  scientificExperienceSummary: value,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text('resume_cv'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _pickAndUploadFile(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              backgroundColor: Colors.teal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white),
                const SizedBox(width: 8),
                Text('attach'.tr(), style: const TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // CV Upload Status
          if (state.isUploadingCV)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 8),
                  Text('uploading_cv'.tr(), style: const TextStyle(color: Colors.orange)),
                ],
              ),
            ),
          if (state.cvFileName != null && !state.isUploadingCV)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${'cv_file_selected'.tr()}${state.cvFileName}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          if (state.cvUploadMessage != null && state.cvUploadMessage!.contains('Failed') && !state.isUploadingCV)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(state.cvUploadMessage!, style: const TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
    ),
  );
}

Future<void> _pickAndUploadFile(BuildContext context) async {
  try {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (!context.mounted) {
      return;
    }

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        // Check file size (limit to 10MB)
        if (file.size > 10 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size too large. Please select a file under 10MB.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Trigger upload
        context.read<VolunteerProfileBloc>().add(UploadCVFile(filePath: file.path!, fileName: file.name));
      }
    }
  } catch (e) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to select file: $e'), backgroundColor: Colors.red));
  }
}
