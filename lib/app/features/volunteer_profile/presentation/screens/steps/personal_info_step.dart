import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../bloc/volunteer_profile_bloc.dart';
import '../../bloc/volunteer_profile_event.dart';
import '../../bloc/volunteer_profile_state.dart';

class PersonalInfoStep extends StatefulWidget {
  const PersonalInfoStep({super.key});

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _relativePhoneController;
  String? _selectedRegionId;
  String? _selectedCityId;

  @override
  void initState() {
    super.initState();
    final state = context.read<VolunteerProfileBloc>().state;
    _phoneController = TextEditingController(text: state.phoneNumber ?? '');
    _emailController = TextEditingController(text: state.email ?? '');
    _relativePhoneController = TextEditingController(text: state.nearbyPhoneNumber ?? '');
    _selectedRegionId = state.regionId;
    _selectedCityId = state.cityId;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _relativePhoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    context.read<VolunteerProfileBloc>().add(
      UpdatePersonalInfo(
        email: _emailController.text,
        phoneNumber: value,
        nationalId: context.read<VolunteerProfileBloc>().state.nationalId,
        gender: context.read<VolunteerProfileBloc>().state.gender ?? '',
        maritalStatus: context.read<VolunteerProfileBloc>().state.maritalStatus,
        nearbyPhoneNumber: _relativePhoneController.text,
        region: context.read<VolunteerProfileBloc>().state.region,
        regionId: _selectedRegionId,
        city: context.read<VolunteerProfileBloc>().state.city,
        cityId: _selectedCityId,
      ),
    );
  }

  void _onEmailChanged(String value) {
    context.read<VolunteerProfileBloc>().add(
      UpdatePersonalInfo(
        email: value,
        phoneNumber: _phoneController.text,
        nationalId: context.read<VolunteerProfileBloc>().state.nationalId,
        gender: context.read<VolunteerProfileBloc>().state.gender ?? '',
        maritalStatus: context.read<VolunteerProfileBloc>().state.maritalStatus,
        nearbyPhoneNumber: _relativePhoneController.text,
        region: context.read<VolunteerProfileBloc>().state.region,
        regionId: _selectedRegionId,
        city: context.read<VolunteerProfileBloc>().state.city,
        cityId: _selectedCityId,
      ),
    );
  }

  void _onRelativePhoneChanged(String value) {
    context.read<VolunteerProfileBloc>().add(
      UpdatePersonalInfo(
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        nationalId: context.read<VolunteerProfileBloc>().state.nationalId,
        gender: context.read<VolunteerProfileBloc>().state.gender ?? '',
        maritalStatus: context.read<VolunteerProfileBloc>().state.maritalStatus,
        nearbyPhoneNumber: value,
        region: context.read<VolunteerProfileBloc>().state.region,
        regionId: _selectedRegionId,
        city: context.read<VolunteerProfileBloc>().state.city,
        cityId: _selectedCityId,
      ),
    );
  }

