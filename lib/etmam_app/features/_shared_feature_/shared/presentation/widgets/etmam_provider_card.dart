import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CallButton,
        CustomInkWellButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        DrawLineWidget,
        EtmamProviderLogoIcon,
        EtmamRatingEvaluationWidget,
        ProviderButtons,
        SubmitButton;
import 'package:flutter/material.dart';

class EtmamProviderCard extends StatelessWidget {
  final String providerName;
  final String? providerIcon;
  final String? providerBg;
  final double providerRating;
  final double providerTotalEvaluation;
  final VoidCallback? onCallPressed;
  final VoidCallback? onSubmitPressed;
  final VoidCallback? onCardPressed;
  final Widget? buttonWidget;
  final double cardHeight;
  final String? buttonTxt;
  final bool? showDivider;

  const EtmamProviderCard(
      {Key? key,
      required this.providerName,
      required this.providerRating,
      required this.providerTotalEvaluation,
      this.providerIcon,
      this.providerBg,
      this.onSubmitPressed,
      this.onCallPressed,
      this.onCardPressed,
      this.buttonWidget,
      this.cardHeight = 285,
      this.buttonTxt,
      this.showDivider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: onCardPressed,
      widget: Container(
        height: cardHeight,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        margin: const EdgeInsetsDirectional.only(
            bottom: 12, start: 16, end: 16, top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 0)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          EtmamProviderLogoIcon(imageUrl: providerIcon ?? ""),
          CustomVerticalSpace(height: 14),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    providerName,
                    fontSize: 17,
                    fontColor: AppColor.black,
                    fontWeight: AppFontWeight.bold,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  CustomVerticalSpace(height: 20),
                  EtmamRatingEvaluationWidget(
                    rating: providerRating,
                    totalEvaluation: providerTotalEvaluation,
                    withDot: false,
                  ),
                  if (onCallPressed != null ||
                      onSubmitPressed != null ||
                      buttonWidget != null ||
                      showDivider == true) ...[
                    Spacer(),
                    DrawLineWidget(
                      lineColor:
                          Color(0xffe6e6e6).withOpacity(0.2000000029802322),
                      verticalMargin: 16,
                    ),
                  ],
                  if (onCallPressed != null && onSubmitPressed != null)
                    ProviderButtons(
                        buttonTxt: buttonTxt,
                        onCallPressed: onCallPressed ?? () {},
                        onDelegatePress: onSubmitPressed ?? () {}),
                  if (onCallPressed != null && onSubmitPressed == null)
                    CallButton(
                      onPressed: onCallPressed ?? () {},
                    ),
                  if (onCallPressed == null && onSubmitPressed != null)
                    SubmitButton(
                      btnTxt: buttonTxt,
                      onPressed: onSubmitPressed ?? () {},
                    ),
                  if (onCallPressed == null &&
                      onSubmitPressed == null &&
                      buttonWidget != null)
                    buttonWidget ?? Container()
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
