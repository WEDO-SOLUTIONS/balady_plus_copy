import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/presentation/widgets/custom_enhanced_expansion_panel_widget.dart';

class BurialInfoWidget extends StatelessWidget {
  const BurialInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEnhancedExpansionPanelWidget(
      underline: false,
      title: "burialInfo".tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //MM Ekram
          /*
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
                    fontWeight: AppFontWeight.medium,
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
                  btnTextColor: AppColor.primary900Light,
                  btnTextSize: 13,
                  btnTextWeight: AppFontWeight.medium,
                  padding: const EdgeInsets.all(Constants.semiMediumPadding),
                ),
                CustomTitleSubtitleCardWidget(
                  horizontalPadding: Constants.smallPadding,
                  title: Helpers.translatingWord("policeLetterAttached"),
                  subtitle: 'الدفن في مدينة الدفن',
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