  void _onRegionChanged(String? value, VolunteerProfileState state) {
    if (value != null) {
      final selectedRegion = state.regionsList.firstWhere((region) => region.tid.toString() == value);
      setState(() {
        _selectedRegionId = value;
        _selectedCityId = null;
      });
      context.read<VolunteerProfileBloc>().add(
        UpdatePersonalInfo(
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          nationalId: state.nationalId,
          gender: state.gender,
          maritalStatus: state.maritalStatus,
          nearbyPhoneNumber: _relativePhoneController.text,
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
      final selectedCity = state.citiesList.firstWhere((city) => city.tid.toString() == value);
      setState(() {
        _selectedCityId = value;
      });
      context.read<VolunteerProfileBloc>().add(
        UpdatePersonalInfo(
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          nationalId: state.nationalId,
          gender: state.gender,
          maritalStatus: state.maritalStatus,
          nearbyPhoneNumber: _relativePhoneController.text,
          region: state.region,
          regionId: _selectedRegionId,
          city: selectedCity.name,
          cityId: value,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<VolunteerProfileBloc, VolunteerProfileState>(
    builder: (context, state) {
      // Keep controllers in sync with state
      if (_phoneController.text != (state.phoneNumber ?? '')) {
        _phoneController.text = state.phoneNumber ?? '';
      }
      if (_emailController.text != (state.email ?? '')) {
        _emailController.text = state.email ?? '';
      }
      if (_relativePhoneController.text != (state.nearbyPhoneNumber ?? '')) {
        _relativePhoneController.text = state.nearbyPhoneNumber ?? '';
      }
      if (_selectedRegionId != state.regionId) {
        _selectedRegionId = state.regionId;
      }
      if (_selectedCityId != state.cityId) {
        _selectedCityId = state.cityId;
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('lbl_personal_info'.tr(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('lbl_fill_required_fields'.tr(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // National ID (read-only)
            Text('national_id'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.nationalId,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: state.isNationalIdFromApi,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Full Name (read-only)
            Text('full_name'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.fullName ?? '',
              decoration: InputDecoration(
                hintText: 'full_name'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),

            // First Name (read-only)
            Text('lbl_first_name_hint1'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.firstName,
              decoration: InputDecoration(
                hintText: 'lbl_first_name_hint1'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),

            // Middle Name (read-only)
            Text('ekram_second_name'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.middleName,
              decoration: InputDecoration(
                hintText: 'ekram_second_name'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),

            // Last Name (read-only)
            Text('last_name'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.lastName,
              decoration: InputDecoration(
                hintText: 'last_name'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),

            // Birth Date (read-only)
            Text('lbl_birth_date'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.dateOfBirth,
              decoration: InputDecoration(
                hintText: 'lbl_birth_date'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),

            // Gender (read-only)
            Text('personal_gender'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.gender,
              decoration: InputDecoration(
                labelText: 'personal_gender'.tr(),
                border: const OutlineInputBorder(),
                filled: state.isGenderFromApi,
                fillColor: state.isGenderFromApi ? Colors.grey[200] : null,
              ),
            ),

            // Nationality (read-only)
            const SizedBox(height: 16),
            Text('nationality'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.nationality,
              decoration: InputDecoration(
                hintText: 'nationality'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),

            const SizedBox(height: 16),
            // Marital Status (read-only)
            Text('marital_status'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: state.maritalStatus,
              decoration: InputDecoration(
                hintText: 'marital_status'.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),

            const SizedBox(height: 16),
            // Phone (editable, required)
            Text('${'personal_mobile'.tr()} *', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: '966500000000+',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => Helpers.validateMobile(value),
              onChanged: _onPhoneChanged,
            ),
            const SizedBox(height: 16),
            // Relative Phone (editable)
            Text('relative_phone_number'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _relativePhoneController,
              decoration: InputDecoration(
                hintText: '966500000000+',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              ),
              keyboardType: TextInputType.phone,
              onChanged: _onRelativePhoneChanged,
            ),
            const SizedBox(height: 16),
            // Email (editable, required)
            Text('${'email'.tr()} *', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Helpers.validateEmail(value),
              onChanged: _onEmailChanged,
            ),
            const SizedBox(height: 16),
            // Region (editable, required)
            Text('${'region'.tr()} *', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (state.isLoadingRegions)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<String>(
                initialValue: _selectedRegionId?.isEmpty == true ? null : _selectedRegionId,
                decoration: InputDecoration(
                  hint: Text('region'.tr()),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                ),
                items: state.regionsList
                    .map(
                      (region) => DropdownMenuItem<String>(
                        value: region.tid.toString(),
                        child: Center(
                          child: Text(
                            region.name,
                            style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
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
            Text('${'city'.tr()} *', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (state.isLoadingCities)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<String>(
                initialValue: _selectedCityId?.isEmpty == true ? null : _selectedCityId,
                decoration: InputDecoration(
                  hint: Text('city'.tr()),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                ),
                items: state.citiesList
                    .map(
                      (city) => DropdownMenuItem<String>(
                        value: city.tid.toString(),
                        child: Center(
                          child: Text(
                            city.name,
                            style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
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
            const SizedBox(height: 80),
          ],
        ),
      );
    },
  );
}
