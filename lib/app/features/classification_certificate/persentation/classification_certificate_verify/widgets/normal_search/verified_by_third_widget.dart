import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../title_with_widget.dart';

///  This Map on enum [NormalSearchType.byCommercialRegistrationNoEngineeringOfficeLicenseNumber]
class VerifiedByThirdWidget extends StatelessWidget {

  const VerifiedByThirdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithWidget(
          title: 'commercial_registration',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "enter_commercial_registration".tr(),
            ),
            validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
        const SizedBox(height: 18),
        TitleWithWidget(
          title: 'engineering_office_license',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "enter_engineering_office_license".tr(),
            ),
            validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
      ],
    );
  }
}
