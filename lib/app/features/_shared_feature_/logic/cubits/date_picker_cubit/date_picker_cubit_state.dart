part of 'date_picker_cubit_cubit.dart';

class DatePickerState extends Equatable {
  final DateTime? _initialDate;
  const DatePickerState({required DateTime? initialDate}) : _initialDate = initialDate;

  DateString get selectedDateString =>
      _initialDate != null ? "${_initialDate!.year}/${_initialDate!.month}/${_initialDate!.day}" : "yyyy/mm/dd";
  DateTime get selectedDate {
    final date = _initialDate ?? DateTime.now();
    // to check if current-date equals for Friday or Saturday to disable them
    return date.weekday == 5
        ? date.add(const Duration(days: 2))
        : date.weekday == 6
            ? date.add(const Duration(days: 1))
            : date;
  }

  @override
  List<Object?> get props => [_initialDate];
}
