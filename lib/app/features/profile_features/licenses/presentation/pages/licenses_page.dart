import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        DefaultAppBarWidget,
        DraggableSheetComponent,
        FilterIcon;
import '../../../requests/requests_exports.dart' show AppBarSeachBar;
import '../../licenses_exports.dart'
    show
        GetLicensesEvent,
        LicensesBloc,
        LicensesFilterBottomSheet,
        LicensesList,
        LicensesLoadLookupsEvent,
        SearchLicensesEvent;

class LicensesPage extends StatelessWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicensesBloc>(
      create: (context) => sl<LicensesBloc>()..add(GetLicensesEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'licenses'.tr(),
            bottom: AppBarSeachBar(
              onChanged: (value) {
                context.read<LicensesBloc>().add(
                      SearchLicensesEvent(
                        query: value,
                      ),
                    );
              },
            ),
            actions: [
              FilterIcon(
                onTap: () {
                  context.read<LicensesBloc>().add(LicensesLoadLookupsEvent());
                  BottomSheetDialog.showDraggableSheet(
                    context,
                    child: DraggableSheetComponent(
                      title: "filters".tr(),
                      height: 0.9,
                      body: LicensesFilterBottomSheet(
                        licensesBloc: context.read<LicensesBloc>(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: LicensesList(),
          ),
        );
      }),
    );
  }
}
