import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/custom_expansion_panel.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget%20copy.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/radio_custom.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../vd/domain/entities/gis/gis_params.dart';
import '../../../../vd/domain/entities/map/map_screen_params.dart';
import '../../../domain/entities/ownership_doc_type_response.dart';
import '../../bloc/compliance_bloc.dart';

class UsageSubmissionCompliance extends StatelessWidget {
  const UsageSubmissionCompliance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ComplianceSubmitTitle(
                  title: 'compliance_usages'.tr(),
                  subtitle: "",
                ),
                const SizedBox(
                  height: 10,
                ),
                DropDownWithTitle(
                  title: "compliance_main_usage".tr(),
                  selectedValue: state.selectedMainUsage?.name,
                  status: state.mainUsagesStatus,
                  onRetry: () {
                    context.read<ComplianceBloc>().add(
                          const GetMainUsagesEvent(),
                        );
                  },
                  onTap: () {
                    if (state.requestDetails?.usageDisable == true) return;

                    BottomSheetDialog.showDraggableSheet(
                      context,
                      dialogKeyName: DialogName.complianceMainUsagesDialog,
                      currentRouteName: RouteName.submitCompliancePage,
                      child: GenericBottomSheetList<ComplinaceLookUpItem>(
                        title: "compliance_main_usage".tr(),
                        items: state.mainUsages?.items ?? [],
                        selectedValue: state.selectedMainUsage,
                        onTap: (item) {
                          context.read<ComplianceBloc>().add(
                                GetSubUsagesEvent(item: item),
                              );

                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                DropDownWithTitle(
                  title: "compliance_sub_usage".tr(),
                  selectedValue: state.selectedSubUsage?.name,
                  status: state.subUsagesStatus,
                  onRetry: () {
                    context.read<ComplianceBloc>().add(
                          const GetSubUsagesEvent(),
                        );
                  },
                  onTap: () {
                    if (state.requestDetails?.usageDisable == true) return;

                    BottomSheetDialog.showDraggableSheet(
                      context,
                      dialogKeyName: DialogName.complianceSubUsagesDialog,
                      currentRouteName: RouteName.submitCompliancePage,
                      child: GenericBottomSheetList<ComplinaceLookUpItem>(
                        title: "compliance_sub_usage".tr(),
                        items: state.subUsages?.items ?? [],
                        selectedValue: state.selectedSubUsage,
                        onTap: (item) {
                          context.read<ComplianceBloc>().add(
                                UpdateFieldsEvent(
                                  selectedSubUsage: item,
                                ),
                              );
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                if (state.documentTypeSelection == 2) ...[
                  CustomVerticalSpace(height: 16),
                  ComplianceSubmitTitle(
                    title: 'location_data'.tr(),
                    subtitle: "",
                  ),
                  DropDownWithTitle(
                    title: "geo_location".tr(),
                    selectedValue: state.gisResponse?.getFullAddress(),
                    onRetry: () {
                      /* context.read<ComplianceBloc>().add(
                            const GetSubUsagesEvent(),
                          );*/
                    },
                    onTap: () async {
                      await NavigationService.navigatorKey.currentState!
                          .pushNamed(RouteName.complinaceMapView,
                              arguments: MapScreenParams(
                                  gisParams: state.gisParams,
                                  complianceGIS: state.gisResponse,
                                  requestNo: state.requestId))
                          .then((value) {
                        if (value != null) {
                          MapScreenParams? params = value as MapScreenParams;
                          context.read<ComplianceBloc>().emit(state.copyWith(
                              gisResponse: params.complianceGIS,
                              gisParams: params.gisParams));
                        }
                      });
                    },
                  ),
                  if (state.gisResponse != null) ...[
                    ReadOnlyField(
                        title: "municipality".tr(),
                        subTitle: state.gisResponse?.amanaName ?? ""),
                    ReadOnlyField(
                        title: "sub_municipality".tr(),
                        subTitle: state.gisResponse?.municipalityName ?? ""),
                    ReadOnlyField(
                        title: "city".tr(),
                        subTitle: state.gisResponse?.city ?? ""),
                    ReadOnlyField(
                        title: "district".tr(),
                        subTitle: state.gisResponse?.districtName ?? ""),
                    ReadOnlyField(
                        title: "planNumber".tr(),
                        subTitle: state.gisResponse?.planNo ?? ""),
                    ReadOnlyField(
                        title: "plan_name".tr(),
                        subTitle: state.gisResponse?.planName ?? ""),
                    ReadOnlyField(
                        title: "street_name".tr(),
                        subTitle: state.gisResponse?.streetName ?? ""),
                    ComplianceSubmitTitle(
                      title: "lands_info".tr(),
                      subtitle: "",
                    ),
                    ReadOnlyField(
                        title: "parcel_number".tr(),
                        subTitle: state.gisResponse?.parcelNo ?? ""),
                    ReadOnlyField(
                        title: "land_area".tr(),
                        subTitle: state.gisResponse?.area ?? ""),
                    /*ComplianceSubmitTitle(
                    title: 'الاحداثيات'.tr(),
                    subtitle: "",
                  ),
                  ReadOnlyField(
                      title: "الاحداثي السيني".tr(),
                      subTitle: state.gisParams?.x.toString() ?? ""),
                  ReadOnlyField(
                      title: "الاحداثي الصادي".tr(),
                      subTitle: state.gisParams?.y.toString() ?? ""),*/
                  ]
                ],
                if (state.documentTypeSelection == 1) ...[
                  CustomVerticalSpace(height: 16),
                  ComplianceSubmitTitle(
                    title: "location_data".tr(),
                    subtitle: "",
                  ),
                  DropDownWithTitle(
                    title: "geo_location".tr(),
                    selectedValue: state.requestDetails?.locationResponseInfoDto
                        ?.getFullAddress(),
                    onRetry: () {},
                    onTap: () async {
                      await NavigationService.navigatorKey.currentState!
                          .pushNamed(RouteName.complinaceMapView,
                              arguments: MapScreenParams(
                                  gisParams: state
                                      .requestDetails?.locationResponseInfoDto
                                      ?.gisParams(),
                                  complianceGIS: state.gisResponse,
                                  readOnly: true,
                                  requestNo: state.requestId))
                          .then((value) {
                        if (value != null) {
                          MapScreenParams? params = value as MapScreenParams;
                          context.read<ComplianceBloc>().emit(state.copyWith(
                              gisResponse: params.complianceGIS,
                              gisParams: params.gisParams));
                        }
                      });
                    },
                  ),
                  ReadOnlyField(
                      title: "municipality".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.municipalityName ??
                          ""),
                  ReadOnlyField(
                      title: "sub_municipality".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.subMunicipalityName ??
                          ""),
                  ReadOnlyField(
                      title: "city".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.cityName ??
                          ""),
                  ReadOnlyField(
                      title: "district".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.districtName ??
                          ""),
                  ReadOnlyField(
                      title: "planNumber".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.mapNumber ??
                          ""),
                  ReadOnlyField(
                      title: "plan_name".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.mapName ??
                          ""),
                  ReadOnlyField(
                      title: "street_name".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.streetName ??
                          ""),
                  ComplianceSubmitTitle(
                    title: "lands_info".tr(),
                    subtitle: "",
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.requestDetails?.locationResponseInfoDto
                              ?.landsInfo?.landsInfo?.length ??
                          0,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            ReadOnlyField(
                                title: "parcel_number".tr(),
                                subTitle: state
                                        .requestDetails
                                        ?.locationResponseInfoDto
                                        ?.landsInfo
                                        ?.landsInfo?[index]
                                        .landNumber ??
                                    ""),
                            ReadOnlyField(
                                title: "land_area".tr(),
                                subTitle: state
                                        .requestDetails
                                        ?.locationResponseInfoDto
                                        ?.landsInfo
                                        ?.landsInfo?[index]
                                        .landArea ??
                                    ""),
                            const CustomVerticalSpace(height: 16),
                          ],
                        );
                      })

                  /*ComplianceSubmitTitle(
                    title: 'الاحداثيات'.tr(),
                    subtitle: "",
                  ),
                  ReadOnlyField(
                      title: "الاحداثي السيني".tr(),
                      subTitle:
                          state.requestDetails?.locationResponseInfoDto?.x ??
                              ""),
                  ReadOnlyField(
                      title: "الاحداثي الصادي".tr(),
                      subTitle:
                          state.requestDetails?.locationResponseInfoDto?.y ??
                              ""),*/
                ],
                SizedBox(
                  height: 32,
                ),
                PreviousNextButtons()
              ],
            ),
          ),
        );
      },
    );
  }
}
