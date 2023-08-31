import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsDetailsWidget extends StatelessWidget {
  const EventsDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> detailTitle = [
      'fees'.tr(),
      'event_date'.tr(),
      'event_time'.tr(),
      'event_genre'.tr(),
      'event_website'.tr(),
    ];
    List<String> detailsDesc = [
      'for_free'.tr(),
      'event_date_subtitle'.tr(),
      'event_time_subtitle'.tr(),
      'events_genre_subtitle'.tr(),
      'events_website_subtitle'.tr(),
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
        SizedBox(
          height: 400,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: detailIcon.length,
            itemBuilder: (context, index) {
              return Column(
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
                            SvgPicture.asset(detailIcon[index]),
                            SizedBox(
                              width: 2,
                            ),
                            CustomTextWidget(
                              detailTitle[index],
                              textStyle: AppStyle.eventsDetailsTitleStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        CustomTextWidget(
                          detailsDesc[index],
                          textStyle: AppStyle.eventsDetailsSubtitleStyle,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
