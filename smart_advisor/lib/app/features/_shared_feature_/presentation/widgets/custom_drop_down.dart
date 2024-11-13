import 'package:flutter_svg/svg.dart';

import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String title;
  final List<LookUpItem> list;
  final LookUpItem? selectedItem;
  final Function onSelect;

  const CustomDropdown(
      {required this.title,
      required this.list,
      required this.onSelect,
      this.selectedItem});
  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  // List of CustomOption objects

  // Variable to hold the selected option
  LookUpItem? selectedOption;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedOption = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppStyle.textRegularStyle
              .copyWith(color: const Color(0xff1A1A1A)),
        ),
        const SizedBox(height: 12),
        // Custom-designed dropdown
        Container(
          height: 56,
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, right: 13, left: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<LookUpItem>(
              hint: Text(
                widget.title,
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
              value: selectedOption,
              isExpanded: true,
              icon: SvgPicture.asset(
                  'packages/smart_advisor/smart_advisor_assets/icons/svg/arrowdaown.svg'),
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
                          style: AppStyle.textRegularRomanStyle
                              .copyWith(color: AppColor.textSecondaryColor),
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
