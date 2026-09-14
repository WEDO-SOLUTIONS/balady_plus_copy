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
    required this.date,
    required this.time,
    required this.genre,
    required this.website,
    required this.category,
    required this.city,
    required this.season,
  });
  final String feesType;
  final String date;
  final String time;
  final String genre;
  final String category;
  final String season;
  final String city;
  final String website;

  @override
  Widget build(BuildContext context) {
    [
      'fees'.tr(),
      'event_date'.tr(),
      'event_time'.tr(),
      'events_filter_city'.tr(),
      'event_genre'.tr(),
      'events_filter_category'.tr(),
      'events_filter_season'.tr(),
      'event_website'.tr(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventsTitleWidget(title: 'events_details'.tr()),
        Column(
          children: [
            EventItemWidget(icon: IconPath.wallet, text: 'fees'.tr(), value: feesType),
            SizedBox(height: 8),
            EventItemWidget(icon: IconPath.calendar, text: 'event_date'.tr(), value: date),
            SizedBox(height: 8),
            EventItemWidget(icon: IconPath.clock, text: 'event_time'.tr(), value: time),
            SizedBox(height: 8),
            EventItemWidget(icon: IconPath.profileCircle, text: 'events_filter_city'.tr(), value: city),
            SizedBox(height: 8),
            EventItemWidget(icon: IconPath.profileCircle, text: 'event_genre'.tr(), value: genre),
            SizedBox(height: 8),
            SizedBox(height: 8),
            EventItemWidget(icon: IconPath.profileCircle, text: 'events_filter_category'.tr(), value: category),
            SizedBox(height: 8),
            EventItemWidget(icon: IconPath.profileCircle, text: 'events_filter_season'.tr(), value: season),
            /*  Container(
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
            )*/
          ],
        ),
      ],
    );
  }
}

class EventItemWidget extends StatelessWidget {
  final String icon;
  final String text;
  final String value;
  const EventItemWidget({super.key, required this.icon, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(icon),
                  SizedBox(width: 2),
                  CustomTextWidget(text, textStyle: AppStyle.eventsDetailsTitleStyle),
                ],
              ),
              SizedBox(height: 4),
              CustomTextWidget(value, textStyle: AppStyle.eventsDetailsSubtitleStyle),
            ],
          ),
        ),
      ],
    );
  }
}
