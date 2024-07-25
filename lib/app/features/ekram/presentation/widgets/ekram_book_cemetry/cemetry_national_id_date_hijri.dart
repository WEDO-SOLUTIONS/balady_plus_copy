import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'hijri_date_widget.dart';

class CemetryNationalDobHijri extends StatelessWidget {
  const CemetryNationalDobHijri({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
        builder: (context, state) {
      return HijriCalendarDateWidget(
        isDisabled: state.isdeceasedInfoReadOnly,
        currentVlaue: state.deceassedDOBHijri,
        fieldName: "${Helpers.translatingWord("cemetry_dob_hijri")} *",
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramBookCemetryBloc>()
              .add(ChangeNationalIdDob(hijriDate: date));
        },
        maxValue: HijriCalendar.fromDate(DateTime.now()),
      );
    });
  }
}
