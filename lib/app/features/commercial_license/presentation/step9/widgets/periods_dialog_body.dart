import 'package:balady_plus/app/features/commercial_license/commercial_license_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class PeriodsDialogBody extends StatelessWidget {
  const PeriodsDialogBody({
    super.key,
    required this.periods,
    required this.onSubmitPeriods,
  });

  final List<PeriodEntity> periods;
  final Function(List<PeriodEntity>) onSubmitPeriods;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeriodsCubit>(
      create: (context) => PeriodsCubit(periods: List.of(periods)),
      child: BlocBuilder<PeriodsCubit, PeriodsState>(
        builder: (context, state) {
          return Builder(builder: (context) {
            return BottomSheetWithActions(
              title: "daily_hour".tr(),
              action: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButtonWidget.add(onPressed: () {
                  context.popDialog();
                  onSubmitPeriods(state.periods);
                }),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HorizontalRadioGroup(
                    currentItem: state.is24Hour
                        ? RadioItem(id: 1, radioValue: "24Hour".tr())
                        : RadioItem(id: 0, radioValue: "limited".tr()),
                    groupName: "durationType".tr(),
                    items: [
                      RadioItem(id: 0, radioValue: "limited".tr()),
                      RadioItem(id: 1, radioValue: "24Hour".tr()),
                    ],
                    onChanged: (radio) => context
                        .read<PeriodsCubit>()
                        .onChangedPeriodType(is24Hour: radio?.id == 1),
                  ),
                  if (!state.is24Hour) ...[
                    const Divider(thickness: 2),
                    const SizedBox(height: 24),
                    CustomTextWidget(
                      'addDuration'.tr(),
                      fontSize: 16,
                      fontColor: AppColor.blackModern700Light,
                      fontWeight: AppFontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      itemCount: state.periods.length,
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) => Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ClockTimeWidget(
                              title: "from".tr(),
                              currentTime:
                                  state.periods[index].from.format(context),
                              onSelectedTime: (time) => time != null
                                  ? context
                                      .read<PeriodsCubit>()
                                      .onTimeFromChanged(
                                          index: index, time: time)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: ClockTimeWidget(
                              title: "to".tr(),
                              currentTime:
                                  state.periods[index].to.format(context),
                              onSelectedTime: (time) => time != null
                                  ? context
                                      .read<PeriodsCubit>()
                                      .onTimeToChanged(index: index, time: time)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: () => context
                                .read<PeriodsCubit>()
                                .onRemovePeriod(index),
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: AppColor.primary900Light,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => context.read<PeriodsCubit>().onAddPeriod(),
                      child:  CustomTextWidget(
                        'addingExtraDuration'.tr(),
                        fontSize: 16,
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.primary900Light,
                      ),
                    ),
                  ],
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
