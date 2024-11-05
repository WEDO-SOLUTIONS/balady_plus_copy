import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_request_transportation_bloc/ekram_request_transportation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../ekram_book_cemetry/gorgian_date_widget.dart';

class BurialDateGorgian extends StatelessWidget {
  const BurialDateGorgian({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc, EkramRequestTransportationState>(
        builder: (context, state) {
      DateTime today = DateTime.now();
      DateTime tomrrow = DateTime.now().add(Duration(days: 1));

      return GorgianCalendarDateWidget(
        minValue: today,
        maxValue: tomrrow,
        currentVlaue: state.burialDateGregorian,
        isDisabled: state.isBurialDatesDisabled,
        fieldName:
            Helpers.translatingWord("cemetry_deceassed_burial_date_gorgian"),
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramRequestTransportationBloc>()
              .add(ChangeBurialDateEvent(gorgianDate: date));
        },
      );
    });
  }
}
