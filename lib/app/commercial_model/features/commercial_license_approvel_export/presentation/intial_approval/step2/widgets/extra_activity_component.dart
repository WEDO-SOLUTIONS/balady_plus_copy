import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step2/bloc/step2_activity_data_export_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step2/widgets/extra_activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import '../../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/buttons/plus_add_button.dart';
import '../../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../data/models/initialApproval/sub_activity_details_data.dart';
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
                    "addetional_data_quest".tr(),
                    fontWeight: AppFontWeight.bold,
                    fontSize: 15,
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
                                        .addAddetionalItemRequest(area:double.tryParse(area ?? "")!);
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
                                              "detailedActivityName"
                                                  .tr(),
                                          marginBottom: 8,
                                          onChangeType: (item) {
                                            AllowedActivities? i = state.lstAddetionalActivityItems?.firstWhereOrNull((element) =>
                                            element.isicCode == item?.id);
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
              const SizedBox(height: 12),
              NotesWidget(notes: ["extra_data_note".tr()],),
            ],
          ),
        );
      },
    );
  }
}
