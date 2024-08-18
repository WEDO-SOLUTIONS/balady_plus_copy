import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class WorkTimeCard extends StatelessWidget {
  const WorkTimeCard({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkTimesCubit, WorkTimesState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: AppColor.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: Checkbox(
                        checkColor: AppColor.white,
                        activeColor: AppColor.primary700Light,
                        side: MaterialStateBorderSide.resolveWith((states) =>
                            const BorderSide(color: AppColor.primary500Light)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        value: state.workingTimes?[index].isSelected ?? false,
                        onChanged: (_) => context
                            .read<WorkTimesCubit>()
                            .onSelectedWorkTime(index),
                      ),
                    ),
                    CustomTextWidget(
                      state.workingTimes?[index].dayName ?? "",
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern600Light,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    BottomSheetDialog.showDraggableSheet(
                      context,
                      child: PeriodsDialogBody(
                        currentWorkingTime: state.workingTimes![index]!,
                        onSubmitPeriods: (periods) => context
                            .read<WorkTimesCubit>()
                            .onAddPeriods(
                                index: index,
                                periods: periods.$1,
                                type: periods.$2),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if ((state.workingTimes![index].isSelected ?? false) &&
                          state.workingTimes![index].openShiftOption == null)
                        CustomTextWidget(
                          "add_appointment".tr(),
                          fontSize: 12,
                          fontWeight: AppFontWeight.bold,
                          fontColor: AppColor.primary700Light,
                        ),
                      if ((state.workingTimes![index].isSelected ?? false) &&
                          state.workingTimes![index].openShiftOption !=
                              null) ...[
                        Column(
                          children: [
                            if (state.workingTimes?[index].firstFromTime !=
                                null)
                              CustomTextWidget(
                                "${state.workingTimes?[index].firstFromTime} - ${state.workingTimes?[index].firstToTime}",
                                fontWeight: AppFontWeight.medium,
                                fontSize: 12,
                                textAlign: TextAlign.end,
                                fontColor: AppColor.blackModern600Light,
                              ),
                            if (state.workingTimes?[index].secondFromTime !=
                                null) ...[
                              const SizedBox(height: 8),
                              CustomTextWidget(
                                "${state.workingTimes?[index].secondFromTime} - ${state.workingTimes?[index].secondToTime}",
                                fontWeight: AppFontWeight.medium,
                                fontSize: 12,
                                textAlign: TextAlign.end,
                                fontColor: AppColor.blackModern600Light,
                              ),
                            ],
                          ],
                        )
                      ],
                      if ((state.workingTimes![index].isSelected ?? false) &&
                          state.workingTimes![index].openShiftOption ==
                              "OPEN_24HOUR") ...[
                        Column(
                          children: [
                            CustomTextWidget(
                              "24Hour".tr(),
                              fontWeight: AppFontWeight.medium,
                              fontSize: 12,
                              textAlign: TextAlign.end,
                              fontColor: AppColor.blackModern600Light,
                            ),
                          ],
                        )
                      ],

                      /*   Expanded(
                        child: ListView.separated(
                          itemCount: state.workingTimes[index].periods.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (_, index2) => CustomTextWidget(
                            "${state.workTimes[index].periods[index2].from.format(context)} - ${state.workTimes[index].periods[index2].to.format(context)}",
                            fontWeight: AppFontWeight.medium,
                            fontSize: 12,
                            textAlign: TextAlign.end,
                            fontColor: AppColor.blackModern600Light,
                          ),
                        ),
                      ),*/
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.navigate_next,
                        size: 24,
                        color: AppColor.blackModern600Light,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
