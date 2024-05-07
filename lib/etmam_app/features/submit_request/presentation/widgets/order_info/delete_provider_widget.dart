import 'package:flutter/material.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomIconButtonWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        EtmamProviderLogoIcon,
        EtmamRatingEvaluationWidget,
        ProviderLogoIcon,
        RatingEvaluationWidget;

class DeleteProviderWidget extends StatelessWidget {
  const DeleteProviderWidget(
      {Key? key,
      this.providerEvaluation,
      this.providerName,
      this.providerRating,
      this.providerLogoUrl,
      this.showDelete = false,
      required this.onDelete})
      : super(key: key);
  final String? providerLogoUrl;
  final String? providerName;
  final double? providerRating;
  final double? providerEvaluation;
  final Function onDelete;
  final bool showDelete;
  @override
  Widget build(BuildContext context) {
    return EtmamBorderContainerWidget(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            EtmamProviderLogoIcon(
              imageUrl: providerLogoUrl ?? "",
              imageSize: 38,
            ),
            const CustomHorizontalSpace(width: 13),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextWidget(
                  providerName ?? "",
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: 16,
                  fontWeight: AppFontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //         flex: 2,
                //         child: CustomTextWidget(
                //           name,
                //           maxLines: 1,
                //           textOverflow: TextOverflow.ellipsis,
                //           fontSize: 14,
                //           fontWeight: AppFontWeight.medium,
                //         )),
                //     // Expanded(
                //     //     flex: 1,
                //     //     child: CustomTextWidget(
                //     //       price,
                //     //       maxLines: 1,
                //     //       textOverflow: TextOverflow.ellipsis,
                //     //       fontSize: 12,
                //     //       fontWeight: AppFontWeight.medium,
                //     //       fontColor: AppColor.inProgressOrderTextColor,
                //     //     )),
                //   ],
                // ),
                EtmamRatingEvaluationWidget(
                  rating: providerRating,
                  totalEvaluation: providerEvaluation,
                ),
              ],
            )),
            if (showDelete)
              CustomIconButtonWidget(
                  padding: EdgeInsets.zero,
                  btnPressed: () => onDelete(),
                  icon: const CustomSvgIconWidget(
                    IconPath.deleteIcon,
                    iconWidth: 16,
                    iconHeight: 20,
                  ))
          ],
        ),
      ),
    );
  }
}

class GreyContainerWidget extends StatelessWidget {
  final Widget child;

  const GreyContainerWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
            color: AppColor.lightGrey,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              width: 0.5,
              color: AppColor.lightGrey,
            )),
        child: child);
  }
}

class EtmamBorderContainerWidget extends StatelessWidget {
  final Widget child;

  const EtmamBorderContainerWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 87,
        decoration: BoxDecoration(
            //   color: AppColor.lightGrey,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              width: 1,
              color: AppColor.black200,
            )),
        child: child);
  }
}
