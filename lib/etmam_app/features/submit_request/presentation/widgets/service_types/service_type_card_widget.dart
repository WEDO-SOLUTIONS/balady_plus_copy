import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class ServiceTypeCardWidget extends StatelessWidget {
  String? providerName;
  String? providerIcon;
  double? providerRating;
  double? providerTotalEvaluation;
  bool? isSelected;
  final Function onSelect;

  ServiceTypeCardWidget(
      {Key? key,
      required this.onSelect,
      this.providerIcon,
      this.providerName,
      this.providerRating,
      this.isSelected,
      this.providerTotalEvaluation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EtmamProviderCard(
      providerName: providerName ?? "",
      providerIcon: providerIcon ?? "",
      providerTotalEvaluation: providerTotalEvaluation ?? 0,
      providerRating: providerRating ?? 0,
      cardHeight: 288,
      showDivider: true,
      buttonWidget: EtmamCustomPrimaryButton(
        onPressed: () => onSelect(),
        btnText: (isSelected ?? false)
            ? trans('choose_done')
            : trans('choose_provider'),
        btnHeight: 48,
        btnColor:
            (isSelected ?? false) ? AppColor.darkTurquoise : AppColor.white,
        btnBorderColor:
            (isSelected ?? false) ? Colors.transparent : AppColor.darkTurquoise,
        textColor:
            (isSelected ?? false) ? AppColor.white : AppColor.darkTurquoise,
      ),
    );
  }
}
