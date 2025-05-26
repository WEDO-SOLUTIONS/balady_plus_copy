import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_request_transportation_bloc/ekram_request_transportation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import '../ekram_book_cemetry/gorgian_date_widget.dart';

class DeathDateGregorian extends StatelessWidget {
  final Function(String?) onChanged;
  String? currentDate;
  bool ?isDeathDatesDisabled;
  DeathDateGregorian({super.key,required this.onChanged,this.currentDate,this.isDeathDatesDisabled});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime tomrrow = DateTime.now().add(Duration(days: 1));
    return GorgianCalendarDateWidget(
      minValue: today,
      maxValue: tomrrow,
      currentVlaue: currentDate,
      isDisabled: isDeathDatesDisabled??false,
      fieldName: Helpers.translatingWord("death_date_gorgian"),
      isMandatory: true,
      onChanged: onChanged,
    );
  }
}
