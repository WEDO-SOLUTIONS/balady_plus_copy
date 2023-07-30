import 'package:formz/formz.dart' show FormzInput;

import '../../../../../../core/utils/utils_exports.dart' show Validation;

class DateAfterValidation extends FormzInput<String?, Validation> {
  final String? startDate;
  const DateAfterValidation.pure({this.startDate}) : super.pure(startDate);
  const DateAfterValidation.dirty({
    required this.startDate,
    String? endDate,
  }) : super.dirty(endDate);

  @override
  Validation? validator(String? value) {
    final enteredValue = value ?? '';
    if (enteredValue.isEmpty) {
      return Validation.empty;
    } else {
      final defaultDateStr = DateTime(1111).toIso8601String();
      final firstDate = DateTime.parse(startDate ?? defaultDateStr);
      final lastDate = DateTime.tryParse(enteredValue) ?? DateTime(1111);
      if (lastDate.difference(firstDate).inDays < 0) {
        return Validation.invalidEndDate;
      } else {
        return null;
      }
    }
  }
}
