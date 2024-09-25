import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_details/mvvm/tobacco_details_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/mvvm/tobacco_disclosed_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/widgets/disclosed_months_sheet.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/mvvm/tobacco_attachments_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class DisclosureSchedulesWidget extends StatelessWidget {
  const DisclosureSchedulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TobaccoDetailsViewModel provider = context.watch<TobaccoDetailsViewModel>();
    return ValueListenableBuilder(
      valueListenable: provider.year,
      builder: (BuildContext context, int? value, Widget? child) {
        return ExpandableCard(
          title: 'monthsـdisclosed'.tr(),
          badgeTitle: value != null
              ? '${'months'.tr()} ${provider.tobaccoSchedule!.disclosureSchedules[value]?.length ?? 0}'
              : null,
          icon: null,
          isExpandedByDefault: true,
          children: [
            value != null
                ? Column(
                    children: provider
                            .tobaccoSchedule!.disclosureSchedules[value]
                            ?.map(
                              (e) => Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                color: AppColor.white2,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${'month'.tr()} ${e.month.toString()}',
                                              style: AppStyle.listTitleTextStyle
                                                  .copyWith(),
                                            ),
                                            const SizedBox(height: 12),
                                            e.createdDate != null
                                                ? Text(
                                                    '${'dateـcreated'.tr()} ${DateFormat.yMd().format(e.createdDate!)}',
                                                    style: AppStyle
                                                        .requestNumberTextStle,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child:
                                            ElevatedButtonWidget.primaryCustom(
                                          onPressed: () async {
                                            if (provider
                                                    .tobaccoSchedule!
                                                    .facilityInfo
                                                    .registrationNumber !=
                                                null) {
                                              CommonFunctions.sendUXCamEvent(
                                                  UXCamEvents
                                                      .startServiceTobaccoDisclosed);

                                              TobaccoDisclosedViewModel?
                                                  viewModel =
                                                  await BottomSheetDialog
                                                      .showDraggableSheet(
                                                context,
                                                dialogKeyName: DialogName
                                                    .disclosedMonthsSheetDialog,
                                                currentRouteName: CommercialRouteName
                                                    .commercialLicenseDetails,
                                                child: DisclosedMonthsSheet(
                                                  provider:
                                                      DisclosedMonthsViewModel(
                                                    disclosureSchedule: e,
                                                    repository:
                                                        provider.repository,
                                                    facility: provider
                                                        .tobaccoSchedule!
                                                        .facilityInfo,
                                                  ),
                                                ),
                                                isFullHeight: false,
                                              );
                                              if (viewModel != null) {
                                                await Navigator.of(context)
                                                    .pushNamed(
                                                  CommercialRouteName.tobaccoDisclosed,
                                                  arguments: viewModel,
                                                );
                                                provider
                                                    .getUserFacilitiesDetails();
                                              } else {
                                                CommonFunctions.sendUXCamEvent(
                                                  UXCamEvents
                                                      .closeServiceTobaccoDisclosed,
                                                );
                                              }
                                            } else {
                                              CommonFunctions.showError(
                                                  'error_please_try_again_later');
                                            }
                                          },
                                          text: 'disclosure'.tr(),
                                          height: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList() ??
                        [],
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
