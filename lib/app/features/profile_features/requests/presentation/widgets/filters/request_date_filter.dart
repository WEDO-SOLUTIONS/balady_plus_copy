import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/date_form.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show FilterDatePicker;
import '../../../requests_exports.dart'
    show RequestDateSelectedEvent, RequestsBloc, RequestsState;

class RequestsDateFilter extends StatelessWidget {
  const RequestsDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      buildWhen: (previous, current) =>
          previous.selectedRequestDate != current.selectedRequestDate,
      builder: (context, state) {
        return FilterDatePicker(
          title: "request_date".tr(),
          initialDate: state.selectedRequestDate,
          initialDateForm: state.dateForm ?? DateForm.gregorian,
          onChange: (selectedDate, dateForm) {
            BlocProvider.of<RequestsBloc>(context).add(
              RequestDateSelectedEvent(date: selectedDate, formDate: dateForm),
            );
          },
        );
      },
    );
  }
}
