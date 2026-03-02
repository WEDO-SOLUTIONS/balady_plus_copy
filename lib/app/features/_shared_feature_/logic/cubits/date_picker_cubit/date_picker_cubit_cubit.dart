import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart' show DateString;

part 'date_picker_cubit_state.dart';

class DatePickerCubit extends Cubit<DatePickerState> {
  final DateTime? initialDate;
  DatePickerCubit({required this.initialDate}) : super(DatePickerState(initialDate: initialDate));

  void onUpdatedDate(DateTime selectedDate) => emit(DatePickerState(initialDate: selectedDate));
}
