import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_item.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/offer_page/cost_item_widget.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomElevatedButtonWidget,
        CustomHorizontalSpace,
        CustomInkWellButtonWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        EtmamProviderLogoIcon,
        EtmamRatingEvaluationWidget,
        ServiceProviderItemHeader,
        SubTitleAndWidget;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show
        AppColor,
        AppColorsTheme,
        AppFontWeight,
        ButtonIconPosition,
        IconPath,
        trans;
import 'package:flutter_svg/svg.dart';

class OfferCard extends StatelessWidget {
  final String providerName;
  final String? providerIcon;
  final String? value;
  final String? notes;
  final double? rating;
  final VoidCallback onAcceptPressed;
  final VoidCallback onCancelPressed;
  final String? acceptTxt;
  final String? cancelTxt;
  final bool? showAccept;
  final bool? showCancel;

  final double cardHeight;
  final bool isOfferAccepted;
  final String? financialAttachmentId;
  final String? technicalAttachmentId;
  final Function onPress;

  const OfferCard(
      {Key? key,
      required this.providerName,
      this.providerIcon,
      this.cardHeight = 300,
      required this.onAcceptPressed,
      required this.onCancelPressed,
      required this.onPress,
      this.acceptTxt,
      this.cancelTxt,
      this.rating,
      this.value,
      this.notes,
      this.showAccept,
      this.showCancel,
      this.isOfferAccepted = false,
      this.financialAttachmentId,
      this.technicalAttachmentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: () => onPress(),
      widget: Container(
        height: cardHeight,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        margin: const EdgeInsetsDirectional.only(
            bottom: 12, start: 16, end: 16, top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      EtmamProviderLogoIcon(imageUrl: providerIcon ?? ""),
                      CustomHorizontalSpace(width: 8),
                      Flexible(
                        child: CustomTextWidget(
                          providerName,
                          fontSize: 17,
                          fontColor: AppColor.black,
                          fontWeight: AppFontWeight.bold,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  CustomVerticalSpace(height: 16),
                  RatingStar(
                    rating: rating ?? 0,
                  ),
                  CustomVerticalSpace(height: 16),
                  CostItemWidget(
                      cost: value,
                      notes: notes,
                      technicalAttachmentId: technicalAttachmentId,
                      financialAttachmentId: financialAttachmentId),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showAccept ?? false)
                        Expanded(
                          child: AcceptButton(
                            btnTxt: acceptTxt,
                            onPressed: onAcceptPressed,
                          ),
                        ),
                      CustomHorizontalSpace(width: 16),
                      if (showCancel ?? false)
                        Expanded(
                          child: RejectButton(
                            btnTxt: cancelTxt,
                            onPressed: onCancelPressed,
                          ),
                        ),
                      if (isOfferAccepted)
                        CustomTextWidget(
                          trans("office_delegated"),
                          textAlign: TextAlign.center,
                          fontColor: AppColor.black700,
                        )
                    ],
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class RatingStar extends StatelessWidget {
  final double? rating;
  const RatingStar({super.key, this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SvgPicture.asset(
        IconPath.ratingStar,
        height: 10,
        width: 10,
        color: AppColor.baladyDarkGreen2,
      ),
      const CustomHorizontalSpace(width: 3.0),
      Container(
        margin: EdgeInsets.only(top: 3),
        child: CustomTextWidget(
          "$rating",
          fontColor: AppColor.black400,
          fontSize: 13.0,
          textAlign: TextAlign.start,
          maxLines: 1,
          fontWeight: AppFontWeight.bold,
          textOverflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}

class AcceptButton extends StatelessWidget {
  final Function onPressed;
  final String? btnTxt;

  AcceptButton({Key? key, required this.onPressed, this.btnTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      btnText: btnTxt ?? "",
      btnTextSize: 16,
      btnHeight: 48,
      btnRadius: 2,
      buttonIconPosition: ButtonIconPosition.left,
      btnTextColor: AppColor.white,
      btnTextWeight: AppFontWeight.medium,
      spaceBetweenTextAndIcon: 30,
      btnColor: AppColor.darkTurquoise,
      btnPadding: EdgeInsets.symmetric(horizontal: 16),
      mainAxisSize: MainAxisSize.max,
      icon: CustomSvgIconWidget(
        IconPath.acceptIcon,
        iconSize: 12,
        iconColor: AppColor.white,
      ),
      btnPressed: () => onPressed(),
    );
  }
}

class RejectButton extends StatelessWidget {
  final Function onPressed;
  final String? btnTxt;

  RejectButton({Key? key, required this.onPressed, this.btnTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButtonWidget(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      btnText: btnTxt ?? "",
      btnTextSize: 16,
      btnHeight: 48,
      btnRadius: 2,
      buttonIconPosition: ButtonIconPosition.left,
      btnTextColor: AppColor.redBrown,
      btnTextWeight: AppFontWeight.medium,
      spaceBetweenTextAndIcon: 30,
      btnColor: AppColor.white,
      icon: CustomSvgIconWidget(
        IconPath.close,
        iconSize: 12,
        iconColor: AppColor.redBrown,
      ),
      btnBorderColor: AppColor.redBrown,
      btnPadding: EdgeInsets.symmetric(horizontal: 16),
      mainAxisSize: MainAxisSize.max,
      btnPressed: () => onPressed(),
    );
  }
}
