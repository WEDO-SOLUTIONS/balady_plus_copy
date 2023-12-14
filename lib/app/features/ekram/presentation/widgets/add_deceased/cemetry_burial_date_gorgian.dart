import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import '../ekram_book_cemetry/gorgian_date_widget.dart';

class CemetryBurialDateGorgian extends StatelessWidget {
  const CemetryBurialDateGorgian({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramAddDeceasedBloc, EkramAddDeceasedState>(
        builder: (context, state) {
      DateTime today = DateTime.now();
      DateTime tomrrow = DateTime.now().add(Duration(days: 1));

      return GorgianCalendarDateWidget(
        minValue: today,
        maxValue: tomrrow,
        currentVlaue: state.data?.burialDateGorgian,
        isDisabled: state.isBurialDatesDisabled(),
        fieldName:
            Helpers.translatingWord("cemetry_deceassed_burial_date_gorgian"),
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramAddDeceasedBloc>()
              .add(ChangeBurialDateEvent(gorgianDate: date));
        },
      );
    });
  }
}
