import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsDetailsWidget extends StatelessWidget {
  const EventsDetailsWidget({
    super.key,
    required this.feesType,
    required this.endDate,
    required this.startDate,
    required this.genre,
    required this.website,
  });
  final String feesType;
  final String startDate;
  final String endDate;
  final String genre;
  final String website;

  @override
  Widget build(BuildContext context) {
    List<String> detailTitle = [
      'fees'.tr(),
      'event_date'.tr(),
      'event_time'.tr(),
      'event_genre'.tr(),
      'event_website'.tr(),
    ];

    List<String> detailIcon = [
      IconPath.wallet,
      IconPath.calendar,
      IconPath.clock,
      IconPath.profileCircle,
      IconPath.linkSquare,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventsTitleWidget(
          title: 'events_details'.tr(),
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(detailIcon[0]),
                      SizedBox(
                        width: 2,
                      ),
                      CustomTextWidget(
                        detailTitle[0],
                        textStyle: AppStyle.eventsDetailsTitleStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomTextWidget(
                    feesType,
                    textStyle: AppStyle.eventsDetailsSubtitleStyle,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(detailIcon[1]),
                      SizedBox(
                        width: 2,
                      ),
                      CustomTextWidget(
                        detailTitle[1],
                        textStyle: AppStyle.eventsDetailsTitleStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomTextWidget(
                    startDate,
                    textStyle: AppStyle.eventsDetailsSubtitleStyle,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(detailIcon[2]),
                      SizedBox(
                        width: 2,
                      ),
                      CustomTextWidget(
                        detailTitle[2],
                        textStyle: AppStyle.eventsDetailsTitleStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomTextWidget(
                    endDate,
                    textStyle: AppStyle.eventsDetailsSubtitleStyle,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(detailIcon[3]),
                      SizedBox(
                        width: 2,
                      ),
                      CustomTextWidget(
                        detailTitle[3],
                        textStyle: AppStyle.eventsDetailsTitleStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomTextWidget(
                    genre,
                    textStyle: AppStyle.eventsDetailsSubtitleStyle,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(detailIcon[4]),
                      SizedBox(
                        width: 2,
                      ),
                      CustomTextWidget(
                        detailTitle[4],
                        textStyle: AppStyle.eventsDetailsTitleStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomTextWidget(
                    website,
                    textStyle: AppStyle.eventsDetailsSubtitleStyle,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
