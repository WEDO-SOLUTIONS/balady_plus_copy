import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleRatioOption extends StatelessWidget {
  const SingleRatioOption(
      {super.key,
      required this.title,
      required this.titleStyle,
      this.width,
      this.height,
      this.value,
      this.selected,
      this.flex = true,
      required this.onChanged});
  final String title;
  final TextStyle titleStyle;
  final double? height;
  final double? width;
  final int? value;
  final int? selected;
  final Function onChanged;
  final bool flex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
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
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        height: height,
        width: width,
        child: Row(
          children: [
            Radio<int>(
              value: value ?? 0,
              groupValue: selected,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              onChanged: (val) => onChanged(val),
              activeColor: selected == value ? Color(0xff447F91) : null,
            ),
            // if (flex)
            Flexible(
              child: CustomTextWidget(
                title,
                textStyle: titleStyle,
                maxLines: 10,
                fontSize: 15,
              ),
            ),
            /* if (!flex)
              CustomTextWidget(
                title,
                textStyle: titleStyle,
                maxLines: 1,
              ),*/
          ],
        ),
      ),
    );
  }
}
