import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget;
import '../../licenses_exports.dart'
    show ApplyLicensesFiltersEvent, ClearLicensesFiltersEvent, LicensesBloc;

class LicensesFilterActions extends StatelessWidget {
  final LicensesBloc licensesBloc;

  const LicensesFilterActions({
    super.key,
    required this.licensesBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: licensesBloc,
      child: Builder(builder: (context) {
        return Column(
          children: [
            ElevatedButtonWidget.apply(
              onPressed: () {
                context.read<LicensesBloc>().add(
                      ApplyLicensesFiltersEvent(),
                    );
                Navigator.pop(context, true);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.deletaAll(
              onPressed: () {
                context.read<LicensesBloc>().add(
                      ClearLicensesFiltersEvent(),
                    );
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      }),
    );
  }
}
