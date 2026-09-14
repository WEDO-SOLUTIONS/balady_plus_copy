import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../texts/custom_text_widget.dart';

class CustomCheckbox extends StatefulWidget {
  final String title;
  final bool isSelected;
  final Function onSelect;

  const CustomCheckbox({super.key, required this.title, required this.onSelect, required this.isSelected});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomVerticalSpace(height: 24),
        Container(
          margin: const EdgeInsets.only(bottom: 18, right: 12, left: 12),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                selected = !selected;

                widget.onSelect(selected);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CustomTextWidget(
                    widget.title,
                    fontSize: 14,
                    fontWeight: AppFontWeight.medium,
                    fontColor: AppColor.black,
                    maxLines: 4,
                    textAlign: TextAlign.start,
                  ),
                ), //Text//SizedBox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    image: selected
                        ? DecorationImage(
                            image: AssetImage("${Constants.imgPath}checkbox@3x.png"),
                            fit: BoxFit.fill, //MM
                          )
                        : null,
                    border: selected ? null : Border.all(color: Color(0xffd1d1d1), width: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        VerticalDivider(color: AppColor.gray),
      ],
    );
  }
}
