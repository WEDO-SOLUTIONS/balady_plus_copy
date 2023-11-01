import 'package:flutter/material.dart';

import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
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
          label: "اسم المالك",
          hintText: "اسم المالك",
          initialValue: item.ownerName,
          bottomMargin: 24,
          enabled: false,
          onChanged: (value) {},
        ),
        CustomTextFieldWidget(
          label: "رقم الهوية",
          hintText: "رقم الهوية",
          initialValue: item.identityNumber,
          bottomMargin: 24,
          enabled: false,
          onChanged: (value) {},
        ),
        CustomTextFieldWidget(
          label: "رقم الجوال",
          hintText: "رقم الجوال",
          initialValue: item.ownerMobileNumber,
          bottomMargin: 24,
          onChanged: (value) {
            item = item.copyWith(ownerMobileNumber: value);
          },
        ),
        CustomTextFieldWidget(
          label: "البريد الالكتروني",
          hintText: "البريد الالكتروني",
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
