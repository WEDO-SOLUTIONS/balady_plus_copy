import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsTitleLocationWidget extends StatelessWidget {
  const EventsTitleLocationWidget({
    super.key,
    required this.title,
    required this.city,
  });
  final String title;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              title,
              textStyle: AppStyle.eventMainTitleStyle,
            ),
            Row(
              children: [
                SvgPicture.asset(IconPath.locationBlack),
                SizedBox(
                  width: 1,
                ),
                CustomTextWidget(
                  city,
                  textStyle: AppStyle.eventsMainSubtitleStyle,
                )
              ],
            )
          ],
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: ShapeDecoration(
            color: const Color(0xFFE8EFF1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: SvgPicture.asset(
            IconPath.export,
          ),
        )
      ],
    );
  }
}
