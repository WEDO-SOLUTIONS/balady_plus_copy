import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_picker.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_tile.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsMainPage extends StatelessWidget {
  const EventsMainPage({super.key});

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
                  BottomSheetDialog.showDraggableSheet(
                    context,
                    child: const EventsPickerWidget(),
                  );
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: EventsSectionWidget(),
      ),
    );
  }
}
