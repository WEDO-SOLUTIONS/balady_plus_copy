enum BaladyInputState {
  /// Default state to show the input field with default colors.
  defaultValue,

  /// Error state to show the input field with error colors.
  error,

  /// If true, the input field will be read-only and the user will not be able to change it.
  /// But the user can still select the text and copy it.
  /// It will be shown as the default input field.
  readOnly,

  /// If true, the input field will be enabled and the user will be able to change it.
  /// By default, it is true.
  /// If it is false, the input field will be displayed as disabled with specific colors.
  disabled;

  bool get isError => this == error;
  bool get isReadOnly => this == readOnly;
  bool get isDisabled => this == disabled;
}
