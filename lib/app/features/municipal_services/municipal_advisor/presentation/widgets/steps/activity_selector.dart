import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart'
    show
        IsicActivityEntity,
        MunicipalAdvisorBloc,
        MunicipalAdvisorSelectIsicActivityEvent,
        MunicipalAdvisorState;

class ActivitySelector extends StatefulWidget {
  const ActivitySelector({super.key});

  @override
  State<ActivitySelector> createState() => _ActivitySelectorState();
}

class _ActivitySelectorState extends State<ActivitySelector> {
  IsicActivityEntity? isicActivity;

  @override
  void initState() {
    super.initState();
    isicActivity =
        context.read<MunicipalAdvisorBloc>().state.selectedIsicActivity;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Column(
          children: [
            DropDownWithTitle(
              title: "municipalAdvisorActivityHint".tr(),
              selectedValue: isicActivity?.name,
              onTap: () {
                final List<String> items =
                    state.isicActivities.map((e) => e.name).toList();
                BottomSheetDialog.showDraggableSheet(
                  context,
                  dialogKeyName: DialogName.municipalAdvisorActivitySelector,
                  currentRouteName: RouteName.municipalAdvisor,
                  child: BottomSheetList(
                    title: "municipalAdvisorActivityHint".tr(),
                    items: items,
                    selectedValue: isicActivity?.name,
                    onTap: (item) {
                      setState(() {
                        isicActivity = state.isicActivities
                            .where((e) => e.name == item)
                            .first;
                      });

                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.choose(
              onPressed: isicActivity == null
                  ? null
                  : () => context.read<MunicipalAdvisorBloc>().add(
                        MunicipalAdvisorSelectIsicActivityEvent(
                          isicActivity: isicActivity!,
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }
}
