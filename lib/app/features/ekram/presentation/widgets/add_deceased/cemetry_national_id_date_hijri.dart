import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import '../ekram_book_cemetry/hijri_date_widget.dart';

class CemetryNationalDobHijri extends StatelessWidget {
  const CemetryNationalDobHijri({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramAddDeceasedBloc, EkramAddDeceasedState>(
        builder: (context, state) {
      return HijriCalendarDateWidget(
        currentVlaue: state.data?.deceassedDOBHijri,
        isDisabled: state.isFormDisabled(),
        fieldName: Helpers.translatingWord("cemetry_dob_hijri"),
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramAddDeceasedBloc>()
              .add(ChangeNationalIdDob(hijriDate: date));
        },
      );
    });
  }
}
