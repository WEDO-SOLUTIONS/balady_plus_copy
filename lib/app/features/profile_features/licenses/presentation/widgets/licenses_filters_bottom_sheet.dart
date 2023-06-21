import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget;
import '../../licenses_exports.dart'
    show
        ApplyLicensesFiltersEvent,
        ClearLicensesFiltersEvent,
        LicensesBloc,
        LicensesDateFilter,
        LicensesMunicipalityFilter,
        LicensesProductFilter,
        LicensesStatusFilter,
        LicensesSubMunicipalityFilter,
        LicensesTypeFilter;

class LicensesFilterBottomSheet extends StatelessWidget {
  final LicensesBloc licensesBloc;

  const LicensesFilterBottomSheet({
    super.key,
    required this.licensesBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: licensesBloc,
      child: SizedBox(
        width: double.infinity,
        child: Builder(builder: (context) {
          return Column(
            children: [
              const LicensesProductFilter(),
              const LicensesTypeFilter(),
              const LicensesDateFilter(),
              const LicensesStatusFilter(),
              const LicensesMunicipalityFilter(),
              const LicensesSubMunicipalityFilter(),
              const SizedBox(height: 16),
              ElevatedButtonWidget.apply(onPressed: () {
                context.read<LicensesBloc>().add(
                      ApplyLicensesFiltersEvent(),
                    );
                Navigator.pop(context);
              }),
              const SizedBox(height: 16),
              ElevatedButtonWidget.deletaAll(onPressed: () {
                context.read<LicensesBloc>().add(
                      ClearLicensesFiltersEvent(),
                    );
                Navigator.pop(context);
              }),
            ],
          );
        }),
      ),
    );
  }
}
