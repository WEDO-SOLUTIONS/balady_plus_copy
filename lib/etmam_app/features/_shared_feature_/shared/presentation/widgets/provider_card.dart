import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CallButton,
        CustomInkWellButtonWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        DrawLineWidget,
        ProviderButtons,
        ProviderLogoIcon,
        RatingEvaluationWidget,
        SubmitButton;
import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
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

  const ProviderCard(
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
      this.cardHeight = 267,
      this.buttonTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: onCardPressed,
      widget: Container(
        height: cardHeight,
        margin: const EdgeInsetsDirectional.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.white,
          boxShadow: const [
            BoxShadow(
                color: Color(0x14d1d5db),
                offset: Offset(-2, 4),
                blurRadius: 8,
                spreadRadius: 0)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ServiceProviderItemHeader(
            imageUrl: providerIcon ?? "",
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                  top: 12.0, start: 16, end: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 8),
                    child: CustomTextWidget(
                      providerName,
                      fontSize: 14,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      fontColor: AppColor.black,
                      fontWeight: AppFontWeight.medium,
                    ),
                  ),
                  RatingEvaluationWidget(
                    rating: providerRating,
                    totalEvaluation: providerTotalEvaluation,
                  ),
                  if (onCallPressed != null ||
                      onSubmitPressed != null ||
                      buttonWidget != null) ...[
                    Spacer(),
                    const DrawLineWidget(
                      lineColor: Color(0xffe5e7eb),
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
          )
        ]),
      ),
    );
  }
}

class ServiceProviderItemHeader extends StatelessWidget {
  final String imageUrl;
  final String? backGround;
  final bool smallCard;

  const ServiceProviderItemHeader(
      {Key? key,
      required this.imageUrl,
      this.backGround,
      this.smallCard = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: Stack(children: [
        ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: SizedBox(
                height: 80,
                width: double.infinity,
                child: CustomSvgIconWidget(
                  smallCard
                      ? IconPath.providerSmallCardBg
                      : IconPath.defaultCardBackground,
                  iconHeight: 80,
                  iconWidth: double.infinity,
                  iconFit: BoxFit.fill,
                ))),
        Align(
          alignment: AlignmentDirectional.bottomStart,
          child: ProviderLogoIcon(
            imageUrl: imageUrl,
            imageMargin: const EdgeInsetsDirectional.only(start: 16),
          ),
        )
      ]),
    );
  }
}
