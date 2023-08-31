import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_title.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventMapWidget extends StatelessWidget {
  const EventMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventsTitleWidget(title: 'event_location_title'.tr()),
        Container(
          padding: EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Image.asset(
            ImagePath.eventsMap,
          ),
        )
      ],
    );
  }
}
