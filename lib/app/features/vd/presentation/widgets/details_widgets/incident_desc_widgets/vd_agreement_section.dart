import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_check_box_widget.dart';

class VdAgreementSection extends StatefulWidget {
  Function(bool checked) onChecked;
  final bool? initalChecked;

  VdAgreementSection({required this.onChecked, this.initalChecked});

  @override
  State<VdAgreementSection> createState() => _VdAgreementSection();
}

class _VdAgreementSection extends State<VdAgreementSection> {
  bool checked = false;

  @override
  void initState() {
    super.initState();
    checked = widget.initalChecked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCheckBoxTopStartWidget(
        onSelected: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
          checked = value ?? false;
          widget.onChecked(checked);
        },
        backgroundColor: Colors.transparent,
        checkboxValue: checked,
        containerBackgroundColor: AppColor.white4,
        borderSelectedColor: Colors.transparent,
        borderColor: Colors.transparent,
        checkBoxAlignment: AlignmentDirectional.topStart,
        titleSize: 14,
        checkboxSize: 1,
        verticalPadding: 5,
        title: ("consent_body").tr());
  }
}
