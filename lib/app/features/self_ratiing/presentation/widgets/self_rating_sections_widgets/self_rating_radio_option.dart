import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_bloc.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_event.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingSingleRatioOption extends StatelessWidget {
  const RatingSingleRatioOption({
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
    return BlocBuilder<SelfRatingBloc, SelfRatingState>(
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
                      .read<SelfRatingBloc>()
                      .add(SelfRatingRadioSelectEvent(val ?? 0));
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
