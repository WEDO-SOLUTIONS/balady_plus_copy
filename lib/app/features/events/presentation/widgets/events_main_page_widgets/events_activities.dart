import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsActivitiesWidget extends StatelessWidget {
  const EventsActivitiesWidget({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.white),
            padding: EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
            child: CustomTextWidget(
              category,
              textStyle: AppStyle.eventsOptionsStyle,
            ),
          ),
        ],
      ),
    );
  }
}
