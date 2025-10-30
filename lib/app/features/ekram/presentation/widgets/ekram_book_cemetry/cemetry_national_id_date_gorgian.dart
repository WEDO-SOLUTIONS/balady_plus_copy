import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'gorgian_date_widget.dart';

class CemetryNationalDobGorgian extends StatelessWidget {
  const CemetryNationalDobGorgian({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
        builder: (context, state) {
      return GorgianCalendarDateWidget(
        isDisabled: state.isdeceasedInfoReadOnly,
        currentVlaue: state.deceassedDOBGorgian,
        fieldName: "${Helpers.translatingWord("cemetry_dob_gorgian")} *",
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramBookCemetryBloc>()
              .add(ChangeNationalIdDob(gorgianDate: date));
        },
        maxValue: DateTime.now(),
      );
    });
  }
}
