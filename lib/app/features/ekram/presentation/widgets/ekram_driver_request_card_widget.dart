import 'package:balady_new_app/app/features/ekram/ekram_exports.dart'
    show EkramHeaderAndDescWidget, EkramStatusWidget, TransportRequestItem;
import 'package:flutter/material.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart';
import '../../../../core/core_exports.dart';

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
    return Container(
      height: 300,
      padding: const EdgeInsets.only(top: Constants.mediumPadding),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: new BoxDecoration(
        color: AppColors.white,
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
            lineColor: AppColors.black200.withOpacity(0.2000000029802322),
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
                      details: getFormattedDateEkramCard(
                          ekramTransportationItem.requestDate ?? ""),
                    )),
                    CustomHorizontalSpace(width: 12),
                    // transportationDestination

                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('ekram_assign_Date'),
                      details: getFormattedDateEkramCard(
                          ekramTransportationItem.driverAssignDate ?? ""),
                    ))
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          DrawLineWidget(
            lineColor: AppColors.black200.withOpacity(0.2000000029802322),
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
                  btnTextColor: AppColors.darkTurquoise,
                  btnTextSize: 16,
                  btnTextWeight: FONT_WEIGHT.medium,
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
                  btnTextColor: AppColors.darkTurquoise,
                  btnTextSize: 16,
                  btnTextWeight: FONT_WEIGHT.medium,
                  padding: const EdgeInsets.all(Constants.semiMediumPadding),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
