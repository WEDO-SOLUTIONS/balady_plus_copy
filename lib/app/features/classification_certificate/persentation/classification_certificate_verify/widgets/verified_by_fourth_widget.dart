import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'title_with_widget.dart';

///  This Map on enum [NormalSearchType.byNationalID]
class VerifiedByFourthWidget extends StatelessWidget {
  const VerifiedByFourthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithWidget(
          title: 'id_number_type',
          widget: DropdownMenu<String>(
            //initialSelection: menuItems.first,
            // controller: menuController,
            width: double.maxFinite,
            expandedInsets: EdgeInsets.zero,
            hintText: "select_type_two".tr(),
            requestFocusOnTap: true,
            enableFilter: true,
            trailingIcon: Image.asset(
              IconPath.arrowCircleDown,
              width: 24,
              height: 24,
            ),
            onSelected: (String? menu) {
            },
            dropdownMenuEntries: ["menuItems", "String", "test"]
                .map<DropdownMenuEntry<String>>((String menu) {
              return DropdownMenuEntry<String>(
                value: menu,
                label: menu,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),
        TitleWithWidget(
          title: 'id_number_two',
          widget: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "enter_id_number_two".tr(),
            ),
            validator: (text) => (text?.isNotEmpty ?? true) ? "" : null,
          ),
        ),
      ],
    );
  }
}
