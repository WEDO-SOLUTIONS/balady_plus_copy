import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class ServiceProviderItem extends StatelessWidget {
  final String? providerName;
  final String? providerIcon;
  final double? providerTotalEvaluation;
  final double? providerRating;
  final String? contact;
  final Function? onPressView;
  final Function? onDelegate;
  final String? buttonTxt;

  const ServiceProviderItem(
      {Key? key,
      this.onPressView,
      this.onDelegate,
      this.providerIcon,
      this.providerName,
      this.providerRating,
      this.contact,
      this.providerTotalEvaluation,
      this.buttonTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EtmamProviderCard(
        buttonTxt: buttonTxt,
        providerName: providerName ?? "",
        providerIcon: providerIcon ?? "",
        providerTotalEvaluation: providerTotalEvaluation ?? 0,
        providerRating: providerRating ?? 0,
        onCardPressed: () {
          if (onPressView != null) {
            onPressView!();
          }
        },
        onCallPressed: () {
          CommonFunctions.call(contact);
        },
        onSubmitPressed: () {
          if (onDelegate != null) {
            onDelegate!();
          }
        });
  }
}
