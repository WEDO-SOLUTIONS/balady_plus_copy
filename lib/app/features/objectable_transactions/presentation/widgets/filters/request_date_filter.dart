import 'package:balady_plus/app/features/objectable_transactions/objections_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/enums/date_form.dart';
import '../../../..//../_shared_feature_/shared_feature_exports.dart'
    show FilterDatePicker;

class RequestsDateFilter extends StatelessWidget {
  const RequestsDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectableTransactionBloc, ObjectableTransactionState>(
      buildWhen: (previous, current) =>
          previous.selectedRequestDate != current.selectedRequestDate,
      builder: (context, state) {
        return FilterDatePicker(
          title: "objectionLastApplyDate".tr(),
          initialDate: state.selectedRequestDate,
          initialDateForm: state.dateForm ?? DateForm.gregorian,
          onChange: (selectedDate, dateForm) {
            BlocProvider.of<ObjectableTransactionBloc>(context).add(
              RequestDateSelectedEvent(date: selectedDate, formDate: dateForm),
            );
          },
        );
      },
    );
  }
}
