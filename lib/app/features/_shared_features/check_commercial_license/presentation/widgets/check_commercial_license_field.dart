import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_features/check_commercial_license/data/data_sources/check_commercial_license_data_source.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CheckCommercialLicenseField extends StatefulWidget {
  final CheckCommercialLicenseDataSource dataSource;

  const CheckCommercialLicenseField({super.key, required this.dataSource});

  @override
  State<CheckCommercialLicenseField> createState() => _CheckCommercialLicenseFieldState();
}

class _CheckCommercialLicenseFieldState extends State<CheckCommercialLicenseField> {
  final TextEditingController _controller = TextEditingController();
  Future<void> _checkCommercialLicense(String licenseId) async {
    bool isValid = await widget.dataSource.checkCommercialLicense(licenseId);
    if (!isValid) {
      CommonFunctions.showError("invalid_license".tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "enter_license_id".tr(), border: const OutlineInputBorder()),
          onSubmitted: (id) async {
            await _checkCommercialLicense(id);
          },
        ),
      ],
    );
  }
}
