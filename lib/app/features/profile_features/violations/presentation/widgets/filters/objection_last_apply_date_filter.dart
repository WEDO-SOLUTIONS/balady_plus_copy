import 'package:balady_plus/app/features/objectable_transactions/objections_exports.dart';
import 'package:balady_plus/app/features/profile_features/violations/presentation/violations_bloc/violations_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/date_form.dart';
import '../../../../..//../_shared_feature_/shared_feature_exports.dart'
    show FilterDatePicker;

class ObjectionLastApplyDateFilter extends StatelessWidget {
  const ObjectionLastApplyDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationsBloc, ViolationsState>(
      buildWhen: (previous, current) =>
          previous.selectedObjectionLastApplyDate !=
          current.selectedObjectionLastApplyDate,
      builder: (context, state) {
        return FilterDatePicker(
          title: "transaction_details_last_date".tr(),
          initialDate: state.selectedObjectionLastApplyDate,
          initialDateForm: state.lastDateForm ?? DateForm.gregorian,
          onChange: (selectedDate, dateForm) {
            BlocProvider.of<ViolationsBloc>(context).add(
              ObjectionLastApplyDateSelectedEvent(
                  date: selectedDate, formDate: dateForm),
            );
          },
        );
      },
    );
  }
}
