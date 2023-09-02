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
