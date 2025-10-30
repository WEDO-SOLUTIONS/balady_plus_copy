import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/date_form.dart';
import '../../../bloc/compliance_bloc.dart';
import '../../../bloc/compliance_event.dart';
import '../../../bloc/compliance_state.dart';
import '../../compliance_date_picker.dart';

class InvestmentNumberDateField extends StatelessWidget {
  const InvestmentNumberDateField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
        builder: (context, state) {
      return FutureBuilder(
          initialData: state.getOwnerShipDateTime(),
          future: state.ownershipDate != null ? state.getOwnerShipDate() : null,
          builder: (context, data) {
            return ComplianceDatePicker(
              title: "compliance_investment_number_date".tr(),
              initialDateForm: state.form ?? DateForm.hijri,
              initialDate: data.data,
              endDate: DateTime.now(),
              onChange: (DateTime time, DateForm form) async {
                String date = await time.toHijriFormattedDate1();

                context
                    .read<ComplianceBloc>()
                    .add(UpdateFieldsEvent(form: form, ownershipDate: date));
              },
            );
          });
    });
  }
}
