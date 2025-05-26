import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_request_transportation_bloc/ekram_request_transportation_bloc.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/gorgian_date_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeceasedBirthdateGregorian extends StatelessWidget {
  final bool isDisabled;
   DeceasedBirthdateGregorian({super.key,required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(builder: (context, state) {
      return GorgianCalendarDateWidget(
        isDisabled: isDisabled,
        currentVlaue: state.deceassedDOBGorgian,
        fieldName: Helpers.translatingWord("cemetry_dob_gorgian"),
        isMandatory: true,
        onChanged: (String? date) {
          context
              .read<EkramRequestTransportationBloc>()
              .add(ChangeNationalIdDob(gorgianDate: date));
        },
        maxValue: DateTime.now(),
      );
    });
  }
}
