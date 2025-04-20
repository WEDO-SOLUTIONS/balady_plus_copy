import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/loading_list_widget.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/mvvm/commercial_license_request_action_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../commercial_license/domain/entities/request_info_arragments.dart';

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
                                        if (provider.requestTypeId == 1005) {
                                          Navigator.of(context).pushNamed(
                                            CommercialRouteName
                                                .renewCommercialLicenseSubmitForm,
                                            arguments: provider.requestId,
                                          );
                                        } else if (provider.requestTypeId == 1004) {

                                          // fawzi check if it from
                                          Navigator.of(context).pushNamed(
                                            CommercialRouteName.commercialLicensePage,
                                            arguments: RequestInfoArragments(requestId: provider.requestId,isFromIntialApproval: provider.isFromInitialApproval),
                                          );



                                        } else {
                                          try {
                                            Navigator.of(context)
                                                .popAndPushNamed(
                                              CommercialRouteName.commercialLicenseCancel,
                                              arguments: {
                                                "from": "request",
                                                "requestId": provider.requestId,
                                                "reasonCancel":
                                                    provider.reasonCancel,
                                                "availableCloseDate":
                                                    provider.availableCloseDate,
                                                "crNumber": "",
                                                "crType": "",
                                              },
                                            );
                                          } catch (error, stackTrace) {
                                            LogsViewModel().sendEventFromModel(
                                              event: ErrorExceptionModel(
                                                nameEvent:
                                                    EventsName.handledException,
                                                message: error.toString(),
                                                stackTrace:
                                                    stackTrace.toString(),
                                              ),
                                            );
                                          }
                                        }
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
