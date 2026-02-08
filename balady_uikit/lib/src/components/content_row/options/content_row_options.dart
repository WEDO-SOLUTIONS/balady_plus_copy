part of '../content_row.dart';

/// The [ContentRowOptions] class is a data class that holds the options for the [ContentRow] widget.
///
/// The options include the following:
/// - [dividerEnabled]: A boolean that determines whether a divider should be displayed. Default value: false
/// - [wrapperEnabled]: A boolean that determines whether a wrapper should be displayed. Default value: true
/// - [leadingIcon]: A [Widget] that represents the leading icon. Default value: none
/// - [customActionWidget]: A [Widget] that represents a custom action. Default value: none
/// - [title]: A string that represents the title. Default value: none
/// - [subtitle]: A string that represents the subtitle. Default value: none
/// - [subtitleExtra]: A string that represents the extra subtitle. Default value: none
/// - [titleStyle]: A text style for the title. Default value: TextStyle -> Text
/// - [subtitleStyle]: A text style for the subtitle. Default value: TextStyle -> FootNote
/// - [subtitleExtraStyle]: A text style for the extra subtitle. Default value: TextStyle -> FootNoteBold
/// - [titleMaxlines]: An [int] that represents the maximum number of lines for the title. Default value: 1
/// - [subtitleMaxlines]: An [int] that represents the maximum number of lines for the subtitle. Default value: 1
/// - [subtitleExtraMaxlines]: An [int] that represents the maximum number of lines for the extra subtitle. Default value: 1
/// - [wrapperColor]: A [Color] for the wrapper state. Default value: Colors.transparent
/// - [actionWidget]: A [ContentRowActionOptions] object that contains the configuration options for the action widget. Default value: none
/// - [padding]: An [EdgeInsetsGeometry] for the padding. Default value: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
/// - [crossAxisAlignment]: An [CrossAxisAlignment] for the [Row] in [ContentRow]. Default value: CrossAxisAlignment.center
/// - [supportTitleRTL]: This field is necessary to prevent header mirroring
/// - [titleBuilder]: A [RowContentBuilder] function that returns a widget for the title. Default value: null
/// - [subtitleBuilder]: A [RowContentBuilder] function that returns a widget for the subtitle. Default value: null
/// - [subtitleExtraBuilder]: A [RowContentBuilder] function that returns a widget for the extra subtitle. Default value: null
///
/// Example usage:
///
/// ```dart
/// ContentRowOptions options = ContentRowOptions(
///   dividerEnabled: true,
///   leadingIcon: Icon(Icons.star),
///   title: 'Title',
///   subtitle: 'Subtitle',
///   subtitleExtra: 'Extra Subtitle',
///   titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
///   subtitleStyle: TextStyle(fontSize: 14, color: Colors.grey),
/// );
/// ```

/// Example:
/// ```dart
/// ContentRowOptions(
///  dividerEnabled: true,
///  wrapperEnabled: true,
///  title: 'Title',
///  subtitle: 'Subtitle',
///  actionWidget: ContentRowActionOptions(
///   actionText: 'Action',
///  ),
/// )
/// ```
///
@Deprecated('Use [ContentRowTextOptions] and [ContentRowTrailingOptions] instead')
class ContentRowOptions {
  final bool? dividerEnabled;
  final bool? wrapperEnabled;
  final bool? supportTitleRTL;

  final Widget? leadingIcon;
  final Widget? customActionWidget;
  final Widget? bottomWidget;
  final String? title;
  final List<UIMarkedUpTextSpan>? titleMatchedParts;
  final String? subtitle;
  final List<UIMarkedUpTextSpan>? subtitleMatchedParts;
  final String? subtitleExtra;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? subtitleExtraStyle;
  final int? titleMaxlines;
  final int? subtitleMaxlines;
  final int? subtitleExtraMaxlines;

  final RowContentBuilder? titleBuilder;
  final RowContentBuilder? subtitleBuilder;
  final RowContentBuilder? subtitleExtraBuilder;

  final Color? wrapperColor;

  final ContentRowActionOptions? actionWidget;

  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment? crossAxisAlignment;

  const ContentRowOptions({
    this.dividerEnabled,
    this.wrapperEnabled,
    this.leadingIcon,
    this.customActionWidget,
    this.title,
    this.titleMatchedParts,
    this.subtitle,
    this.subtitleMatchedParts,
    this.subtitleExtra,
    this.actionWidget,
    this.titleStyle,
    this.subtitleExtraStyle,
    this.titleMaxlines,
    this.subtitleMaxlines,
    this.subtitleExtraMaxlines,
    this.subtitleStyle,
    this.padding,
    this.wrapperColor,
    this.crossAxisAlignment,
    this.supportTitleRTL = true,
    this.bottomWidget,
    this.titleBuilder,
    this.subtitleBuilder,
    this.subtitleExtraBuilder,
  });

