import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsNotFoundPage extends StatelessWidget {
  const EventsNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            IconPath.notFound,
          ),
          const SizedBox(
            height: 12,
          ),
          CustomTextWidget(
            'content_not_found'.tr(),
            textStyle: AppStyle.eventNotFoundTextStyle,
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
