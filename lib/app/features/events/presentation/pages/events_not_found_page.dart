import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsNotFoundPage extends StatelessWidget {
  const EventsNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: 'events_main_title_page'.tr(),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  /*  BottomSheetDialog.showDraggableSheet(
                    context,
                    child: const EventsPickerWidget(),
                  );*/
                },
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE8EFF1),
                  ),
                  child: Center(
                      child: Image.asset(
                    ImagePath.candle,
                  )),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
            ],
          ),
        ],
      ),
      body: Center(
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
          )
        ],
      )),
    );
  }
}
