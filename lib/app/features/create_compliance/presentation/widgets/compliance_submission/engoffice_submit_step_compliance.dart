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

class EngOfficeSubmissionCompliance extends StatelessWidget {
  const EngOfficeSubmissionCompliance({
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
                  title: 'complinace_eng_office_data'.tr(),
                  subtitle: "",
                ),
                DropDownWithTitle(
                  title: "complianace_eng_office_title".tr(),
                  selectedValue: state.selectedEngOffice?.engOfficeName,
                  status: state.enginnerOfficesStatus,
                  onRetry: () {
                    context.read<ComplianceBloc>().add(
                          const GetEngOfficesListEvent(),
                        );
                  },
                  onTap: () {
                    final List<String> items = (state.engOffices?.items ?? [])
                        .map((e) => e.engOfficeName ?? "")
                        .toList();
                    BottomSheetDialog.showDraggableSheet(
                      context,
                      // dialogKeyName: DialogName.licensesSubMunicapilityFilters,
                      //  currentRouteName: RouteName.licenses,
                      child: BottomSheetList(
                        title: "complianace_eng_office_title".tr(),
                        items: items,
                        selectedValue: state.selectedEngOffice?.engOfficeName,
                        onTap: (item) {
                          final selectedItem = (state.engOffices?.items ?? [])
                              .where((e) => e.engOfficeName == item)
                              .first;
                          context.read<ComplianceBloc>().add(
                                GetEngOfficeDetailsEvent(item: selectedItem),
                              );

                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                if (state.engOfficeDetails != null) ...[
                  SizedBox(
                    height: 32,
                  ),
                  ReadOnlyField(
                    title: "complianace_eng_office_mobile".tr(),
                    subTitle: state.engOfficeDetails?.engMobile ?? "",
                  ),
                  ReadOnlyField(
                    title: "complianace_eng_office_email".tr(),
                    subTitle: state.engOfficeDetails?.engEmail ?? "",
                  ),
                  ReadOnlyField(
                    title: "complianace_eng_office_license".tr(),
                    subTitle: state.engOfficeDetails?.engOfficeNo ?? "",
                  )
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
