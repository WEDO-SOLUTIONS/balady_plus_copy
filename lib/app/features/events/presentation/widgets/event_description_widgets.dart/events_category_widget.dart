import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_title.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventCategoryWidget extends StatelessWidget {
  const EventCategoryWidget({
    super.key,
    required this.category,
  });
  final List<String> category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventsTitleWidget(
          title: 'events_sorting'.tr(),
        ),
        SizedBox(
          height: 25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: category.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: ShapeDecoration(
                      color: Color(0x11145E75),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: CustomTextWidget(
                      category[index],
                      textStyle: AppStyle.eventsCategory,
                    ),
                  ),
                  SizedBox(
                    width: 4,
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
