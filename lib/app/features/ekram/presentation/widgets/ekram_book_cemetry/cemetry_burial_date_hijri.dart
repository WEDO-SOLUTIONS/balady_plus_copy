import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'hijri_date_widget.dart';

class CemetryBurialDateHijri extends StatelessWidget {
  const CemetryBurialDateHijri({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime tomrrow = DateTime.now().add(const Duration(days: 1));
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
        builder: (context, state) {
      return HijriCalendarDateWidget(
        minValue: HijriCalendar.fromDate(today),
        maxValue: HijriCalendar.fromDate(tomrrow),
        currentVlaue: state.burialDateHijri,
        fieldName:
            "${Helpers.translatingWord("cemetry_deceassed_burial_date_hijri")} *",
        isMandatory: true,
        onChanged: (String? date) {
          print(date);
          context.read<EkramBookCemetryBloc>().add(ChangeBurialDateEvent(
              hijriDate:
                  CommonFunctions.replaceArabicNumberWithEnglish(date ?? "")));
        },
      );
    });
  }
}
