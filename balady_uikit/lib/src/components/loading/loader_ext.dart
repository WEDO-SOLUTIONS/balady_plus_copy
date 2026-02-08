import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/components/loading/loading.dart';
import 'package:flutter/widgets.dart';

extension LoaderStyleExt on LoaderStyle {
  Color foregroundColor(BuildContext context) => switch (this) {
        LoaderStyle.accent => context.colors.accentDefault,
        LoaderStyle.neutral => context.colors.neutralDefault,
        LoaderStyle.error => context.colors.errorDefault,
        LoaderStyle.accentSecondary => context.colors.accentSecondaryDefault,
        LoaderStyle.white => context.colors.staticWhite,
      };
}

extension LoaderSizeExt on LoaderSize {
  double get size => switch (this) {
        LoaderSize.small => 24.0,
        LoaderSize.medium => 36.0,
        LoaderSize.large => 48.0,
      };

  double get strokeWidth => size / 10;
}
