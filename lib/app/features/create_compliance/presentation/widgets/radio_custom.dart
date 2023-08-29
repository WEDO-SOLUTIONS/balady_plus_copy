import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleRatioOption extends StatelessWidget {
  const SingleRatioOption({
    super.key,
    required this.title,
    required this.titleStyle,
    this.width,
    this.height,
    this.value,
  });
  final String title;
  final TextStyle titleStyle;
  final double? height;
  final double? width;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Container(
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
          width: width,
          child: Row(
            children: [
              Radio<int>(
                value: value ?? 0,
                groupValue: state.radioSelect,
                onChanged: (val) {
                  context
                      .read<ComplianceBloc>()
                      .add(RadioSelectEvent(val ?? 0));
                },
                activeColor:
                    state.radioSelect == value ? Color(0xff447F91) : null,
              ),
              Flexible(
                child: CustomTextWidget(
                  title,
                  textStyle: titleStyle,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
