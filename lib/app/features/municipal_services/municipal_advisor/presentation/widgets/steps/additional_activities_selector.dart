import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart'
    show
        ActivityDetailsEntity,
        AddAddetionalActivityEvent,
        ChangeAreaInAddetionalActivityEvent,
        DeleteAddetionalActivityEvent,
        MunicipalAdvisorBloc,
        MunicipalAdvisorSelectAdditionalActivitiesEvent,
        MunicipalAdvisorState;
import '../addetional_activity_item_widget.dart';

class AdditionalActivitiesSelector extends StatefulWidget {
  const AdditionalActivitiesSelector({super.key});

  @override
  State<AdditionalActivitiesSelector> createState() =>
      _AdditionalActivitiesSelectorState();
}

class _AdditionalActivitiesSelectorState
    extends State<AdditionalActivitiesSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.selectedAdditionalActivities.isEmpty)
              DropDownWithTitle(
                title: "municipalAdvisorAdditionalActivitiesTitle".tr(),
                selectedValue: state.selectedAdditionalActivities.join(", "),
                onTap: () {
                  BottomSheetDialog.showDraggableSheet<ActivityDetailsEntity>(
                    context,
                    dialogKeyName:
                        DialogName.municipalAddetionalActivitySelector,
                    currentRouteName: RouteName.municipalAdvisor,
                    child: GenericBottomSheetList<ActivityDetailsEntity>(
                      title: "municipalAdvisorAdditionalActivitiesTitle".tr(),
                      items: state.additionalActivities,
                      selectedValues: state.selectedAdditionalActivities,
                      onTap: (items) {
                        context.read<MunicipalAdvisorBloc>().add(
                            AddAddetionalActivityEvent(
                                list: items.cast<ActivityDetailsEntity>()));

                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            if (state.selectedAdditionalActivities.isNotEmpty) ...[
              ...state.selectedAdditionalActivities
                  .map((e) => AddetionalActivityItemWidget(
                        item: e,
                        onChangedArea: (String? value) {
                          context.read<MunicipalAdvisorBloc>().add(
                              ChangeAreaInAddetionalActivityEvent(
                                  activityDetails: e, area: value ?? ""));
                        },
                        onDelete: () {
                          context.read<MunicipalAdvisorBloc>().add(
                              DeleteAddetionalActivityEvent(
                                  activityDetails: e));
                        },
                      ))
                  .toList()
            ],
            const SizedBox(height: 16),
            ElevatedButtonWidget.choose(
              onPressed: state.selectedAdditionalActivities.isEmpty
                  ? null
                  : () => context.read<MunicipalAdvisorBloc>().add(
                        MunicipalAdvisorSelectAdditionalActivitiesEvent(
                          additionalActivities:
                              state.selectedAdditionalActivities,
                        ),
                      ),
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.noAdditionalActivities(
              onPressed: () => context.read<MunicipalAdvisorBloc>().add(
                    const MunicipalAdvisorSelectAdditionalActivitiesEvent(
                      additionalActivities: [],
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }
}
