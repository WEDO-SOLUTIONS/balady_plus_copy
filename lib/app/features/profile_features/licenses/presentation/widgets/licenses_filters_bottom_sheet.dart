import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../licenses_exports.dart'
    show
        LicensesBloc,
        LicensesDateFilter,
        LicensesMunicipalityFilter,
        LicensesSortFilter,
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
          return const Column(
            children: [
              LicensesTypeFilter(),
              LicensesStatusFilter(),
              LicensesDateFilter(),
              LicensesMunicipalityFilter(),
              LicensesSubMunicipalityFilter(),
              LicensesSortFilter(),
              SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }
}
