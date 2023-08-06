import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                            items: state.recordInfo?.crInfo?.activities
                                    ?.isicActivities ??
                                [],
                            value: step2State.selectedIsicActivity,
                            label: "شاط أيزيك",
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
                  const NotesWidget(
                    notes: [
                      "عزيزي المستفيد, يرجى اختيار النشاط المطابق للنشاط الفعلي للمحل، حيث أنه لا يمكن تعديل نشاط الرخصة بعد اصدارها.",
                      "تأكد من وجود ترخيص لأي عامل حرفي في منشأتك حيث انه شرط أساسي لإصدار او تجديد الرخص التجارية"
                    ],
                  ),
                  BlocBuilder<CrStep2ActivityDataCubit,
                      CrStep2ActivityDataState>(
                    buildWhen: (previous, current) =>
                        previous.subActivitiesStatus !=
                            current.subActivitiesStatus ||
                        previous.selectedSubActivity !=
                            current.selectedSubActivity,
                    builder: (context, state) {
                      return CustomTapWidgetForLongDialog(
                        items: state.subActivities,
                        value: state.selectedSubActivity,
                        isLoading:
                            state.subActivitiesStatus.isSubmissionLoading,
                        label: "النشاط التفصيلي",
                        marginBottom: 8,
                        onChangeType: (item) => item != null
                            ? context
                                .read<CrStep2ActivityDataCubit>()
                                .onSelectSubActivity(item)
                            : null,
                      );
                    },
                  ),
                  const NotesWidget(
                    notes: [
                      "عزيزي المستفيد, يمكنك الاستعلام عن تفاصيل الأنشطة التجارية واشتراطاتها من خلال زيارتك للرابط التالي:\n الأنشطة التجارية واشتراطاته"
                    ],
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "نوع المنشاه",
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "المساحه الكليه للمحل",
                    hintText: "ادخل المساحه الكليه للمحل",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    suffixIcon: const CustomTextWidget(
                      "متر  مربع",
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
