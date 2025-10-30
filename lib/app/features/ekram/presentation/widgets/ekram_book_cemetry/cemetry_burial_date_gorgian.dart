import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'gorgian_date_widget.dart';

class CemetryBurialDateGorgian extends StatelessWidget {
  const CemetryBurialDateGorgian({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
        builder: (context, state) {
      DateTime today = DateTime.now();

      DateTime tomrrow = DateTime.now().add(const Duration(days: 1));

      return GorgianCalendarDateWidget(
        minValue: today,
        maxValue: tomrrow,
        currentVlaue: state.burialDateGorgian,
        fieldName:
            "${Helpers.translatingWord("cemetry_deceassed_burial_date_gorgian")} *",
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramBookCemetryBloc>()
              .add(ChangeBurialDateEvent(gorgianDate: date));
        },
      );
    });
  }
}
