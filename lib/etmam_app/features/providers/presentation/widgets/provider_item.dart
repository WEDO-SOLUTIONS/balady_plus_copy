import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';

import 'package:flutter/material.dart';

class ProviderItemWidget extends StatelessWidget {
  final String? providerName;
  final String? providerIcon;
  final double? providerTotalEvaluation;
  final double? providerRating;
  final String? contact;
  final Function? onPressView;
  final Function? onDelegate;
  final String? buttonTxt;

  const ProviderItemWidget(
      {Key? key,
      this.onPressView,
      this.onDelegate,
      this.providerIcon,
      this.providerName,
      this.providerRating,
      this.contact,
      this.buttonTxt,
      this.providerTotalEvaluation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressView != null) {
          onPressView!();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColor.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CustomNetworkImageWidget(
                    providerIcon ?? "",
                    imageHeight: 58,
                    imageWidth: 58,
                    imageFit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        providerName ?? '',
                        fontColor: AppColor.black800,
                        fontSize: 16,
                        maxLines: 2,
                        fontWeight: AppFontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      EtmamRatingEvaluationWidget(
                        withDot: false,
                        rating: providerRating,
                        totalEvaluation: providerTotalEvaluation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            ProviderButtons(
              buttonTxt: buttonTxt,
              btnSize: 42,
              onCallPressed: () {
                CommonFunctions.call(contact);
              },
              onDelegatePress: onDelegate,
            ),
          ],
        ),
      ),
    );
  }
}

// EtmamServiceProviderItem(
//   providerName: providerName ?? "",
//   providerIcon: providerIcon ?? "",
//   totalEvaluation: providerTotalEvaluation ?? 0,
//   providerRating: providerRating ?? 0,
//   onPress: () {
//     if (onPressView != null) {
//       onPressView!();
//     }
//
//     /* context.read<ProvidersBloc>().add(GetServiceDetailsEvent(
//               params: ServiceDetailsParams(
//                   serviceProviderId: item.id!,
//                   cityId: "1",
//                   subServiceId: state.subServiceId!)));*/
//   },
//   // onCallPressed: () {
//   //   CommonFunctions.call(contact);
//   // },
// ),
