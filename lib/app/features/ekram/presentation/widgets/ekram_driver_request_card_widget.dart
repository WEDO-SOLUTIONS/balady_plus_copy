import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../objectable_transactions/presentation/widgets/request_parameter.dart';
import '../../domain/entities/deceased_transport_requests/transport_request_item.dart';
import 'ekram_status_widget.dart';

class EkramDriverRequestCardWidget extends StatelessWidget {
  final TransportRequestItem ekramTransportationItem;
  final Function OnDetailsPress;
  const EkramDriverRequestCardWidget(
      {Key? key,
      required this.ekramTransportationItem,
      required this.OnDetailsPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => OnDetailsPress(),
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColor.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const DrawIconBasedTypeWidget(icon: IconPath.requests),
                CustomHorizontalSpace(
                  width: 4,
                ),
                Expanded(
                  child: CustomTextWidget(
                    '#${ekramTransportationItem.requestId.toString()}',
                    textStyle: AppStyle.requestNumberTextStle,
                    textAlign: TextAlign.start,
                  ),
                ),
                HomeTag(
                  title: ekramTransportationItem.requestStatus ?? "",
                  backgroundColor: AppColor.secondary100Light,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                children: [
                  RequestParameter(
                    title: 'transportationType'.tr(),
                    value: ekramTransportationItem.getCityType() ?? "",
                  ),
                  RequestParameter(
                    title: 'burialCity'.tr(),
                    value: ekramTransportationItem.deathCityName ?? "",
                  ),
                  if (ekramTransportationItem.multipleCityRequest == true)
                    RequestParameter(
                      title: 'burial_city'.tr(),
                      value: ekramTransportationItem.burialCityName ?? "",
                    ),
                  RequestParameter(
                    title: 'transportationStatus'.tr(),
                    value:
                        ekramTransportationItem.deathTransferStatusDesc ?? "",
                  ),
                  RequestParameter(
                    title: 'deceasedName'.tr(),
                    value: ekramTransportationItem.deceasedName ?? "",
                  ),
                  RequestParameter(
                    title: 'driver_card_applicant_date'.tr(),
                    value: CommonFunctions.getFormattedDateEkramCard(
                        ekramTransportationItem.requestDate ?? ""),
                  ),
                  RequestParameter(
                    title: 'ekram_assign_Date'.tr(),
                    value: CommonFunctions.getFormattedDateEkramCard(
                        ekramTransportationItem.driverAssignDate ?? ""),
                  ),
                  RequestParameter(
                    title: 'transportationDestination'.tr(),
                    value: ekramTransportationItem.currentStationName ?? "",
                  )
                  /* RequestParameter(
                    title: 'transportationStatus'.tr(),
                    value: ekramTransportationItem
                            .deceasedTransportRequestStatus ??
                        "",
                  ),
                  RequestParameter(
                    title: 'transportationDestination'.tr(),
                    value: ekramTransportationItem.currentStationName ?? "",
                  ),*/
                ],
              ),
            ),
            ElevatedButtonWidget.primaryCustom(
                height: 40,
                onPressed: () => OnDetailsPress(),
                text: "details".tr())
          ],
        ),
      ),
    );

    /*  return Container(
      height: 300,
      padding: const EdgeInsets.only(top: Constants.mediumPadding),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: new BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
              color: Color(0x19000000),
              offset: Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 0)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // order no
                      DetailsInfoWithImgSvg(
                        img: IconPath.hashtag,
                        title: ekramTransportationItem.requestId.toString(),
                      ),
                      CustomHorizontalSpace(width: 12),
                      // order status
                      EkramStatusWidget(
                        status: ekramTransportationItem.requestStatus ?? "",
                      ),
                    ],
                  ),
                ),
                CustomHorizontalSpace(width: 5),
                // order action icon
                /* CustomIconButtonWidget(
                  btnPressed: () {},
                  svgIcon: "assets/icons/moreAction.svg",
                )*/
              ],
            ),
          ),
          const CustomVerticalSpace(height: 16),
          DrawLineWidget(
            horizontalMargin: Constants.smallPadding,
            lineColor: AppColor.black200.withOpacity(0.2000000029802322),
          ),
          const CustomVerticalSpace(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomHorizontalSpace(width: 12),
                    // transportationType
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('transportationType'),
                      details: ekramTransportationItem.getCityType() ?? "",
                    )),
                    CustomHorizontalSpace(width: 12),

                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('burialCity'),
                      details: ekramTransportationItem.deathCityName ?? "",
                    )),
                  ],
                ),
                //  Spacer(),
                const CustomVerticalSpace(height: 20),
                Row(
                  children: [
                    // transportationStatus
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('transportationStatus'),
                      details:
                          ekramTransportationItem.deathTransferStatusDesc ?? "",
                    )),
                    CustomHorizontalSpace(width: 12),
                    // transportationDestination

                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('deceasedName'),
                      details: ekramTransportationItem.deceasedName ?? "",
                    ))
                  ],
                ),

                const CustomVerticalSpace(height: 20),
                Row(
                  children: [
                    // transportationStatus
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('driver_card_applicant_date'),
                      details: CommonFunctions.getFormattedDateEkramCard(
                          ekramTransportationItem.requestDate ?? ""),
                    )),
                    CustomHorizontalSpace(width: 12),
                    // transportationDestination

                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('ekram_assign_Date'),
                      details: CommonFunctions.getFormattedDateEkramCard(
                          ekramTransportationItem.driverAssignDate ?? ""),
                    ))
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          DrawLineWidget(
            lineColor: AppColor.black200.withOpacity(0.2000000029802322),
          ),
          CustomGoToDetailsButtonWidget(
              onPressed: () => OnDetailsPress(),
              label: trans(
                  'customerVoiceLatestRequestsSectionGoToDetailsButtonWord')),
          /*  Row(
            children: [
              // tracking button
              Expanded(
                child: CustomTextButtonWithIconWidgetWithFlexible(
                  btnPressed: () {},
                  btnText: trans('trafficTracking'),
                  icon: CustomSvgIconWidget(
                    "assets/icons/tracking.svg",
                    iconHeight: 18,
                    iconWidth: 18,
                  ),
                  buttonIconPosition: BUTTON_ICON_POSITION.right,
                  btnTextColor: AppColor.primary900Light,
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.medium,
                  padding: const EdgeInsets.all(Constants.semiMediumPadding),
                ),
              ),
              DrawLineWidget(
                lineWidth: 1,
                lineHeight: 30,
                lineColor: AppColors.black200.withOpacity(0.2000000029802322),
              ),
              // go to details button
              Expanded(
                child: CustomTextButtonWithIconWidgetWithFlexible(
                  btnPressed: () {
                    NavigationService.navigatorKey.currentState!.pushNamed(
                        RoutesNames.ekramTransportationDetailsScreen);
                  },
                  btnText: trans(
                      'customerVoiceLatestRequestsSectionGoToDetailsButtonWord'),
                  icon: CustomSvgIconWidget(
                    "assets/icons/detailsIcon.svg",
                    iconHeight: 18,
                    iconWidth: 18,
                  ),
                  buttonIconPosition: BUTTON_ICON_POSITION.right,
                  btnTextColor: AppColor.primary900Light,
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.medium,
                  padding: const EdgeInsets.all(Constants.semiMediumPadding),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );*/
  }
}

class DetailsInfoWithImgSvg extends StatelessWidget {
  final String img;
  final String title;
  final bool withGreenImg;
  final bool fromHeader;
  final Color textColor;
  final bool fontFamilyNumber;
  final double iconHeight;
  final double iconWidth;

  const DetailsInfoWithImgSvg(
      {Key? key,
      required this.img,
      required this.title,
      this.withGreenImg = false,
      this.fromHeader = false,
      this.fontFamilyNumber = true,
      this.iconHeight = 14,
      this.iconWidth = 14,
      this.textColor = AppColor.gray})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomSvgIconWidget(
          img,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          iconColor:
              withGreenImg ? AppColor.greenishYellow500 : AppColor.black400,
        ),
        const CustomHorizontalSpace(width: 5),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(top: 2.2),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomTextWidget(
                title,
                fontSize: 13.0,
                fontWeight:
                    fromHeader ? AppFontWeight.bold : AppFontWeight.medium,
                fontColor: (fromHeader && textColor == AppColor.gray)
                    ? AppColor.black500
                    : textColor,
                textScaleFactor: 1,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontFamily: fontFamilyNumber
                    ? Constants.lucidaGrandFontType
                    : Constants.appFontType,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
