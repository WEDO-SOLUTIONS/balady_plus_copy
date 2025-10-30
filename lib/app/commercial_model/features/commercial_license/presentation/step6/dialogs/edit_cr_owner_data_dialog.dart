import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../data/models/qr/apply_commercial_response_model.dart';

class EditCrOwnerDataDialog extends StatefulWidget {
  final CrOwner item;
  const EditCrOwnerDataDialog({super.key, required this.item});

  @override
  State<EditCrOwnerDataDialog> createState() => _EditCrOwnerDataDialogState();
}

class _EditCrOwnerDataDialogState extends State<EditCrOwnerDataDialog> {
  late CrOwner item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFieldWidget(
          label: "owner_name".tr(),
          hintText: "owner_name".tr(),
          initialValue: item.ownerName,
          bottomMargin: 24,
          enabled: false,
          onChanged: (value) {},
        ),
        CustomTextFieldWidget(
          label: "owner_id".tr(),
          hintText: "owner_id".tr(),
          initialValue: item.identityNumber,
          bottomMargin: 24,
          enabled: false,
          onChanged: (value) {},
        ),
        CustomTextFieldWidget(
          label: "owner_number".tr(),
          hintText: "owner_number".tr(),
          initialValue: item.ownerMobileNumber,
          bottomMargin: 24,
          onChanged: (value) {
            item = item.copyWith(ownerMobileNumber: value);
          },
        ),
        CustomTextFieldWidget(
          label: "email".tr(),
          hintText: "email".tr(),
          initialValue: item.ownerEmail,
          bottomMargin: 24,
          onChanged: (value) {
            item = item.copyWith(ownerEmail: value);
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButtonWidget.apply(onPressed: () {
          Navigator.pop(context, item);
        })
      ],
    );
  }
}
