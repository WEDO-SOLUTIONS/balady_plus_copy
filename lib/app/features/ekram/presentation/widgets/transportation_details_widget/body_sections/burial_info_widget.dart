import 'package:balady_new_app/app/core/core_exports.dart'
    show
    AppColors,
    BUTTON_ICON_POSITION,
    Constants,
    CustomEnhancedExpansionPanelWidget,
    CustomSvgIconWidget,
    CustomTextButtonWithIconWidgetWithFlexible,
    CustomTextWidget,
    CustomTitleSubtitleCardWidget,
    FONT_WEIGHT,
    Helpers;
import 'package:flutter/material.dart';

class BurialInfoWidget extends StatelessWidget {
  const BurialInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEnhancedExpansionPanelWidget(
      underline: false,
      title: Helpers.translatingWord(
        "burialInfo",
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("burialCity"),
            subtitle: 'الدمام',
          ),
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("deceasedTransportationStatus"),
            subtitle: 'النقل من المستشفى',
          ),
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("ekramHospital"),
            subtitle: 'المواساة',
          ),
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("burialDestination"),
            subtitle: 'الدفن في مدينة الدفن',
          ),
          CustomTitleSubtitleCardWidget(
            horizontalPadding: Constants.smallPadding,
            title: Helpers.translatingWord("DeathAddress"),
            subtitleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(start: 16),
                  child: CustomTextWidget(
                    "طريق الملك عبدالله، الخبر.",
                    fontColor: AppColors.black,
                    textAlign: TextAlign.start,
                    fontWeight: FONT_WEIGHT.medium,
                  ),
                ),
                CustomTextButtonWithIconWidgetWithFlexible(
                  mainAxisAlignment: MainAxisAlignment.start,
                  btnPressed: () {},
                  btnText: Helpers.translatingWord('navigateOnMap2'),
                  icon: CustomSvgIconWidget(
                    "assets/icons/tracking.svg",
                    iconHeight: 16,
                    iconWidth: 16,
                  ),
                  textUnderline: true,
                  buttonIconPosition: BUTTON_ICON_POSITION.right,
                  btnTextColor: AppColors.darkTurquoise,
                  btnTextSize: 13,
                  btnTextWeight: FONT_WEIGHT.medium,
                  padding: const EdgeInsets.all(Constants.semiMediumPadding),
                ),
                CustomTitleSubtitleCardWidget(
                  horizontalPadding: Constants.smallPadding,
                  title: Helpers.translatingWord("policeLetterAttached"),
                  subtitle: 'الدفن في مدينة الدفن',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}