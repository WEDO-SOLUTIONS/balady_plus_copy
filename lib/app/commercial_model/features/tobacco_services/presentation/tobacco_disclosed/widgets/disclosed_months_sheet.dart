import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/disclosure_request.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/mvvm/tobacco_attachments_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/mvvm/tobacco_disclosed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class DisclosedMonthsSheet extends StatelessWidget {
  final DisclosedMonthsViewModel provider;

  const DisclosedMonthsSheet({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => provider,
      child: BottomSheetWithActions(
        title:
            "${"disclosure_month".tr()} ${provider.disclosureSchedule.month}",
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<DisclosedMonthsViewModel, bool>(
              selector: (_, provider) => provider.reason,
              builder: (BuildContext context, isLoading, Widget? child) {
                return isLoading
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<DisclosedMonthsViewModel>(
                            builder: (context, isLoading, child) {
                              return !provider.isLoading
                                  ? DropDownWithTitle(
                                      title: "reason".tr(),
                                      isRequired: true,
                                      selectedValue:
                                          provider.reasonCancel?.text,
                                      status: null,
                                      onRetry: () {},
                                      onTap: () {
                                        // if (state.requestDetails?.usageDisable == true) return;
                                        BottomSheetDialog.showDraggableSheet(
                                          context,
                                          dialogKeyName:
                                              DialogName.reasonCancelDialog,
                                          currentRouteName: CommercialRouteName
                                              .commercialLicenseApplyCancel,
                                          child: GenericBottomSheetList<
                                              ReasonCancel>(
                                            title: "reason".tr(),
                                            items: provider.reasonCancelList,
                                            selectedValue: null,
                                            onTap: (item) {
                                              provider.selectReasonCancel(item);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  : const ShimmerEffectWidget(
                                      height: 55,
                                      borderRadius: 6,
                                    );
                            },
                          ),
                          ////////////////////////////////////////////////
                          ////////////////////////////////////////////////
                          Row(
                            children: [
                              CustomTextWidget(
                                'notes'.tr(),
                                textStyle: AppStyle.dropDownTitleTextStyle,
                              ),
                              CustomTextWidget(
                                '*'.tr(),
                                textStyle:
                                    AppStyle.dropDownTitleTextStyle.copyWith(
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          CustomTextFieldWidget(
                            keyboardType: TextInputType.text,
                            onChanged: (text) {
                              provider.removeDisclosureComments = text;
                            },
                            disabledColor: Colors.transparent,
                            maxLines: 4,
                            onValidate: (text) => (text?.isNotEmpty ?? false)
                                ? null
                                : "required_field_must_number".tr(),
                          ),
                        ],
                      )
                    : child!;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomTextWidget(
                        'cost'.tr(),
                        textStyle: AppStyle.dropDownTitleTextStyle,
                      ),
                      CustomTextWidget(
                        '*'.tr(),
                        textStyle: AppStyle.dropDownTitleTextStyle.copyWith(
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CustomTextFieldWidget(
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if (text.isNotEmpty && double.tryParse(text) != null) {
                        provider.amount = double.parse(text);
                      }
                    },
                    disabledColor: Colors.transparent,
                    onValidate: (text) => (text?.isNotEmpty ?? false) &&
                            double.tryParse(text!) != null &&
                            double.parse(text) > 0
                        ? null
                        : "required_field_must_number".tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomTextWidget(
                      'lbl_attachments'.tr(),
                      fontColor: AppColor.blackModern700Light,
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                    ),
                    CustomTextWidget(
                      '*'.tr(),
                      textStyle: AppStyle.dropDownTitleTextStyle.copyWith(
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    FileDataItem? file = await CommonFunctions.pickFile(
                      context,
                    );
                    if (file != null) {
                      if ((file.sizeInMB * 1000) <= 10024) {
                        await provider.uploadTobaccoServicesAttachments(file);
                        if (provider.attachmentId != null) {
                          CommonFunctions.showSuccess(
                              "attached_successfully".tr());
                        }
                      } else {
                        CommonFunctions.showError("file_max_size".tr());
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border: Border.all(
                        color: AppColor.primary800Light,
                      ),
                      color: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomSvgIconWidget(
                          IconPath.add,
                          iconSize: 20,
                        ),
                        const SizedBox(width: 4),
                        CustomTextWidget(
                          'attachment'.tr(),
                          fontColor: AppColor.primary800Light,
                          fontSize: 16,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                CustomTextWidget(
                  '${'attachment_message_typ'.tr()} ${'xls,xlsx,csv,pdf,png,jpg,jpeg'} ${'attachment_message_size'.tr()} ${(10024) ~/ 1000} MB',
                  fontColor: AppColor.blackModern700Light,
                  fontSize: 16,
                  fontWeight: AppFontWeight.bold,
                  maxLines: 3,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Selector<DisclosedMonthsViewModel, bool>(
              selector: (_, provider) => provider.reason,
              builder: (BuildContext context, isLoading, Widget? child) {
                return isLoading ? const SizedBox() : child!;
              },
              child: Row(
                children: [
                  CustomTextWidget(
                    'no_revenue_disclose'.tr(),
                    fontColor: AppColor.blackModern700Light,
                    fontSize: 14,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const SizedBox(width: 3),
                  CustomTextButtonWidget(
                    onPressed: () {
                      provider.setReason(true);
                      CommonFunctions.sendUXCamEvent(
                        UXCamEvents.startServiceTobaccoDisclosedNoRevenue,
                      );
                    },
                    text: 'click_here'.tr(),
                    btnTextSize: 14,
                    btnHeight: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Selector<DisclosedMonthsViewModel, bool>(
              builder: (BuildContext context, isLoading, Widget? child) {
                return isLoading
                    ? const ShimmerEffectWidget(
                        height: 60,
                        borderRadius: 8,
                      )
                    : child!;
              },
              selector: (_, provider) => provider.isLoading,
              child: ElevatedButtonWidget.primaryCustom(
                onPressed: () async {
                  if (provider.reason ||
                      (provider.amount != null && provider.amount != 0)) {
                    if (!provider.reason || provider.reasonCancel != null) {
                      if (!provider.reason ||
                          provider.removeDisclosureComments != null) {
                        if (provider.attachmentId != null) {
                          Navigator.of(context).pop(
                            TobaccoDisclosedViewModel(
                              repository: provider.repository,
                              fileUploaded: provider.fileUploaded,
                              disclosureRequest: DisclosureRequest(
                                disclosureSchedule: provider.disclosureSchedule,
                                facility: provider.facility,
                                attachmentId: provider.attachmentId,
                                disclosureAmount: provider.amount,
                                removeDisclosureComments:
                                    provider.removeDisclosureComments,
                                removeDisclosureReasonId:
                                    provider.reasonCancel?.id,
                              ),
                            ),
                          );
                        } else {
                          CommonFunctions.showError('must_add_attachment'.tr());
                        }
                      } else {
                        CommonFunctions.showError('must_comment'.tr());
                      }
                    } else {
                      CommonFunctions.showError('select_reason'.tr());
                    }
                  } else {
                    CommonFunctions.showError('you_must_choose_amount'.tr());
                  }
                },
                text: 'disclosure'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
