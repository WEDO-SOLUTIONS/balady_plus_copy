import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_title.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsDescriptionWidget extends StatelessWidget {
  const EventsDescriptionWidget({
    super.key,
    required this.description,
  });
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventsTitleWidget(
          title: 'event_description_title'.tr(),
        ),
        CustomTextWidget(
          description,
          maxLines: 4,
          textAlign: TextAlign.right,
          textStyle: AppStyle.eventsDescriptionTextStyle,
        ),
      ],
    );
  }
}
