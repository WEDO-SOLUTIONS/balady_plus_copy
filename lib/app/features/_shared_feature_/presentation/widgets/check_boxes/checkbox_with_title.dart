import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart';

class CheckboxCubit extends Cubit<bool> {
  CheckboxCubit({required bool initialValue}) : super(initialValue);

  void onChanged() => emit(!state);
}

class CheckBoxWithTitle extends StatelessWidget {
  const CheckBoxWithTitle(
      {Key? key,
      required this.title,
      this.maxlines,
      this.height,
      this.subTitle,
      required this.onChanged,
      this.forceSelection,
      this.initialValue,
      this.textStyle,
      this.fontSize
      })
      : super(key: key);

  final String title;
  final int? maxlines;
  final double? height;
  final String? subTitle;
  final Function(bool? value) onChanged;
  final bool? initialValue;
  final TextStyle? textStyle;
  final double? fontSize;
  final bool? forceSelection;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckboxCubit>(
      create: (context) => CheckboxCubit(initialValue: initialValue ?? false),
      child: Builder(builder: (context) {
        return BlocBuilder<CheckboxCubit, bool>(
          builder: (context, state) {
            return Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Material(
                    child: Checkbox(
                        side: const BorderSide(
                            color: AppColor.blackModern500Light, width: 2),
                        value: forceSelection ?? state,
                        activeColor: AppColor.primary700Light,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        onChanged: (value) {
                          context.read<CheckboxCubit>().onChanged();
                          onChanged(value);
                        }),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                    child: CustomTextWidget(
                  title,
                  maxLines: maxlines,
                  height: height,
                  fontSize: fontSize ?? 12,
                  fontWeight: AppFontWeight.semiBold,
                  fontColor: AppColor.blackModern500Light,
                )),
              ],
            );
          },
        );
      }),
    );
  }
}
