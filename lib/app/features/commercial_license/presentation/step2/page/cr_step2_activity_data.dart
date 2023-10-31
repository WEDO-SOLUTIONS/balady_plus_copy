import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import 'package:collection/collection.dart';

import '../widgets/accomodation_types_drop_down.dart';

class CRStep2ActivityData extends StatelessWidget {
  const CRStep2ActivityData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrStep2ActivityDataCubit, CrStep2ActivityDataState>(
        listener: (context, state) {
      if (state.status.isSubmissionFailure ||
          state.subActivityDetailsStatus.isSubmissionFailure ||
          state.subActivitiesStatus.isSubmissionFailure) {
        CommonFunctions.showError(state.errorMessage);
      }
    }, builder: (context, state) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CRHeaderDesc(header: "بيانات النـشاط"),
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
                                    items: state.getIsicActivities(),
                                    value: step2State.selectedIsicActivity,
                                    label: "نشاط أيزيك",
                                    marginBottom: 8,
                                    onChangeType: (item) {
                                      IsicActivity? i = state
                                          .getIsicActivities()
                                          .firstWhereOrNull((element) =>
                                              element.isicCode == item?.id);
                                      i != null
                                          ? context
                                              .read<CrStep2ActivityDataCubit>()
                                              .onSelectIsicActivity(i)
                                          : null;
                                    });
                              },
                            );
                          },
                        ),
                        // NotesWidget(
                        //    notes: ['note1'.tr(), 'note2'.tr()],
                        //   ),
                        BlocBuilder<CrStep2ActivityDataCubit,
                            CrStep2ActivityDataState>(
                          builder: (context, state) {
                            return CustomTapWidgetForLongDialog(
                                items: state.subActivities,
                                value: state.selectedSubActivity,
                                isLoading: state
                                    .subActivitiesStatus.isSubmissionLoading,
                                label: 'step2_label2'.tr(),
                                marginBottom: 8,
                                onChangeType: (item) {
                                  SubActivityEntity? i = state.subActivities
                                      .firstWhereOrNull(
                                          (element) => element.id == item?.id);
                                  i != null
                                      ? context
                                          .read<CrStep2ActivityDataCubit>()
                                          .onSelectSubActivity(i)
                                      : null;
                                });
                          },
                        ),
                        /*  NotesWidget(
                          notes: [
                            "عزيزي المستفيد, يمكنك الاستعلام عن تفاصيل الأنشطة التجارية واشتراطاتها من خلال زيارتك للرابط التالي:\n الأنشطة التجارية واشتراطاته"
                          ],
                        ),*/
                        const CustomVerticalSpace(height: 12),
                        ReadOnlyField(
                          title: "نوع المنشاه".tr(),
                          subTitle: state.selectedSubActivity?.facilityName,
                          showSpace: false,
                        ),
                        const CustomVerticalSpace(height: 16),
                        CustomTextFieldWidget(
                          label: 'step2_label4'.tr(),
                          hintText: 'label4_hint'.tr(),
                          isDigitsOnly: true,
                          initialValue: state.totalArea != null
                              ? state.totalArea.toString()
                              : null,
                          keyboardType: TextInputType.number,
                          suffixIcon: CustomTextWidget(
                            "متر مربع",
                            fontSize: 12,
                            fontWeight: AppFontWeight.semiBold,
                            fontColor: AppColor.blackModern400Light,
                          ),
                          bottomMargin: 24,
                          onChanged: (value) {
                            context
                                .read<CrStep2ActivityDataCubit>()
                                .updateArea(double.tryParse(value ?? ""));
                          },
                        ),

                        if (state.showHotel()) ...[
                          AccomodationDropDownTypes(),
                          const CustomVerticalSpace(height: 16),
                          CustomTextFieldWidget(
                            label: 'عدد الوحدات'.tr(),
                            hintText: 'عدد الوحدات'.tr(),
                            isDigitsOnly: true,
                            initialValue: state.unitCount != null
                                ? state.unitCount.toString()
                                : null,
                            keyboardType: TextInputType.number,
                            suffixIcon: CustomTextWidget(
                              "",
                              fontSize: 12,
                              fontWeight: AppFontWeight.semiBold,
                              fontColor: AppColor.blackModern400Light,
                            ),
                            bottomMargin: 24,
                            onChanged: (value) {
                              context
                                  .read<CrStep2ActivityDataCubit>()
                                  .updateUnitCount(value);
                            },
                          ),
                          const CustomVerticalSpace(height: 16),
                        ],
                        if (state.showAtm()) ...[
                          CustomTextWidget(
                            "هل تم دفع رسوم تأسيس الصراف؟",
                            fontColor: AppColor.blackModern700Light,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                          ),
                          const CustomVerticalSpace(height: 16),
                          Container(
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Expanded(
                                child: CheckBoxWithTitle(
                                  title: "نعم",
                                  forceSelection: state.atmFeesPaid == true,
                                  onChanged: (value) {
                                    context
                                        .read<CrStep2ActivityDataCubit>()
                                        .updateAtmFeesPaid(value);
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: CheckBoxWithTitle(
                                  forceSelection: state.atmFeesPaid == false,
                                  title: "لا",
                                  onChanged: (value) {
                                    context
                                        .read<CrStep2ActivityDataCubit>()
                                        .updateAtmFeesPaid(value);
                                  },
                                ),
                              ),
                            ]),
                          ),
                          const CustomVerticalSpace(height: 16),
                        ],
                        WorkerTypeComponent(
                          selectedWorkerType: state.workerType,
                          onSelectedType: (type) {
                            context
                                .read<CrStep2ActivityDataCubit>()
                                .updateWorkerType(type);
                          },
                        ),
                        const CustomVerticalSpace(height: 16),
                        if (state.addetionalActivityItems?.isNotEmpty ?? false)
                          const ExtraActivityComponent(),
                      ],
                    ),
                  ),
                ),
              ),
              CRPreviousNextButtons(
                isBtnDisabled: !state.isFormValid(),
                onPressed: () {
                  context.read<CrStep2ActivityDataCubit>().save();
                },
              ),
            ],
          ),
          if (state.subActivityDetailsStatus.isSubmissionLoading ||
              state.status.isSubmissionLoading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
