import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/apply_cancel/mvvm/apply_cancel_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/mvvm/commercial_license_reason_cancel_view_model.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class CommercialLicenseReasonCancelSheet extends StatelessWidget {
  const CommercialLicenseReasonCancelSheet({super.key});

  @override
  Widget build(BuildContext context) {
    CommercialLicenseReasonCancelViewModel provider =
        context.watch<CommercialLicenseReasonCancelViewModel>();
    return BottomSheetWithActions(
      title: "cancellation_license".tr(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAutoSizeTextWidget(
            'cancellation_license_message'.tr(),
            textStyle: AppStyle.profileNameTextStyle.copyWith(
              color: AppColor.blackModern600Light,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Consumer<CommercialLicenseReasonCancelViewModel>(
            builder: (context, isLoading, child) {
              return !provider.isLoading
                  ? DropDownWithTitle(
                      title: "reason_cancel".tr(),
                      selectedValue: provider.reasonCancel?.text,
                      status: null,
                      onRetry: () {
                        // context.read<ComplianceBloc>().add(
                        //   const GetMainUsagesEvent(),
                        // );
                      },
                      onTap: () {
                        // if (state.requestDetails?.usageDisable == true) return;
                        BottomSheetDialog.showDraggableSheet(
                          context,
                          dialogKeyName: DialogName.reasonCancelDialog,
                          currentRouteName:
                              CommercialRouteName.commercialLicenseApplyCancel,
                          child: GenericBottomSheetList<ReasonCancel>(
                            title: "reason_cancel".tr(),
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
          const SizedBox(height: 16),
          Consumer<CommercialLicenseReasonCancelViewModel>(
            builder: (context, isLoading, child) {
              return ElevatedButtonWidget.primaryCustom(
                text: 'start_cancellation_request'.tr(),
                onPressed: !provider.isLoading
                    ? () async {
                        if (provider.reasonCancel != null) {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            CommercialRouteName.commercialLicenseApplyCancel,
                            arguments: ApplyCancelViewModel(
                              webService: sl(),
                              licenseId: provider.licenseId,
                              reasonCancel: provider.reasonCancel!,
                              submitterInfo: provider.submitterInfo!,
                            ),
                          );
                        } else {
                          CommonFunctions.showError(
                              'select_cancellation_reason'.tr());
                        }
                      }
                    : () {},
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButtonWidget.primaryCustomBorder(
            text: "undo".tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
