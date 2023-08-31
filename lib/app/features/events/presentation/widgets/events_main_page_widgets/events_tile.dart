import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_activities.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_day_month.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_title_price.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsSectionWidget extends StatelessWidget {
  const EventsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      ImagePath.eventsImage1,
      ImagePath.eventsImage2,
      ImagePath.eventsImage3,
      ImagePath.eventsImage4,
    ];
    List<String> title = [
      'safari'.tr(),
      'dariyah_history'.tr(),
      'elephant_stone'.tr(),
      'safari'.tr(),
    ];

    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(images[index]),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EventsActivitiesWidget(),
                      EventsDayMonthEvent(
                        monthStyle: AppStyle.eventsMonthStyle,
                        dayStyle: AppStyle.eventsDayStyle,
                        color: Color.fromRGBO(255, 255, 255, 0.80),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  EventsTitlePriceWidget(
                    title: title[index],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }
}
