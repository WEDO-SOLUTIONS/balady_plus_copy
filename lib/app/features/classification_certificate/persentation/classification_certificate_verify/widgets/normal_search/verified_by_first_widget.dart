import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../title_with_widget.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';


///  This Map on enum [NormalSearchType.byCertificationNumber]
class VerifiedByFirstWidget extends StatelessWidget {
  const VerifiedByFirstWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithWidget(
          title: 'certificate_number',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "enter_number".tr(),
            ),
            validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
      ],
    );
  }
}
