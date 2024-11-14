import 'package:flutter_svg/svg.dart';

import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:flutter/material.dart';

class CustomDropdownText extends StatefulWidget {
  final String title;
  final List<LookUpItem> list;
  final LookUpItem? selectedItem;

  const CustomDropdownText(
      {required this.title, required this.list, this.selectedItem});
  @override
  _CustomDropdownTextState createState() => _CustomDropdownTextState();
}

class _CustomDropdownTextState extends State<CustomDropdownText> {
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.selectedItem?.name ?? widget.title,
                      style: AppStyle.textRegularRomanStyle),
                  SvgPicture.asset(
                      'packages/smart_advisor/smart_advisor_assets/icons/svg/arrowdaown.svg')
                ])),
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
