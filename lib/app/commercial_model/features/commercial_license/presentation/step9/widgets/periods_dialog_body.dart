import 'package:balady_plus/app/commercial_model/features/commercial_license/commercial_license_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../data/models/qr/apply_commercial_response_model.dart';

class PeriodsDialogBody extends StatelessWidget {
  PeriodsDialogBody(
      {super.key, required this.onSubmitPeriods, this.currentWorkingTime});

  final WorkingTime? currentWorkingTime;
  final List<PeriodEntity> periods = [];
  final Function((List<PeriodEntity>, QRWorkTimes)) onSubmitPeriods;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeriodsCubit>(
      create: (context) => PeriodsCubit(periods: List.of(periods)),
      child: BlocBuilder<PeriodsCubit, PeriodsState>(
        builder: (context, state) {
          bool is24HourAllowed = sl<CommercialLicenseBloc>()
                  .state
                  .applyCommercialResponse
                  ?.comLicenseInfo
                  ?.has24HourPermit ??
              false;
          return Builder(builder: (context) {
            return BottomSheetWithActions(
              title: "cr_days_hours".tr(),
              action: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButtonWidget.add(onPressed: () {
                  bool isFormValid = false;

                  if (state.type == QRWorkTimes.OPEN_24HOUR)
                    isFormValid = true;
                  else if (state.type == QRWorkTimes.SHIFTED) {
                    if (state.periods.isNotEmpty) {
                      isFormValid = true;
                    }
                  }
                  if (isFormValid) {
                    context.popDialog();
                    onSubmitPeriods((state.periods, state.type!));
                  }
                }),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HorizontalRadioGroup<QRWorkTimes>(
                    currentItem: state.type,
                    groupName: "durationType".tr(),
                    items: [
                      RadioItem<QRWorkTimes>(
                          radioValue: QRWorkTimes.SHIFTED,
                          radioText: "specify_period".tr()),
                      if (is24HourAllowed)
                        RadioItem<QRWorkTimes>(
                            radioValue: QRWorkTimes.OPEN_24HOUR,
                            radioText: "24Hour".tr()),
                    ],
                    onChanged: (radio) => context
                        .read<PeriodsCubit>()
                        .onChangedPeriodType(type: radio!),
                  ),
                  if (!state.is24Hour) ...[
                    const Divider(thickness: 2),
                    const SizedBox(height: 24),
                    CustomTextWidget(
                      "add_period".tr(),
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
                    if (state.periods.length <= 1)
                      GestureDetector(
                        onTap: () => context.read<PeriodsCubit>().onAddPeriod(),
                        child: CustomTextWidget(
                          "add_period_2".tr(),
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
