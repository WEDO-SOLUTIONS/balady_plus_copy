import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocConsumer, BlocProvider, ReadContext;

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, WidgetConversion;
import '../../shared_feature_exports.dart'
    show CheckBoxCubit, CustomTextWidget, ErrorUnderWidget;

class CustomEnhancedCheckBoxWidget extends StatelessWidget {
  final TextDirection? directionality;
  final bool selected;

  /// Space between radio and label
  final double checkBoxLabelSpace;

  final String label;
  final TextStyle? labelStyle;

  final double radius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? checkColor;

  final String? errorMsg;

  final void Function(bool) onChanged;
  const CustomEnhancedCheckBoxWidget({
    super.key,
    this.directionality,
    required this.selected,
    //
    required this.label,
    this.labelStyle,
    //
    this.checkBoxLabelSpace = 10.0,
    //
    this.radius = 4.0,
    this.borderColor,
    this.fillColor,
    this.checkColor,
    //
    this.errorMsg,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckBoxCubit>(
      create: (_) => CheckBoxCubit(initialState: selected),
      child: Directionality(
        // In case of you need to set CheckBox on Left and Text on Right
        // change directionality of Row,
        // otherwise leave it as it is base app language
        textDirection: directionality ?? Directionality.of(context),
        child: Column(
          children: [
            // CheckBox
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Check-Box
                Builder(
                  builder: (context) {
                    return BlocConsumer<CheckBoxCubit, bool>(
                      listener: (_, checkBoxState) => onChanged(checkBoxState),
                      builder: (_, state) {
                        return _CheckWidget(
                          selected: state,
                          radius: radius,
                          checkColor: checkColor,
                          fillColor: fillColor,
                          borderColor: borderColor,
                          onChanged:
                              context.read<CheckBoxCubit>().onChangeState,
                        );
                      },
                    );
                  },
                ),
                // Label
                Expanded(
                  child: CustomTextWidget(
                    label,
                    textStyle: labelStyle ?? AppStyle.checkBoxStyle,
                  ),
                ),
              ].addPadding(end: checkBoxLabelSpace),
            ),
            // Error
            ErrorUnderWidget(errorText: errorMsg),
          ],
        ),
      ),
    );
  }
}

class _CheckWidget extends StatelessWidget {
  final bool selected;
  final double radius;
  final Color? checkColor;
  final Color? fillColor;
  final Color? borderColor;
  final void Function(bool) onChanged;
  const _CheckWidget({
    required this.selected,
    required this.radius,
    required this.checkColor,
    required this.fillColor,
    required this.borderColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      splashColor: AppColor.blue,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      onTap: () => onChanged(selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 20.0,
        height: 20.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _fillColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: _borderColor),
        ),
        child:
            selected ? Icon(Icons.check, size: 18.0, color: _checkColor) : null,
      ),
    );
  }

  Color get _fillColor =>
      selected ? fillColor ?? AppColor.blue : AppColor.white;
  Color get _borderColor => AppColor.blue;
  Color get _checkColor => checkColor ?? AppColor.white;
}
