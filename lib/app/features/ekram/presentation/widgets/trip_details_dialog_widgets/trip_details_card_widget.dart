import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';

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
                fontColor: AppColors.black400,
                fontWeight: FONT_WEIGHT.medium,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            if (showDelete)
              CustomTextButtonWithIconWidget(
                btnPressed: () => onPressDelete(),
                icon: CustomSvgIconWidget(
                  "assets/icons/delete_ekram.svg",
                  iconWidth: 12,
                  iconHeight: 12,
                ),
                btnText: trans('delete'),
                btnTextSize: 13,
                btnTextWeight: FONT_WEIGHT.medium,
                btnTextColor: AppColors.redBrown,
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
              date: getFormattedDateEkram(
                  tripDetails.currentTripStationArrivalTime ?? ""),
              time: getFormattedTimeEkram(
                  tripDetails.currentTripStationArrivalTime ?? ""),
            )),
            Expanded(
                child: TripDetailsDateTime(
              date: getFormattedDateEkram(
                  tripDetails.nextTripStationArrivalTime ?? ""),
              time: getFormattedTimeEkram(
                  tripDetails.nextTripStationArrivalTime ?? ""),
            )),
          ],
        ),
        CustomVerticalSpace(height: 24),
        TripDetailsCreatedDateWidget(
          date: getFormattedDateEkram(tripDetails.createDateTime ?? ""),
        ),
        CustomVerticalSpace(height: 16),
        DrawLineWidget()
      ],
    );
  }
}
