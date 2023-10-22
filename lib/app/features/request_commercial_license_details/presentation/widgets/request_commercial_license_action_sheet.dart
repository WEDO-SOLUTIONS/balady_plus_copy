import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/mvvm/commercial_license_action_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/mvvm/commercial_license_reason_cancel_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/commercial_license_reason_cancel_sheet.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/loading_list_widget.dart';
import 'package:balady_plus/app/features/request_commercial_license_details/presentation/mvvm/commercial_license_request_action_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class RequestCommercialLicenseActionSheet extends StatelessWidget {
  const RequestCommercialLicenseActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    RequestCommercialLicenseActionViewModel provider =
        context.watch<RequestCommercialLicenseActionViewModel>();
    return BottomSheetWithActions(
      title: "procedures".tr(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<RequestCommercialLicenseActionViewModel, bool>(
            selector: (_, provider) => provider.isLoading,
            builder: (context, isLoading, child) {
              return !isLoading
                  ? provider.actions.isNotEmpty
                      ? Column(
                          children: provider.actions
                              .map(
                                (action) => InkWell(
                                  onTap: () {
                                    switch (action.id) {
                                      case "cancel":
                                        break;
                                      case "edit":
                                        try {
                                          Navigator.of(context).pushNamed(
                                            RouteName.commercialLicenseCancel,
                                            arguments:
                                                CommercialLicenseCancelBloc(
                                              webService: sl(),
                                              // cancellationRequestResponse: cancellationRequest,
                                              crNumber: CommonProperties
                                                  .selectedDelegator!.crNumber!,
                                              crType: CommonProperties
                                                  .selectedDelegator!.crType,
                                              reasonCancel:
                                                  provider.reasonCancel,
                                              requestId: provider.requestId,
                                              availableCloseDate:
                                                  provider.availableCloseDate,
                                            ),
                                          );
                                        } catch (e) {}
                                        break;
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          action.id == 'cancel'
                                              ? IconPath.cancelOrder
                                              : IconPath.editIcon,
                                          width: 30,
                                          height: 30,
                                        ),
                                        const SizedBox(width: 8),
                                        CustomAutoSizeTextWidget(
                                          action.name,
                                          textStyle: AppStyle
                                              .profileNameTextStyle
                                              .copyWith(
                                            color: AppColor.blackModern600Light,
                                          ),
                                          maxLines: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : Center(
                          child: CustomTextWidget(
                            ('data_not_have_actions').tr(),
                            fontSize: 14,
                            fontColor: AppColor.primary900Light,
                            textAlign: TextAlign.center,
                          ),
                        )
                  : const LoadingListWidget();
            },
          ),
        ],
      ),
    );
  }
}
