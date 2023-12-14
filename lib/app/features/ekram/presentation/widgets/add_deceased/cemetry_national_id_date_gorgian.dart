import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import '../ekram_book_cemetry/gorgian_date_widget.dart';

class CemetryNationalDobGorgian extends StatelessWidget {
  const CemetryNationalDobGorgian({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramAddDeceasedBloc, EkramAddDeceasedState>(
        builder: (context, state) {
      return GorgianCalendarDateWidget(
        currentVlaue: state.data?.deceassedDOBGorgian,
        fieldName: Helpers.translatingWord("cemetry_dob_gorgian"),
        isDisabled: state.isFormDisabled(),
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramAddDeceasedBloc>()
              .add(ChangeNationalIdDob(gorgianDate: date));
        },
      );
    });
  }
}
