import 'package:flutter/services.dart';

import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class CalculatorCustomTextField extends StatelessWidget {
  final String title;
  final String? suffix;
  final Function onChanged;
  final bool isEnabled;
  final String? value;
  final Color? color;

  const CalculatorCustomTextField({
    required this.onChanged,
    required this.title,
    this.suffix,
    this.isEnabled = true,
    this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyle.captionRomanStyle,
        ),
        SizedBox(height: 8),
        // The TextField with custom design
        TextFormField(
          initialValue: value,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (String y) {
            onChanged(y);
          },
          decoration: InputDecoration(
            suffixText: suffix,
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            filled: true,
            enabled: isEnabled,
            fillColor:
                color ?? Colors.white, // Background color of the text field
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
              borderSide: BorderSide(
                color: Colors.teal, // Border color
                width: 1.5, // Border width
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.teal,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
