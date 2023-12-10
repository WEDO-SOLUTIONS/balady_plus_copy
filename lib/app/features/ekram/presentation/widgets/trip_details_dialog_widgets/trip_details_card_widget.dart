import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../domain/entities/trip_details.dart';

class TripDetailsDialogCard extends StatelessWidget {
  final TripDetails tripDetails;
  final String? currentStationType;
  final String? nextStationType;
  final bool showDelete;
  final Function onPressDelete;

  TripDetailsDialogCard(
      {Key? key,
      this.currentStationType,
      this.nextStationType,
      required this.showDelete,
      required this.tripDetails,
      required this.onPressDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomVerticalSpace(height: 24),
        Row(
          children: [
            Expanded(
              child: CustomTextWidget(
                trans('register_trip_details'),
                maxLines: 1,
                fontSize: 13,
                fontColor: AppColor.black400,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            if (showDelete)
              CustomTextButtonWithIconWidget(
                btnPressed: () => onPressDelete(),
                icon: CustomSvgIconWidget(
                  "assets/icons/svg/ekram_delete.svg",
                  iconWidth: 12,
                  iconHeight: 12,
                  iconColor: AppColor.redBrown,
                ),
                btnText: trans('delete'),
                btnTextSize: 13,
                btnTextWeight: AppFontWeight.medium,
                btnTextColor: AppColor.redBrown,
                buttonIconPosition: BUTTON_ICON_POSITION.right,
              ),
          ],
        ),
        CustomVerticalSpace(height: 16),
        Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: TripDetailsHeaderAndDesc(
                    header: tripDetails.currentTripStationName ?? "",
                    desc: currentStationType ?? "",
                  ),
                ),
                Expanded(
                  child: CustomSvgIconWidget(
                    "assets/icons/ekram_car.svg",
                    iconWidth: 32,
                    iconHeight: 16,
                  ),
                ),
              ],
            )),
            Expanded(
                child: TripDetailsHeaderAndDesc(
              header: tripDetails.nextTripStationName ?? "",
              desc: nextStationType ?? "",
            )),
          ],
        ),
        CustomVerticalSpace(height: 24),
        Row(
          children: [
            Expanded(
                child: TripDetailsDateTime(
              date: CommonFunctions.getFormattedDateEkram(
                  tripDetails.currentTripStationArrivalTime ?? ""),
              time: CommonFunctions.getFormattedTimeEkram(
                  tripDetails.currentTripStationArrivalTime ?? ""),
            )),
            Expanded(
                child: TripDetailsDateTime(
              date: CommonFunctions.getFormattedDateEkram(
                  tripDetails.nextTripStationArrivalTime ?? ""),
              time: CommonFunctions.getFormattedTimeEkram(
                  tripDetails.nextTripStationArrivalTime ?? ""),
            )),
          ],
        ),
        CustomVerticalSpace(height: 24),
        TripDetailsCreatedDateWidget(
          date: CommonFunctions.getFormattedDateEkram(
              tripDetails.createDateTime ?? ""),
        ),
        CustomVerticalSpace(height: 16),
        DrawLineWidget()
      ],
    );
  }
}
