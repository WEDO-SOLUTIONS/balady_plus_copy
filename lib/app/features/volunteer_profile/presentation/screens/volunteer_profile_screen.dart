import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/volunteer_profile/presentation/screens/steps/unified_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../presentation/bloc/volunteer_profile_bloc.dart';
import '../../presentation/bloc/volunteer_profile_event.dart';
import '../../presentation/bloc/volunteer_profile_state.dart';
import '../../presentation/widgets/volunteer_presentation_mode.dart';
import '../../presentation/widgets/volunteer_success_dialog.dart';

class VolunteerProfileScreen extends StatefulWidget {
  final VolunteerProfileBloc volunteerProfileBloc;

  const VolunteerProfileScreen({required this.volunteerProfileBloc, super.key});

  @override
  State<VolunteerProfileScreen> createState() => _VolunteerProfileScreenState();
}

class _VolunteerProfileScreenState extends State<VolunteerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Define the list of steps
  final List<Widget> _steps = [
    UnifiedStep(),
    // const PersonalInfoStep(),
    // const ScientificInfoStep(),
    // const VolunteeringInterestsStep(),
    // const MedicalInfoStep(),
    // const SocialMeidaInformationStep()
  ];

  // Define step titles
  final List<String> _stepTitles = [
    // 'lbl_personal_info',
    // 'lbl_scientific_info',
    // 'lbl_volunteering_interests',
    // 'lbl_medical_info',
    // 'lbl_social_media_info'
  ];

  // Get current step title
  String getCurrentStepTitle(int currentStep) {
    if (currentStep >= 0 && currentStep < _stepTitles.length) {
      return _stepTitles[currentStep].tr();
    }
    return '';
  }

  // Get next step title
  String getNextStepTitle(int currentStep) {
    if (currentStep + 1 < _stepTitles.length) {
      return '${'next_step'.tr()}: ${_stepTitles[currentStep + 1].tr()}';
    }
    return ''; // Return empty string if this is the last step
  }

  @override
  void initState() {
    super.initState();
    widget.volunteerProfileBloc.add(const LoadVolunteerProfile());
  }

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(NavigationService.navigatorKey.currentState!.context),
      child: BlocProvider.value(
      value: widget.volunteerProfileBloc,
      child: BlocConsumer<VolunteerProfileBloc, VolunteerProfileState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state.isSuccess) {
            // Show custom success dialog
            showVolunteerSuccessDialog(
              context,
              onNavigateToServices: () {
                Navigator.of(context).pop();
              },
            );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.isLoading || state.isSubmitting) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Show presentation mode if enabled
          if (state.isPresentationMode) {
            return Scaffold(
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
                    // Handle cancel logic directly
                    print('AppBar back button pressed');
                    // Exit the entire volunteer profile flow
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  'volunteer_info_title'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF00796B)),
                    onPressed: () async {
                      Navigator.of(
                        context,
                      ).pushNamed(RouteName.VolunteerEditProfile);
                    },
                  ),
                ],
              ),
              body: const VolunteerPresentationMode(),
            );
          }

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                Column(
                  children: [
                    // Fixed Header Layout
                    Container(
                      color: Theme.of(context).colorScheme.surface.withAlpha(90),
                      padding: const EdgeInsets.only(
                        top: 40.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row: Close button, Title, Back arrow
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Back Button
                                Semantics(
                                  label: 'a11yBack'.tr(),
                                  button: true,
                                  child: GestureDetector(
                                  onTap: () {
                                    // Navigate back if not on the first step
                                    if (state.currentStep > 0) {
                                      context.read<VolunteerProfileBloc>().add(
                                        ChangeStep(state.currentStep - 1),
                                      );
                                    } else {
                                      // Close the screen if on the first step
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ),
                                ),
                                // Title
                                Text(
                                  'complete_data_title'.tr(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                const Spacer(),
                                // Next Button
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Second row: Progress indicator and text, aligned to the right
                          Row(
                            mainAxisSize:
                                MainAxisSize.min, // Shrink row to fit content
                            children: [
                              // Stack(
                              //   alignment: Alignment.center,
                              //   children: [
                              //     SizedBox(
                              //       width: 60,
                              //       height: 60,
                              //       child: CircularProgressIndicator(
                              //         // Update progress based on actual number of steps
                              //         value: (state.currentStep + 1) /
                              //             _steps.length.toDouble(),
                              //         strokeWidth: 3,
                              //         backgroundColor: Colors.grey[300],
                              //         valueColor:
                              //             const AlwaysStoppedAnimation<Color>(
                              //           Colors.blue,
                              //         ),
                              //       ),
                              //     ),
                              //     Text(
                              //       // Update step count text
                              //       '${state.currentStep + 1}/${_steps.length}', // Display current step out of total steps
                              //       style: const TextStyle(
                              //         fontSize: 20,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.grey,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(width: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    getCurrentStepTitle(state.currentStep),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (getNextStepTitle(
                                    state.currentStep,
                                  ).isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      getNextStepTitle(state.currentStep),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Scrollable Form Content
                    Expanded(
                      child: Form(
                        key: _formKey,
                        // Display the current step widget
                        child: _steps[state.currentStep],
                      ),
                    ),
                  ],
                ),
                // Fixed Bottom Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).cardColor, // Background color for the curved container
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25.0), // Curved top left corner
                        topRight: Radius.circular(
                          25.0,
                        ), // Curved top right corner
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 20.0,
                    ), // Padding inside the container
                    child: ElevatedButton(
                      onPressed: state.isCurrentStepValid
                          ? () {
                              if (state.currentStep < _steps.length - 1) {
                                // For non-last steps, validate the form before moving to the next step
                                final isFormValid =
                                    _formKey.currentState?.validate() ?? false;

                                if (isFormValid) {
                                  // Move to next step
                                  context.read<VolunteerProfileBloc>().add(
                                    ChangeStep(state.currentStep + 1),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('FillFields'.tr())),
                                  );
                                }
                              } else {
                                // Last step - submit the form without form validation (social media fields are all optional)
                                context.read<VolunteerProfileBloc>().add(
                                  const SubmitVolunteerProfile(),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF00796B,
                        ), // Teal color from screenshot
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ), // Slightly less rounded than container
                        ),
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ), // Full width button relative to container padding
                      ),
                      child: Text(
                        state.currentStep < _steps.length - 1
                            ? 'next'.tr()
                            : 'submit'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                        ), // White text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
        ),
    );
  }
}
