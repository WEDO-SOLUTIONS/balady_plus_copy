import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_request_transportation_bloc/ekram_request_transportation_bloc.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/hijri_date_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

class DeceasedBirthdateHijri extends StatelessWidget {
  final bool isDisabled;
   DeceasedBirthdateHijri({super.key,required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(builder: (context, state) {
      return HijriCalendarDateWidget(
        isDisabled: isDisabled,
        currentVlaue: state.deceassedDOBHijri,
        fieldName: Helpers.translatingWord("cemetry_dob_hijri"),
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramRequestTransportationBloc>()
              .add(ChangeNationalIdDob(hijriDate: date));
        },
        maxValue: HijriCalendar.fromDate(DateTime.now()),
      );
    });
  }
}
