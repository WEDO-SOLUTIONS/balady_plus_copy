import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/additional_activity_details_response.dart';
import '../../../data/models/additional_activity_response.dart';
import 'package:collection/collection.dart';

import '../../../data/models/sub_activity_details_data.dart';

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
    return BlocBuilder<Step2ActivityDataExportCubit, Step2ActivityDataExportState>(
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
              Row(
                children: [
                  const CustomSvgIconWidget(
                    IconPath.additionalActivity,
                    iconSize: 20,
                  ),
                  const SizedBox(width: 6),
                  CustomTextWidget(
                    "addetional_data".tr(),
                    fontWeight: AppFontWeight.bold,
                    fontSize: 18,
                    fontColor: AppColor.blackModern600Light,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ListView.separated(
                itemCount: state.lstSelectedAddetionalActivity?.length ?? 0,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) => ExtraActivityCard(
                  item: state.lstSelectedAddetionalActivity![i],
                  onDelete: () {
                    context
                        .read<Step2ActivityDataExportCubit>()
                        .deleteAddetionalActivity(i);
                  },
                ),
              ),
              const SizedBox(height: 12),

              PlusAddButton(
                text: "attach_activity".tr(),
                onPressed: () => BottomSheetDialog.showDraggableSheet(
                  context,
                  child: Builder(
                    builder: (c) {
                      area = "";
                      return BlocProvider<Step2ActivityDataExportCubit>.value(
                        value: context.read<Step2ActivityDataExportCubit>(),
                        child: BlocBuilder<Step2ActivityDataExportCubit,
                            Step2ActivityDataExportState>(
                          builder: (context, state) {
                            return
                              BottomSheetWithActions(
                              title: "activity_add".tr(),
                              action: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: ElevatedButtonWidget.add(onPressed: () {
                                  double? a = double.tryParse(area ?? "") ?? 0;

                                  if (a <= 0) {
                                    CommonFunctions.showError(
                                        "activity_must_be_bigger_than_0".tr());
                                    return;
                                  }
                                  if (a >= state.getTotalArea()) {
                                    CommonFunctions.showError(
                                        "total_areas_error".tr());
                                    return;
                                  }

                                  if (area != null && state.userSelectedAddetionalItem != null) {
                                    ctx
                                        .read<Step2ActivityDataExportCubit>()
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
                                          value: state.userSelectedAddetionalItem,
                                          label:
                                              "userLicensesLicenseDetailsAIESECActivityWord"
                                                  .tr(),
                                          marginBottom: 8,
                                          onChangeType: (item) {
                                            AllowedActivities? i = state
                                                .lstAddetionalActivityItems
                                                ?.firstWhereOrNull((element) =>
                                                    element.isicCode ==
                                                    item?.id);
                                            i != null
                                                ? context
                                                    .read<
                                                        Step2ActivityDataExportCubit>()
                                                    .onSelectAddetionalActivity(
                                                        i)
                                                : null;
                                          }),
                                      
                                      // const CustomVerticalSpace(height: 12),
                                      // CustomTapWidgetForLongDialog(
                                      //     items: state
                                      //             .addetionalActivityItemDetails ??
                                      //         [],
                                      //     value: state.addetionalDetailsItem,
                                      //     label: "detailedActivityName".tr(),
                                      //     marginBottom: 8,
                                      //     onChangeType: (item) {
                                      //       AddetionalActivityItemDetails? i =
                                      //           state
                                      //               .addetionalActivityItemDetails
                                      //               ?.firstWhereOrNull(
                                      //                   (element) =>
                                      //                       element
                                      //                           .activityId ==
                                      //                       item?.id);
                                      //       i != null
                                      //           ? context
                                      //               .read<
                                      //                   Step2ActivityDataExportCubit>()
                                      //               .onSelectAddetionalDetailsActivity(
                                      //                   i)
                                      //           : null;
                                      //     }),
                                      const CustomVerticalSpace(height: 12),
                                      CustomTextFieldWidget(

                                        label: "addetional_total_area".tr(),
                                        hintText: "addetional_total_area".tr(),
                                        isDigitsOnly: true,
                                        keyboardType: TextInputType.number,
                                        suffixIcon: CustomTextWidget(
                                          "square_meter".tr(),
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
