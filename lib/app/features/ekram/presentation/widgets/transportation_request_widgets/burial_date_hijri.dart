import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_request_transportation_bloc/ekram_request_transportation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../../core/services/local/helpers.dart';
import '../ekram_book_cemetry/hijri_date_widget.dart';

class BurialDateHijri extends StatelessWidget {
  const BurialDateHijri({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime tomrrow = DateTime.now().add(Duration(days: 1));

    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(builder: (context, state) {
      return HijriCalendarDateWidget(
        minValue: HijriCalendar.fromDate(today),
        maxValue: HijriCalendar.fromDate(tomrrow),
        currentVlaue: state.burialDateHijri,
        isDisabled: state.isBurialDatesDisabled,
        fieldName:
            Helpers.translatingWord("cemetry_deceassed_burial_date_hijri"),
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramRequestTransportationBloc>()
              .add(ChangeBurialDateEvent(hijriDate: date));
        },
      );
    });
  }
}
