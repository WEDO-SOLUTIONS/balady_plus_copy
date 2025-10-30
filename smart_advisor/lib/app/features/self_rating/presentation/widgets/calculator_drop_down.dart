import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:flutter/material.dart';

class CalculatorDropdown extends StatefulWidget {
  final String title;
  final List<LookUpItem> list;
  final Function onSelect;

  const CalculatorDropdown(
      {required this.title, required this.list, required this.onSelect});
  @override
  _CalculatorDropdownState createState() => _CalculatorDropdownState();
}

class _CalculatorDropdownState extends State<CalculatorDropdown> {
  // List of CustomOption objects

  // Variable to hold the selected option
  LookUpItem? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppStyle.captionRomanStyle
              .copyWith(color: const Color(0xff1A1A1A)),
        ),
        SizedBox(height: 4),
        // Custom-designed dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppColor.surfaceSecondaryColor
              // border: Border.all(color: Colors.teal, width: 1),
              ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<LookUpItem>(
              hint: Text(
                widget.title,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              value: selectedOption,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppColor.forGroundMuted),
              iconSize: 30,
              onChanged: (LookUpItem? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
                widget.onSelect(selectedOption);
              },
              items: widget.list.map((LookUpItem option) {
                return DropdownMenuItem<LookUpItem>(
                  value: option,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        //   Icon(Icons.check_circle_outline, color: Colors.teal),
                        //    SizedBox(width: 10),
                        Text(
                          option.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        /* SizedBox(height: 20),
        selectedOption != null
            ? Text(
                '${selectedOption!.name}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            : Text(
                'No option selected',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),*/
      ],
    );
  }
}
