import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/athkar/data/datasources/static_athkar_data.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_category.dart';
import 'package:balady_plus/app/features/athkar/presentation/cubit/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AthkarTimeSetup extends StatelessWidget {
  AthkarTimeSetup({super.key});

  final List athkarList = StaticAthkarData.athkarCategories;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimePickerBloc, TimePickerState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: athkarList.length,
          itemBuilder: (context, index) {
            final AthkarCategory athkarCategory = athkarList[index];
            TimeOfDay? selectedTime = state.selectedTimes[index];
            final int categoryId = athkarCategory.id;
            bool isEnabled = state.categoryEnabledStates;

            final selectedTimeString = selectedTime != null && isEnabled
                ? '${selectedTime.hour}:${selectedTime.minute}'
                : '';
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(athkarCategory.icon),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            athkarCategory.name,
                            style: AppStyle.athkarNameStyle,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Opacity(
                            opacity:
                                isEnabled && selectedTime != null ? 1.0 : 0.5,
                            child: CupertinoButton(
                              onPressed: isEnabled && selectedTime != null
                                  ? () async {
                                      await BottomSheetDialog
                                          .showDraggableSheet(
                                        context,
                                        isFullHeight: false,
                                        height: 588,
                                        child: BottomSheetWithActions(
                                          title: athkarCategory.name,
                                          body: Column(
                                            children: [
                                              CupertinoTimerPicker(
                                                initialTimerDuration:
                                                    selectedTime != null
                                                        ? Duration(
                                                            hours: selectedTime
                                                                    ?.hour ??
                                                                0,
                                                            minutes: selectedTime
                                                                    ?.minute ??
                                                                0,
                                                          )
                                                        : Duration.zero,
                                                mode:
                                                    CupertinoTimerPickerMode.hm,
                                                onTimerDurationChanged:
                                                    (newDuration) {
                                                  if (selectedTime != null) {
                                                    selectedTime =
                                                        TimeOfDay.fromDateTime(
                                                      DateTime(
                                                        0,
                                                        1,
                                                        1,
                                                        newDuration.inHours,
                                                        newDuration.inMinutes %
                                                            60,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              ElevatedButton(
                                                child: Text('saveButton'.tr()),
                                                onPressed: () {
                                                  if (selectedTime != null) {
                                                    BlocProvider.of<
                                                                TimePickerBloc>(
                                                            context)
                                                        .add(
                                                      UpdateTimeEvent(
                                                          index, selectedTime!),
                                                    );
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Container(
                                width: 40,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColor.white,
                                ),
                                child: Text(
                                  selectedTimeString ?? '',
                                  style: TextStyle(
                                    color: selectedTime != null
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: isEnabled && selectedTime != null
                                ? () {
                                    BlocProvider.of<TimePickerBloc>(context)
                                        .add(TogglePickerEvent(index));
                                  }
                                : null,
                            child: SvgPicture.asset(
                              isEnabled && selectedTime != null
                                  ? IconPath.notificationOn
                                  : IconPath.notificationOff,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
