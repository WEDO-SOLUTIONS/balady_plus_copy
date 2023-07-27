import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart'
    show
        ActivityDetailsEntity,
        MunicipalAdvisorBloc,
        MunicipalAdvisorSelectAdditionalActivitiesEvent,
        MunicipalAdvisorState;

class AdditionalActivitiesSelector extends StatefulWidget {
  const AdditionalActivitiesSelector({super.key});

  @override
  State<AdditionalActivitiesSelector> createState() =>
      _AdditionalActivitiesSelectorState();
}

class _AdditionalActivitiesSelectorState
    extends State<AdditionalActivitiesSelector> {
  List<ActivityDetailsEntity> additionalActivities = [];

  @override
  void initState() {
    super.initState();
    additionalActivities =
        context.read<MunicipalAdvisorBloc>().state.selectedAdditionalActivities;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        final selectedValuesList =
            additionalActivities.map((e) => e.activityName).toList();

        return Column(
          children: [
            DropDownWithTitle(
              title: "municipalAdvisorAdditionalActivitiesTitle".tr(),
              selectedValue: selectedValuesList.join(", "),
              onTap: () {
                final List<String> items = state.additionalActivities
                    .map((e) => e.activityName)
                    .toList();
                BottomSheetDialog.showDraggableSheet(
                  context,
                  child: BottomSheetList(
                    title: "municipalAdvisorAdditionalActivitiesTitle".tr(),
                    items: items,
                    selectedValues: selectedValuesList,
                    onTap: (items) {
                      if (items is List<String>) {
                        setState(() {
                          additionalActivities = state.additionalActivities
                              .where((element) =>
                                  items.contains(element.activityName))
                              .toList();
                        });
                      }

                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.choose(
              onPressed: additionalActivities.isEmpty
                  ? null
                  : () => context.read<MunicipalAdvisorBloc>().add(
                        MunicipalAdvisorSelectAdditionalActivitiesEvent(
                          additionalActivities: additionalActivities,
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
