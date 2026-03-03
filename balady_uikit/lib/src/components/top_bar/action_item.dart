part of 'top_bar.dart';

/// A [ActionItem] is a widget that has an [icon] and [text] and [onPressed] callback.
/// The [icon] and [text] are displayed in a row.
/// Mainly used in the [BaladyTopBar] as a [leading] or [trailing] widget in the [BaladyTopBar.iconAndText] constructor.
///
/// Example:
/// ```dart
/// ActionItem(
///   action: ActionModel(
///     icon: BaladyIcons.Back,
///     text: 'Back',
///     onPressed: () => print('Leading Pressed'),
///   ),
/// ),
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2238%3A10446&mode=dev

class ActionItem extends StatefulWidget {
  /// The [action] is the data which will be displayed in the [ActionItem] widget.
  final ActionModel action;

  /// The [reverseOrder] is a boolean to reverse the order of the [icon] and [text].
  final bool reverseOrder;

  final Color? colorEnabled;
  final Color? colorPressed;
  final Color? colorDisabled;

  /// Bool to understand what color will be as a default
  final bool isEnabled;

  /// Main constructor for the [ActionItem] widget.
  const ActionItem({
    required this.action,
    this.reverseOrder = false,
    super.key,
    this.colorEnabled,
    this.colorPressed,
    this.colorDisabled,
    this.isEnabled = true,
  });

  @override
  State<ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<ActionItem> {
  late WidgetStatesController materialStatesController;
  Color? _color;

  @override
  void initState() {
    _color = widget.isEnabled ? widget.colorEnabled : widget.colorDisabled;
    materialStatesController = WidgetStatesController();
    materialStatesController.addListener(() {
      if (widget.action.onPressed == null) {
        _color = widget.colorDisabled;
      } else {
        if (materialStatesController.value.contains(WidgetState.pressed)) {
          setState(() {
            _color = widget.colorPressed;
          });
        } else {
          setState(() {
            _color = widget.colorEnabled;
          });
        }
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ActionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled != oldWidget.isEnabled ||
        widget.colorEnabled != oldWidget.colorEnabled ||
        widget.colorDisabled != oldWidget.colorDisabled) {
      _color = widget.isEnabled ? widget.colorEnabled : widget.colorDisabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.bodySmallSemiBold.copyWith(color: _color);

    const gap = SizedBox(width: Spacing.$1x);
    const space = SizedBox(width: Spacing.$4x);

    final icon = widget.action.icon;
    final text = widget.action.text;
    final onPressed = widget.action.onPressed;
    final iconSize = widget.action.iconSize;

    var children = [
      space,
      if (icon != null) Icon(icon, size: iconSize, color: _color),
      if (icon != null && text != null) gap,
      if (text != null) ActionText(text: text, textStyle: style),
      space,
    ];
    var mainAxisAlignment = MainAxisAlignment.start;

    if (widget.reverseOrder) {
      children = children.reversed.toList();
      mainAxisAlignment = MainAxisAlignment.end;
    }

    return InkWell(
      statesController: materialStatesController,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
