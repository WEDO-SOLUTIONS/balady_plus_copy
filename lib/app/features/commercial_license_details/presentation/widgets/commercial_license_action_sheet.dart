import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/mvvm/commercial_license_action_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/mvvm/commercial_license_reason_cancel_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/commercial_license_reason_cancel_sheet.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/widgets/loading_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class CommercialLicenseActionSheet extends StatelessWidget {
  const CommercialLicenseActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    CommercialLicenseActionViewModel provider =
        context.watch<CommercialLicenseActionViewModel>();
    return BottomSheetWithActions(
      title: "procedures".tr(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<CommercialLicenseActionViewModel, bool>(
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
                                      case 1008:
                                        BottomSheetDialog.showDraggableSheet(
                                          context,
                                          dialogKeyName: DialogName
                                              .commercialLicenseReasonCancelSheet,
                                          currentRouteName: RouteName
                                              .commercialLicenseDetails,
                                          child: ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                CommercialLicenseReasonCancelViewModel(
                                              webService: sl(),
                                              submitterInfo:
                                                  provider.submitterInfo,
                                              licenseId: provider.licenseId,
                                            ),
                                            child:
                                                const CommercialLicenseReasonCancelSheet(),
                                          ),
                                          isFullHeight: false,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.47,
                                        );
                                        break;
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          IconPath.cancelOrder,
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
                          child: ReloadWidget(
                            onTab: () {
                              provider.getCommercialLicenseAllowedActions();
                            },
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
