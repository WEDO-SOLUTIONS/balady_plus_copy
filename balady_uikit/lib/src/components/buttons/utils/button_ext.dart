part of '../app_button.dart';

extension BaladyButtonSizeExt on ButtonSize {
  double get height => switch (this) {
        ButtonSize.small => AppSizes.s,
        ButtonSize.medium => AppSizes.m,
        ButtonSize.large => AppSizes.l,
      };

  double get radius => switch (this) {
        ButtonSize.small => RadiusBorder.m,
        ButtonSize.medium => RadiusBorder.l,
        ButtonSize.large => 10.0,
      };

  TextStyle fontStyle(BuildContext context) => switch (this) {
        ButtonSize.small => context.textStyles.buttonM,
        ButtonSize.medium => context.textStyles.buttonM,
        ButtonSize.large => context.textStyles.buttonL,
      };
}

extension BaladyButtonColorSchemeExt on ButtonColorScheme {
  WidgetButtonStateColors colors({
    required ButtonType type,
    required BuildContext context,
  }) =>
      switch (this) {
        ButtonColorScheme.accent => _accent(type: type, context: context),
        ButtonColorScheme.neutral => _neutral(type: type, context: context),
        ButtonColorScheme.accentSecondary => _accentSecondary(type: type, context: context),
        ButtonColorScheme.error => _error(type: type, context: context),
        ButtonColorScheme.primary => _accent(type: type, context: context),
        ButtonColorScheme.secondary => _accentSecondary(type: type, context: context),
        ButtonColorScheme.tertiary => _neutral(type: type, context: context),
        ButtonColorScheme.warning => _error(type: type, context: context),
        ButtonColorScheme.onColor => _accentSecondary(type: type, context: context),
      };

  WidgetButtonStateColors _accent({
    required ButtonType type,
    required BuildContext context,
  }) =>
      switch (type) {
        ButtonType.primary => WidgetButtonStateColors(
            defaultValue: WidgetColors(
              foreground: context.colors.accentOnAccent,
              background: context.colors.accentDefault,
            ),
            pressed: WidgetColors(
              foreground: context.colors.accentOnAccent,
              background: context.colors.accentActive,
            ),
            loading: WidgetColors(
              foreground: context.colors.accentOnAccent,
              background: context.colors.accentDefault,
            ),
            disabled: WidgetColors(
              foreground: context.colors.foregroundDisabled,
              background: context.colors.foregroundDisabled.withAlpha(25),
            )),
        ButtonType.secondary => WidgetButtonStateColors(
            defaultValue: WidgetColors(
              foreground: context.colors.accentOnContainer,
              background: context.colors.accentContainerDefault,
            ),
            pressed: WidgetColors(
              foreground: context.colors.accentOnContainer,
              background: context.colors.accentContainerActive,
            ),
            loading: WidgetColors(
              foreground: context.colors.accentDefault,
              background: context.colors.accentContainerDefault,
            ),
            disabled: WidgetColors(
              foreground: context.colors.foregroundDisabled,
              background: context.colors.foregroundDisabled.withAlpha(25),
            ),
          )
      };

  WidgetButtonStateColors _neutral({
    required ButtonType type,
    required BuildContext context,
  }) =>
      switch (type) {
        ButtonType.primary => WidgetButtonStateColors(
            defaultValue: WidgetColors(
              foreground: context.colors.neutralOnNeutral,
              background: context.colors.neutralDefault,
            ),
            pressed: WidgetColors(
              foreground: context.colors.neutralOnNeutral,
              background: context.colors.neutralActive,
            ),
            loading: WidgetColors(
              foreground: context.colors.staticWhite,
              background: context.colors.neutralDefault,
            ),
            disabled: WidgetColors(
              foreground: context.colors.foregroundDisabled,
              background: context.colors.foregroundDisabled.withAlpha(25),
            )),
        ButtonType.secondary => WidgetButtonStateColors(
            defaultValue: WidgetColors(
              foreground: context.colors.neutralOnContainer,
              background: context.colors.neutralContainerDefault,
            ),
            pressed: WidgetColors(
              foreground: context.colors.neutralOnContainer,
              background: context.colors.neutralContainerActive,
            ),
            loading: WidgetColors(
              foreground: context.colors.neutralDefault,
              background: context.colors.neutralContainerDefault,
            ),
            disabled: WidgetColors(
              foreground: context.colors.foregroundDisabled,
              background: context.colors.foregroundDisabled.withAlpha(25),
            ),
          )
      };

  WidgetButtonStateColors _accentSecondary({
    required ButtonType type,
    required BuildContext context,
  }) =>
      switch (type) {
        ButtonType.primary => WidgetButtonStateColors(
            defaultValue: WidgetColors(
              foreground: context.colors.accentSecondaryOnAccentSecondary,
              background: context.colors.accentSecondaryDefault,
            ),
            pressed: WidgetColors(
              foreground: context.colors.accentSecondaryOnAccentSecondary,
              background: context.colors.accentSecondaryActive,
            ),
            loading: WidgetColors(
              foreground: context.colors.staticWhite,
              background: context.colors.accentSecondaryDefault,
            ),
            disabled: WidgetColors(
              foreground: context.colors.foregroundDisabled,
              background: context.colors.foregroundDisabled.withAlpha(25),
            )),
        ButtonType.secondary => WidgetButtonStateColors(
            defaultValue: WidgetColors(
              foreground: context.colors.accentSecondaryOnContainer,
              background: context.colors.accentSecondaryContainerDefault,
            ),
            pressed: WidgetColors(
              foreground: context.colors.accentSecondaryOnContainer,
              background: context.colors.accentSecondaryContainerActive,
            ),
            loading: WidgetColors(
              foreground: context.colors.accentSecondaryDefault,
              background: context.colors.accentSecondaryContainerDefault,
            ),
            disabled: WidgetColors(
              foreground: context.colors.foregroundDisabled,
              background: context.colors.foregroundDisabled.withAlpha(25),
            ),
          )
      };

  WidgetButtonStateColors _error({
    required ButtonType type,
    required BuildContext context,
  }) =>
      switch (type) {
        ButtonType.primary => WidgetButtonStateColors(
            defaultValue: WidgetColors(
              foreground: context.colors.errorOnError,
              background: context.colors.errorDefault,
            ),
            pressed: WidgetColors(
              foreground: context.colors.errorOnError,
              background: context.colors.errorActive,
            ),
            loading: WidgetColors(
              foreground: context.colors.staticWhite,
              background: context.colors.errorDefault,
            ),
            disabled: WidgetColors(
              foreground: context.colors.foregroundDisabled,
              background: context.colors.foregroundDisabled.withAlpha(25),
            )),
        ButtonType.secondary => WidgetButtonStateColors(
            defaultValue: WidgetColors(
              foreground: context.colors.errorOnContainer,
              background: context.colors.errorContainerDefault,
            ),
            pressed: WidgetColors(
              foreground: context.colors.errorOnContainer,
              background: context.colors.errorContainerActive,
            ),
            loading: WidgetColors(
              foreground: context.colors.errorDefault,
              background: context.colors.errorContainerDefault,
            ),
            disabled: WidgetColors(
              foreground: context.colors.foregroundDisabled,
              background: context.colors.foregroundDisabled.withAlpha(25),
            ),
          )
      };
}
