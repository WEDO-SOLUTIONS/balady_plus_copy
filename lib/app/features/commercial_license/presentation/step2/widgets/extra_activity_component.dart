import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/additional_activity_details_response.dart';
import '../../../data/models/additional_activity_response.dart';
import 'package:collection/collection.dart';

class ExtraActivityComponent extends StatefulWidget {
  const ExtraActivityComponent({
    super.key,
  });

  @override
  State<ExtraActivityComponent> createState() => _ExtraActivityComponentState();
}

class _ExtraActivityComponentState extends State<ExtraActivityComponent> {
  String? area;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep2ActivityDataCubit, CrStep2ActivityDataState>(
      builder: (ctx, state) {
        return Container(
          margin: const EdgeInsets.only(top: 32, bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: AppColor.white,
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  CustomSvgIconWidget(
                    IconPath.additionalActivity,
                    iconSize: 20,
                  ),
                  SizedBox(width: 6),
                  CustomTextWidget(
                    "نشاط اضافي",
                    fontWeight: AppFontWeight.bold,
                    fontSize: 18,
                    fontColor: AppColor.blackModern600Light,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ListView.separated(
                itemCount: state.selectedAddetionalList?.length ?? 0,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) => ExtraActivityCard(
                  item: state.selectedAddetionalList![i],
                  onDelete: () {
                    context
                        .read<CrStep2ActivityDataCubit>()
                        .deleteAddetionalActivity(i);
                  },
                ),
              ),
              const SizedBox(height: 12),
              PlusAddButton(
                text: "ارفاق نشاط",
                onPressed: () => BottomSheetDialog.showDraggableSheet(
                  context,
                  child: Builder(
                    builder: (c) {
                      return BlocProvider<CrStep2ActivityDataCubit>.value(
                        value: context.read<CrStep2ActivityDataCubit>(),
                        child: BlocBuilder<CrStep2ActivityDataCubit,
                            CrStep2ActivityDataState>(
                          builder: (context, state) {
                            return BottomSheetWithActions(
                              title: "إضافة نشاط",
                              action: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: ElevatedButtonWidget.add(onPressed: () {
                                  double? a = double.tryParse(area ?? "") ?? 0;

                                  if (a > state.getTotalArea()) {
                                    CommonFunctions.showError(
                                        "مساحة المحل أقل من مجموع مساحات الأنشطة الإضافية");
                                    return;
                                  }

                                  if (area != null) {
                                    ctx
                                        .read<CrStep2ActivityDataCubit>()
                                        .addAddetionalItemRequest(
                                            double.tryParse(area ?? "")!);
                                    Navigator.pop(context);
                                  }
                                }),
                              ),
                              body: Stack(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTapWidgetForLongDialog(
                                          items: state
                                                  .getAddetionalActivityItems() ??
                                              [],
                                          value: state.addetionalItem,
                                          label: "نشاط أيزيك",
                                          marginBottom: 8,
                                          onChangeType: (item) {
                                            AddetionalActivityItem? i = state
                                                .addetionalActivityItems
                                                ?.firstWhereOrNull((element) =>
                                                    element.isicCode ==
                                                    item?.id);
                                            i != null
                                                ? context
                                                    .read<
                                                        CrStep2ActivityDataCubit>()
                                                    .onSelectAddetionalActivity(
                                                        i)
                                                : null;
                                          }),
                                      const CustomVerticalSpace(height: 12),
                                      CustomTapWidgetForLongDialog(
                                          items: state
                                                  .addetionalActivityItemDetails ??
                                              [],
                                          value: state.addetionalDetailsItem,
                                          label: "النشاط التفصيلي",
                                          marginBottom: 8,
                                          onChangeType: (item) {
                                            AddetionalActivityItemDetails? i =
                                                state
                                                    .addetionalActivityItemDetails
                                                    ?.firstWhereOrNull(
                                                        (element) =>
                                                            element
                                                                .activityId ==
                                                            item?.id);
                                            i != null
                                                ? context
                                                    .read<
                                                        CrStep2ActivityDataCubit>()
                                                    .onSelectAddetionalDetailsActivity(
                                                        i)
                                                : null;
                                          }),
                                      const CustomVerticalSpace(height: 12),
                                      CustomTextFieldWidget(
                                        label:
                                            "مساحة النشاط الإضافي من إجمالي المساحة"
                                                .tr(),
                                        hintText:
                                            "مساحة النشاط الإضافي من إجمالي المساحة"
                                                .tr(),
                                        isDigitsOnly: true,
                                        keyboardType: TextInputType.number,
                                        suffixIcon: const CustomTextWidget(
                                          "متر  مربع",
                                          fontSize: 12,
                                          fontWeight: AppFontWeight.semiBold,
                                          fontColor:
                                              AppColor.blackModern400Light,
                                        ),
                                        bottomMargin: 24,
                                        onChanged: (value) {
                                          area = value;
                                        },
                                      ),
                                    ],
                                  ),
                                  if (state.subActivityDetailsStatus
                                          .isSubmissionLoading ||
                                      state.status.isSubmissionLoading ||
                                      state.addetionalActivityListStatus
                                          .isSubmissionLoading ||
                                      state.addetionalActivityDetailsListStatus
                                          .isSubmissionLoading)
                                    const CustomCircularLoadingWidget(),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
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
