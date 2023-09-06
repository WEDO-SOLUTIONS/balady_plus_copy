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
import '../../../../vd/domain/entities/gis/gis_params.dart';
import '../../../../vd/domain/entities/map/map_screen_params.dart';
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
                    final List<String> items = (state.mainUsages?.items ?? [])
                        .map((e) => e.name ?? "")
                        .toList();
                    BottomSheetDialog.showDraggableSheet(
                      context,
                      // dialogKeyName: DialogName.licensesSubMunicapilityFilters,
                      //  currentRouteName: RouteName.licenses,
                      child: BottomSheetList(
                        title: "compliance_main_usage".tr(),
                        items: items,
                        selectedValue: state.selectedMainUsage?.name,
                        onTap: (item) {
                          final selectedItem = (state.mainUsages?.items ?? [])
                              .where((e) => e.name == item)
                              .first;
                          context.read<ComplianceBloc>().add(
                                GetSubUsagesEvent(item: selectedItem),
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

                    final List<String> items = (state.subUsages?.items ?? [])
                        .map((e) => e.name ?? "")
                        .toList();
                    BottomSheetDialog.showDraggableSheet(
                      context,
                      // dialogKeyName: DialogName.licensesSubMunicapilityFilters,
                      //  currentRouteName: RouteName.licenses,
                      child: BottomSheetList(
                        title: "compliance_sub_usage".tr(),
                        items: items,
                        selectedValue: state.selectedSubUsage?.name,
                        onTap: (item) {
                          final selectedItem = (state.subUsages?.items ?? [])
                              .where((e) => e.name == item)
                              .first;
                          context.read<ComplianceBloc>().add(
                                UpdateFieldsEvent(
                                  selectedSubUsage: selectedItem,
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
                    title: 'بيانات الموقع'.tr(),
                    subtitle: "",
                  ),
                  ReadOnlyField(
                      title: "الأمانة".tr(),
                      subTitle: state.gisResponse?.amanaName ?? ""),
                  ReadOnlyField(
                      title: "البلدية".tr(),
                      subTitle: state.gisResponse?.municipalityName ?? ""),
                  ReadOnlyField(
                      title: "المدينة".tr(),
                      subTitle: state.gisResponse?.city ?? ""),
                  ReadOnlyField(
                      title: "الحي".tr(),
                      subTitle: state.gisResponse?.districtName ?? ""),
                  ReadOnlyField(
                      title: "رقم المخطط".tr(),
                      subTitle: state.gisResponse?.planNo ?? ""),
                  ReadOnlyField(
                      title: "اسم المخطط".tr(),
                      subTitle: state.gisResponse?.planName ?? ""),
                  ReadOnlyField(
                      title: "اسم الشارع".tr(),
                      subTitle: state.gisResponse?.streetName ?? ""),
                  ComplianceSubmitTitle(
                    title: 'بيانات قطع الأراضي'.tr(),
                    subtitle: "",
                  ),
                  ReadOnlyField(
                      title: "رقم قطعة الأرض".tr(),
                      subTitle: state.gisResponse?.parcelNo ?? ""),
                  ReadOnlyField(
                      title: "مساحة الارض".tr(),
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
                ],
                if (state.documentTypeSelection == 1) ...[
                  CustomVerticalSpace(height: 16),
                  ComplianceSubmitTitle(
                    title: 'بيانات الموقع'.tr(),
                    subtitle: "",
                  ),
                  DropDownWithTitle(
                    title: "الموقع الجغرافي".tr(),
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
                                  readOnly: true))
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
                      title: "الأمانة".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.municipalityName ??
                          ""),
                  ReadOnlyField(
                      title: "البلدية".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.subMunicipalityName ??
                          ""),
                  ReadOnlyField(
                      title: "المدينة".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.cityName ??
                          ""),
                  ReadOnlyField(
                      title: "الحي".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.districtName ??
                          ""),
                  ReadOnlyField(
                      title: "رقم المخطط".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.mapNumber ??
                          ""),
                  ReadOnlyField(
                      title: "اسم المخطط".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.mapName ??
                          ""),
                  ReadOnlyField(
                      title: "اسم الشارع".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.streetName ??
                          ""),
                  ComplianceSubmitTitle(
                    title: 'بيانات قطع الأراضي'.tr(),
                    subtitle: "",
                  ),
                  ReadOnlyField(
                      title: "رقم قطعة الأرض".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.landNumber ??
                          ""),
                  ReadOnlyField(
                      title: "مساحة الارض".tr(),
                      subTitle: state.requestDetails?.locationResponseInfoDto
                              ?.landArea ??
                          ""),
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
