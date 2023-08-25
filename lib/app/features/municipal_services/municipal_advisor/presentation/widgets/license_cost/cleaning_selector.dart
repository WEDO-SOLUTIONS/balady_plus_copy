import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart';

class CleaningSelector extends StatelessWidget {
  final bool calculateFees;

  const CleaningSelector({
    super.key,
    this.calculateFees = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          builder: (context, state) {
            return DropDownWithTitle(
              title: "CleaningMechanisms".tr(),
              selectedValue: state.selectedCleanMechanism?.name,
              onTap: () {
                final List<String> items = state.cleaningMechanisms
                    .map((e) => e.name)
                    .toList()
                    .cast<String>();
                BottomSheetDialog.showDraggableSheet(
                  context,
                  dialogKeyName: DialogName.municipalAdvisorCleaning,
                  currentRouteName: RouteName.municipalAdvisor,
                  child: BottomSheetList(
                    title: "CleaningMechanisms".tr(),
                    items: items,
                    selectedValue: state.selectedCleanMechanism?.name,
                    onTap: (item) {
                      final CleaningEntity cleaningEntity =
                          state.cleaningMechanisms.firstWhere(
                        (element) => element.name == item,
                      );
                      BlocProvider.of<MunicipalAdvisorBloc>(context).add(
                        MunicipalAdvisorSelectCleaningMechanismEvent(
                          cleaningMechanism: cleaningEntity,
                          calculateFees: calculateFees,
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
