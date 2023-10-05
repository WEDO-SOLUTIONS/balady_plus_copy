import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/date_form.dart';
import '../../../bloc/compliance_bloc.dart';
import '../../../bloc/compliance_event.dart';
import '../../../bloc/compliance_state.dart';
import '../../compliance_date_picker.dart';

class EstehkamNumberDateField extends StatelessWidget {
  const EstehkamNumberDateField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
        builder: (context, state) {
      return ComplianceDatePicker(
        title: "compliance_ownership_date".tr(),
        initialDateForm: state.form ?? DateForm.hijri,
        initialDate:
            state.ownershipDate != null ? state.getOwnerShipDate() : null,
        endDate: DateTime.now(),
        onChange: (DateTime time, DateForm form) {
          context.read<ComplianceBloc>().add(UpdateFieldsEvent(
              form: form, ownershipDate: time.toHijriFormattedDate1()));
        },
      );
    });
  }
}
