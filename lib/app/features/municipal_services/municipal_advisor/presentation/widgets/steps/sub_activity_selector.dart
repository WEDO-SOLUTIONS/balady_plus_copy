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
        MunicipalAdvisorSelectIsicSubActivityEvent,
        MunicipalAdvisorState;

class SubActivitySelector extends StatefulWidget {
  const SubActivitySelector({super.key});

  @override
  State<SubActivitySelector> createState() => _SubActivitySelectorState();
}

class _SubActivitySelectorState extends State<SubActivitySelector> {
  IsicActivityEntity? isicSubActivity;

  @override
  void initState() {
    super.initState();
    isicSubActivity =
        context.read<MunicipalAdvisorBloc>().state.selectedIsicSubActivity;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Column(
          children: [
            DropDownWithTitle(
              title: "municipalAdvisorSubActivityHint".tr(),
              selectedValue: isicSubActivity?.name,
              onTap: () {
                final List<String> items =
                    state.isicSubActivities.map((e) => e.name).toList();
                BottomSheetDialog.showDraggableSheet(
                  context,
                  dialogKeyName: DialogName.municipalSubActivityDialog,
                  currentRouteName: RouteName.municipalAdvisor,
                  child: BottomSheetList(
                    title: "municipalAdvisorSubActivityHint".tr(),
                    items: items,
                    selectedValue: isicSubActivity?.name,
                    onTap: (item) {
                      setState(() {
                        isicSubActivity = state.isicSubActivities
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
              onPressed: isicSubActivity == null
                  ? null
                  : () => context.read<MunicipalAdvisorBloc>().add(
                        MunicipalAdvisorSelectIsicSubActivityEvent(
                          isicSubActivity: isicSubActivity!,
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }
}
