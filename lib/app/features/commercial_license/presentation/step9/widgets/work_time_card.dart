import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
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
      buildWhen: (previous, current) => previous.workTimes != current.workTimes,
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
                        value: state.workTimes[index].isSelected,
                        onChanged: (_) => context
                            .read<WorkTimesCubit>()
                            .onSelectedWorkTime(index),
                      ),
                    ),
                    CustomTextWidget(
                      state.workTimes[index].weekDay.tr(),
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern600Light,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (state.workTimes[index].isSelected &&
                        state.workTimes[index].periods.isEmpty)
                      GestureDetector(
                        onTap: () => BottomSheetDialog.showDraggableSheet(
                          context,
                          child: PeriodsDialogBody(
                            periods: state.workTimes[index].periods,
                            onSubmitPeriods: (periods) => context
                                .read<WorkTimesCubit>()
                                .onAddPeriods(index: index, periods: periods),
                          ),
                        ),
                        child: const CustomTextWidget(
                          "اضف المواعيد",
                          fontSize: 12,
                          fontWeight: AppFontWeight.bold,
                          fontColor: AppColor.primary700Light,
                        ),
                      ),
                    if (state.workTimes[index].isSelected &&
                        state.workTimes[index].periods.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.workTimes[index].periods.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, index2) => CustomTextWidget(
                            "${state.workTimes[index].periods[index2].from.format(context)} - ${state.workTimes[index].periods[index2].to.format(context)}",
                            fontWeight: AppFontWeight.medium,
                            fontSize: 12,
                            textAlign: TextAlign.end,
                            fontColor: AppColor.blackModern600Light,
                          ),
                        ),
                      ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.navigate_next,
                      size: 24,
                      color: AppColor.blackModern600Light,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
