import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingSingleRatioOption extends StatelessWidget {
  const RatingSingleRatioOption(
      {super.key,
      required this.title,
      required this.titleStyle,
      this.height,
      this.value,
      this.selectdValue,
      required this.onChanged});
  final String title;
  final TextStyle titleStyle;
  final double? height;
  final int? value;
  final int? selectdValue;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(
            230,
            239,
            239,
            0.40,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        height: height,
        child: Row(
          children: [
            Radio<int>(
              value: value ?? 0,
              groupValue: selectdValue,
              onChanged: (val) {
                onChanged(val);
              },
              activeColor: selectdValue == value ? Color(0xff447F91) : null,
            ),
            Flexible(
              child: CustomTextWidget(
                title,
                textStyle: titleStyle,
                maxLines: 1,
                fontSize: 12,
                fontWeight: AppFontWeight.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
