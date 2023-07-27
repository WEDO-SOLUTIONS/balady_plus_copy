import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show DateForm;
import '../../shared_feature_exports.dart' show DateFormCell;

class DateFromSelector extends StatefulWidget {
  final DateForm? initialDateForm;
  final Function(DateForm) onChange;

  const DateFromSelector({
    super.key,
    this.initialDateForm,
    required this.onChange,
  });

  @override
  State<DateFromSelector> createState() => _DateFromSelectorState();
}

class _DateFromSelectorState extends State<DateFromSelector> {
  late DateForm _dateForm;

  @override
  void initState() {
    super.initState();
    _dateForm = widget.initialDateForm ?? DateForm.gregorian;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          DateFormCell(
            value: DateForm.gregorian,
            groupValue: _dateForm,
            onChanged: onChanged,
          ),
          const SizedBox(width: 16),
          DateFormCell(
            value: DateForm.hijri,
            groupValue: _dateForm,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void onChanged(DateForm? value) {
    if (value == null) return;
    widget.onChange(value);
    setState(() {
      _dateForm = value;
    });
  }
}