  ContentRowOptions copyWith({
    bool? dividerEnabled,
    bool? wrapperEnabled,
    bool? expandableEnabled,
    Widget? leadingIcon,
    Widget? customActionWidget,
    String? title,
    List<UIMarkedUpTextSpan>? titleMatchedParts,
    String? subtitle,
    List<UIMarkedUpTextSpan>? subtitleMatchedParts,
    String? subtitleExtra,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? subtitleExtraStyle,
    int? titleMaxlines,
    Color? wrapperColor,
    ContentRowActionOptions? actionWidget,
    EdgeInsetsGeometry? padding,
    bool? supportTitleRTL,
    RowContentBuilder? titleBuilder,
    RowContentBuilder? subtitleBuilder,
    RowContentBuilder? subtitleExtraBuilder,
    Widget? bottomWidget,
  }) {
    return ContentRowOptions(
      dividerEnabled: dividerEnabled ?? this.dividerEnabled,
      wrapperEnabled: wrapperEnabled ?? this.wrapperEnabled,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      customActionWidget: customActionWidget ?? this.customActionWidget,
      title: title ?? this.title,
      titleMatchedParts: titleMatchedParts ?? this.titleMatchedParts,
      subtitle: subtitle ?? this.subtitle,
      subtitleMatchedParts: subtitleMatchedParts ?? this.subtitleMatchedParts,
      subtitleExtra: subtitleExtra ?? this.subtitleExtra,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      subtitleExtraStyle: subtitleExtraStyle ?? this.subtitleExtraStyle,
      titleMaxlines: titleMaxlines ?? this.titleMaxlines,
      wrapperColor: wrapperColor ?? this.wrapperColor,
      actionWidget: actionWidget ?? this.actionWidget,
      padding: padding ?? this.padding,
      supportTitleRTL: supportTitleRTL ?? this.supportTitleRTL,
      titleBuilder: titleBuilder ?? this.titleBuilder,
      subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
      subtitleExtraBuilder: subtitleExtraBuilder ?? this.subtitleExtraBuilder,
      bottomWidget: bottomWidget ?? this.bottomWidget,
    );
  }
}

/// The [ContentRowActionOptions] class is a data class that holds the options for the action widget in the [ContentRow] widget.
///
/// The options include the following:
/// - [actionText]: A string that represents the action text.
/// - [actionTextStyle]: A text style for the action text.
/// - [actionIcon]: A widget that represents the action icon.
/// - [enabledToggle]: A boolean that determines whether the toggle is enabled.
/// - [toggleInitialValue]: A boolean that represents the initial value of the toggle.
/// - [customToggleBuilder]: A function that returns a widget for the custom toggle. The function takes a [ValueChanged<bool>] that you need call in your implementation and a [bool] as initial value.
///
/// Important: You must provide only one option between
/// ([actionText], [actionIcon]) and ([customToggleBuilder], [enabledToggle]). You sholdn't provide it together.
/// If you provide enabledToggle you should'n provide customToggleBuilder.
///
/// Exmples:
/// #Default toggle
/// ```dart
/// ContentRowActionOptions(
///   enabledToggle: true,
/// )
/// ```
/// #Custom toggle
/// ```dart
/// ContentRowActionOptions(
///   customToggleBuilder: (onToggle, initial) {
///    return Switch(value: initial, onChanged: onToggle);
///  }
/// )
/// ```
/// #Action with text
/// ```dart
/// ContentRowActionOptions(
///  actionText: 'Action',
/// )
/// ```

class ContentRowActionOptions {
  final String? actionText;
  final TextStyle? actionTextStyle;
  final AppIcons? actionIcon;
  final bool? enabledToggle;
  final bool? toggleInitialValue;
  final Widget Function({required ValueChanged<bool>? onToggle, bool? initial})? customToggleBuilder;
  final OnTap? actionPressed;

  const ContentRowActionOptions({
    this.actionText,
    this.actionIcon,
    this.actionPressed,
    this.enabledToggle,
    this.customToggleBuilder,
    this.toggleInitialValue,
    this.actionTextStyle,
  });

  ContentRowActionOptions copyWith({
    String? actionText,
    TextStyle? actionTextStyle,
    AppIcons? actionIcon,
    OnTap? actionPressed,
    bool? enabledToggle,
    bool? toggleInitialValue,
    Widget Function({required ValueChanged<bool>? onToggle, bool? initial})? customToggleBuilder,
  }) {
    return ContentRowActionOptions(
      actionText: actionText ?? this.actionText,
      actionTextStyle: actionTextStyle ?? this.actionTextStyle,
      actionIcon: actionIcon ?? this.actionIcon,
      actionPressed: actionPressed ?? this.actionPressed,
      enabledToggle: enabledToggle ?? this.enabledToggle,
      toggleInitialValue: toggleInitialValue ?? this.toggleInitialValue,
      customToggleBuilder: customToggleBuilder ?? this.customToggleBuilder,
    );
  }
}
