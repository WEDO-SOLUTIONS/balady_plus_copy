/// Button sizes. Defines the height, radius, and font style of the button.

@Deprecated('Use ButtonSize')
typedef BaladyButtonSize = ButtonSize;

enum ButtonSize {
  small,
  medium,
  large,
}

@Deprecated('Use ButtonColorScheme')
typedef BaladyButtonColorScheme = ButtonColorScheme;

/// Button color schemes. Could be used to define the button's color scheme.
/// We can add more color schemes if needed. The main idea is to use the same color scheme values (e.g. default or soft)
/// across the app to keep the consistency.
enum ButtonColorScheme {
  accent,
  neutral,
  accentSecondary,
  error,

  @Deprecated('Use ButtonColorScheme.accent')
  primary,
  @Deprecated('Use ButtonColorScheme.accentSecondary')
  secondary,

  @Deprecated('Use ButtonColorScheme.neutral')
  tertiary,

  @Deprecated('Use ButtonColorScheme.error')
  warning,

  @Deprecated('Use ButtonColorScheme.accentSecondary')
  onColor,
}

@Deprecated('Use ButtonType')
typedef BaladyButtonType = ButtonType;

/// Button types. Could be used to define the button's type and style.
enum ButtonType {
  primary,
  secondary,
}

typedef BaladyButtonStates = ButtonState;

enum ButtonState {
  defaultState,
  loading,
  disabled,
  pressed,

  @Deprecated('Use ButtonState.defaultState')
  normal,
}
