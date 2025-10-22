import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/balady_uikit/components/text_input/input_styles.dart';
import 'package:mapness/balady_uikit/components/text_input/models/src/affix.dart';

class BaladyInputAffix extends StatelessWidget {
  final BaladyInputAffixBase config;
  final BaladyInputStyle inputStyle;
  final BaladyInputAffixType type;

  const BaladyInputAffix({
    required this.config,
    required this.inputStyle,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) => switch (config) {
        BaladyInputAffixWidget() => _BaladyInputAffixWidget(
            config: config as BaladyInputAffixWidget,
            inputStyle: inputStyle,
            type: type,
          ),
        BaladyInputAffixIcon() => _BaladyInputAffixIcon(
            config: config as BaladyInputAffixIcon,
            inputStyle: inputStyle,
            type: type,
          ),
      };
}

class _BaladyInputAffixWidget extends StatelessWidget {
  final BaladyInputAffixWidget config;
  final BaladyInputStyle inputStyle;
  final BaladyInputAffixType type;

  const _BaladyInputAffixWidget({
    required this.config,
    required this.inputStyle,
    required this.type,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: config.padding(inputStyle, type),
        child: config.widget,
      );
}

class _BaladyInputAffixIcon extends StatelessWidget {
  final BaladyInputAffixIcon config;
  final BaladyInputStyle inputStyle;
  final BaladyInputAffixType type;

  const _BaladyInputAffixIcon({
    required this.config,
    required this.inputStyle,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (!config.isVisible) {
      return const SizedBox.shrink();
    }

    final icon = Padding(
      padding: config.padding(inputStyle, type),
      child: Icon(
        config.icon,
        color: config.iconColor ?? context.colors.foregroundSoft,
        size: config.iconSize,
      ),
    );
    if (config.onPressed != null) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 0,
        onPressed: config.onPressed,
        child: icon,
      );
    }
    return icon;
  }
}
