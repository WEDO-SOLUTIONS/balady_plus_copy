import 'package:balady_plus/app/features/objectable_transactions/objections_exports.dart';
import 'package:balady_plus/app/features/profile_features/violations/presentation/violations_bloc/violations_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/date_form.dart';
import '../../../../..//../_shared_feature_/shared_feature_exports.dart'
    show FilterDatePicker;

class ViolationIssueDateDateFilter extends StatelessWidget {
  const ViolationIssueDateDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationsBloc, ViolationsState>(
      buildWhen: (previous, current) =>
          previous.selectedViolationIssueDate !=
          current.selectedViolationIssueDate,
      builder: (context, state) {
        return FilterDatePicker(
          title: "invoice_violation_date".tr(),
          initialDate: state.selectedViolationIssueDate,
          initialDateForm: state.issueDateForm ?? DateForm.gregorian,
          onChange: (selectedDate, dateForm) {
            BlocProvider.of<ViolationsBloc>(context).add(
              ViolationIssueDateSelectedEvent(
                  date: selectedDate, formDate: dateForm),
            );
          },
        );
      },
    );
  }
}
