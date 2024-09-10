import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'title_with_widget.dart';

///  This Map on enum [NormalSearchType.byContractorEngineeringOfficeName]
class VerifiedBySecondWidget extends StatelessWidget {
  const VerifiedBySecondWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithWidget(
          title: 'the_contractor',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "enter_contractor_name".tr(),
            ),
            validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
        const SizedBox(height: 18),
        TitleWithWidget(
          title: 'engineering_office',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "enter_office_name".tr(),
            ),
            validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
      ],
    );
  }
}
