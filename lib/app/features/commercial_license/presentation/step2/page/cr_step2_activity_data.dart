import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class CRStep2ActivityData extends StatelessWidget {
  const CRStep2ActivityData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CRHeaderDesc(header: 'step2_header'.tr()),
                  const SizedBox(height: 12),
                  BlocBuilder<CrStep1ApplicantDataCubit,
                      CrStep1ApplicantDataState>(
                    buildWhen: (previous, current) =>
                        previous.recordInfo != current.recordInfo,
                    builder: (context, state) {
                      return BlocBuilder<CrStep2ActivityDataCubit,
                          CrStep2ActivityDataState>(
                        buildWhen: (previous, current) =>
                            previous.selectedIsicActivity !=
                            current.selectedIsicActivity,
                        builder: (context, step2State) {
                          return CustomTapWidgetForLongDialog(
                            items: state.recordInfo?.crInfo?.activities
                                    ?.isicActivities ??
                                [],
                            value: step2State.selectedIsicActivity,
                            label: 'step2_label1'.tr(),
                            marginBottom: 8,
                            onChangeType: (item) => item != null
                                ? context
                                    .read<CrStep2ActivityDataCubit>()
                                    .onSelectIsicActivity(item)
                                : null,
                          );
                        },
                      );
                    },
                  ),
                   NotesWidget(
                    notes: [
                      'note1'.tr(),
                      'note2'.tr()
                    ],
                  ),
                  BlocBuilder<CrStep2ActivityDataCubit,
                      CrStep2ActivityDataState>(
                    buildWhen: (previous, current) =>
                        previous.subActivitiesStatus !=
                        current.subActivitiesStatus,
                    builder: (context, state) {
                      return CustomTapWidgetForLongDialog(
                        items: state.subActivities,
                        value: state.selectedSubActivity,
                        isLoading:
                            state.subActivitiesStatus.isSubmissionLoading,
                        label: 'step2_label2'.tr(),
                        marginBottom: 8,
                        onChangeType: (item) => item != null
                            ? context
                                .read<CrStep2ActivityDataCubit>()
                                .onSelectSubActivity(item)
                            : null,
                      );
                    },
                  ),
                   NotesWidget(
                    notes: [
                      'note3'.tr(),
                    ],
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: 'step2_label3'.tr(),
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label:'step2_label4'.tr(),
                    hintText: 'label4_hint'.tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    suffixIcon:  CustomTextWidget(
                      'square_meter'.tr(),
                      fontSize: 12,
                      fontWeight: AppFontWeight.semiBold,
                      fontColor: AppColor.blackModern400Light,
                    ),
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  WorkerTypeComponent(
                    selectedWorkerType: null,
                    onSelectedType: (type) {},
                  ),
                  const ExtraActivityComponent(),
                ],
              ),
            ),
          ),
        ),
        const CRPreviousNextButtons(isBtnDisabled: false),
      ],
    );
  }
}
