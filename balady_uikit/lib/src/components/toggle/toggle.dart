import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';

/// Use [Toggle] class if you want to indicate which element is currently active or inactive
///
/// See also:
/// * [Figma Design] (https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2036-13543&mode=design&t=SDHK3kmgGjetLldc-4), design specs

class Toggle extends StatelessWidget {
  final Color? activeColor;
  // ignore: avoid_positional_boolean_parameters
  final Function(bool)? onChanged;
  final bool value;

  const Toggle({
    required this.value,
    super.key,
    this.activeColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 52,
        height: 32,
        child: CupertinoSwitch(
          activeColor: context.colors.accentDefault,
          trackColor: context.colors.borderSoft,
          thumbColor: context.colors.staticWhite,
          onChanged: onChanged,
          value: value,
        ),
      );
}
