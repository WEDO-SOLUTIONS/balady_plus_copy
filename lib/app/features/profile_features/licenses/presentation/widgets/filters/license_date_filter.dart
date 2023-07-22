import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/date_form.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show FilterDatePicker;
import '../../../licenses_exports.dart'
    show LicenseDateSelectedEvent, LicensesBloc, LicensesState;

class LicensesDateFilter extends StatelessWidget {
  const LicensesDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicensesBloc, LicensesState>(
      buildWhen: (previous, current) =>
          previous.selectedLicenseEndDate != current.selectedLicenseEndDate,
      builder: (context, state) {
        return FilterDatePicker(
          title: "license_end_date".tr(),
          initialDate: state.selectedLicenseEndDate,
          initialDateForm: state.dateForm ?? DateForm.gregorian,
          onChange: (selectedDate, dateForm) {
            BlocProvider.of<LicensesBloc>(context).add(
              LicenseDateSelectedEvent(date: selectedDate, formDate: dateForm),
            );
          },
        );
      },
    );
  }
}
