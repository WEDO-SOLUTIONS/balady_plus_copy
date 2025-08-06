import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/volunteer_profile_bloc.dart';
import '../../bloc/volunteer_profile_event.dart';
import '../../bloc/volunteer_profile_state.dart';

class SocialMeidaInformationStep extends StatefulWidget {
  const SocialMeidaInformationStep({super.key});

  @override
  State<SocialMeidaInformationStep> createState() =>
      _SocialMeidaInformationStepState();
}

class _SocialMeidaInformationStepState
    extends State<SocialMeidaInformationStep> {
  late TextEditingController _xAccountController;
  late TextEditingController _instagramController;
  late TextEditingController _linkedinController;
  late TextEditingController _facebookController;

  @override
  void initState() {
    super.initState();
    _xAccountController = TextEditingController();
    _instagramController = TextEditingController();
    _linkedinController = TextEditingController();
    _facebookController = TextEditingController();
  }

  @override
  void dispose() {
    _xAccountController.dispose();
    _instagramController.dispose();
    _linkedinController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<VolunteerProfileBloc, VolunteerProfileState>(
        builder: (context, state) {
          // Update controllers with state values if they've changed
          if (_xAccountController.text != (state.xAccount ?? '')) {
            _xAccountController.text = state.xAccount ?? '';
          }
          if (_instagramController.text != (state.instagramAccount ?? '')) {
            _instagramController.text = state.instagramAccount ?? '';
          }
          if (_linkedinController.text != (state.linkedinAccount ?? '')) {
            _linkedinController.text = state.linkedinAccount ?? '';
          }
          if (_facebookController.text != (state.facebookAccount ?? '')) {
            _facebookController.text = state.facebookAccount ?? '';
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 120.0,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'بيانات التواصل الاجتماعي',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'جميع الحقول اختيارية',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // X Account Field
                _buildSocialMediaField(
                  label: 'حساب إكس',
                  controller: _xAccountController,
                  onChanged: (value) {
                    context.read<VolunteerProfileBloc>().add(
                          UpdateSocialMediaInfo(
                            xAccount: value.isNotEmpty ? value : null,
                            instagramAccount: state.instagramAccount,
                            linkedinAccount: state.linkedinAccount,
                            facebookAccount: state.facebookAccount,
                          ),
                        );
                  },
                ),
                const SizedBox(height: 20),

                // Instagram Account Field
                _buildSocialMediaField(
                  label: 'حساب الانستقرام',
                  controller: _instagramController,
                  onChanged: (value) {
                    context.read<VolunteerProfileBloc>().add(
                          UpdateSocialMediaInfo(
                            xAccount: state.xAccount,
                            instagramAccount: value.isNotEmpty ? value : null,
                            linkedinAccount: state.linkedinAccount,
                            facebookAccount: state.facebookAccount,
                          ),
                        );
                  },
                ),
                const SizedBox(height: 20),

                // LinkedIn Account Field
                _buildSocialMediaField(
                  label: 'حساب لينكدان',
                  controller: _linkedinController,
                  onChanged: (value) {
                    context.read<VolunteerProfileBloc>().add(
                          UpdateSocialMediaInfo(
                            xAccount: state.xAccount,
                            instagramAccount: state.instagramAccount,
                            linkedinAccount: value.isNotEmpty ? value : null,
                            facebookAccount: state.facebookAccount,
                          ),
                        );
                  },
                ),
                const SizedBox(height: 20),

                // Facebook Account Field
                _buildSocialMediaField(
                  label: 'حساب الفيس بوك',
                  controller: _facebookController,
                  onChanged: (value) {
                    context.read<VolunteerProfileBloc>().add(
                          UpdateSocialMediaInfo(
                            xAccount: state.xAccount,
                            instagramAccount: state.instagramAccount,
                            linkedinAccount: state.linkedinAccount,
                            facebookAccount: value.isNotEmpty ? value : null,
                          ),
                        );
                  },
                ),
                SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 120
                        : 40),
              ],
            ),
          );
        },
      );

  Widget _buildSocialMediaField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            textDirection: TextDirection.ltr,
            scrollPadding: const EdgeInsets.only(bottom: 300),
            decoration: InputDecoration(
              hintText: '@user',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Color(0xFF00796B),
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      );
}
