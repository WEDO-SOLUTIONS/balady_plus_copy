import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/steps/step2/field_data.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../objectable_transactions/presentation/widgets/summery_widgets/field_data.dart';
import '../../../domain/entities/trip_details.dart';
import '../driver/trip_datetime_widget.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FieldData(
                title: tripDetails.currentTripStationName ?? "",
                subTitle: currentStationType ?? "",
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                children: [
                  FieldDataCustomData(
                    title: tripDetails.nextTripStationName ?? "",
                    sub: [
                      Row(
                        children: [
                          Flexible(
                            child: CustomTextWidget(
                              nextStationType ?? "",
                              fontColor: AppColor.blackModern600Light,
                              fontSize: 16,
                              maxLines: 10,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          ),
                        ],
                      ),
                      CustomVerticalSpace(height: 8),
                      if (tripDetails.getNextTripLocation() != null)
                        InkWell(
                          onTap: () {
                            CommonFunctions.openMap(
                                tripDetails.getNextTripLocation()!.$1,
                                tripDetails.getNextTripLocation()!.$2);
                          },
                          child: Row(
                            children: [
                              CustomSvgIconWidget(
                                IconPath.location,
                                iconSize: 12,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              CustomTextWidget(
                                ("ekram_next_step_location").tr(),
                                fontSize: 12,
                                fontWeight: AppFontWeight.medium,
                                fontColor: AppColor.black,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        CustomVerticalSpace(height: 24),
        Row(
          children: [
            Expanded(
                child: TripDateTimeWidget(
              date: CommonFunctions.getFormattedDateEkram(
                  tripDetails.currentTripStationArrivalTime ?? ""),
              time: CommonFunctions.getFormattedTimeEkram(
                  tripDetails.currentTripStationArrivalTime ?? ""), title: 'time',
            )),
            Expanded(
                child: TripDateTimeWidget(
              date: CommonFunctions.getFormattedDateEkram(
                  tripDetails.nextTripStationArrivalTime ?? ""),
              time: CommonFunctions.getFormattedTimeEkram(
                  tripDetails.nextTripStationArrivalTime ?? ""), title: 'time',
            )),
          ],
        ),
        CustomVerticalSpace(height: 24),
        TripDetailsCreatedDateWidget(
          date: CommonFunctions.getFormattedDateEkram(
              tripDetails.createDateTime ?? ""),
        ),
        CustomVerticalSpace(height: 16),
        DrawLineWidget(
          lineColor: AppColor.kGray230,
        )
      ],
    );
  }
}
