part of '../content_row.dart';

class ContentRowAction extends StatefulWidget {
  final ValueChanged<bool>? onToggle;
  final ContentRowActionOptions? actionOptions;

  const ContentRowAction({
    this.actionOptions,
    this.onToggle,
    super.key,
  });

  @override
  State<ContentRowAction> createState() => ContentRowActionState();
}

class ContentRowActionState extends State<ContentRowAction> {
  late bool _toggleValue;

  @override
  void initState() {
    super.initState();
    _toggleValue = widget.actionOptions?.toggleInitialValue ?? false;
  }

  void _onToggle(bool value) {
    setState(() {
      _toggleValue = value;
    });
    widget.onToggle?.call(value);
  }

  bool get _isActionEnabled => widget.actionOptions?.actionIcon != null || widget.actionOptions?.actionText != null;

  bool get _isToggleEnabled =>
      widget.actionOptions?.enabledToggle == true || widget.actionOptions?.customToggleBuilder != null;

  @override
  Widget build(BuildContext context) {
    if (widget.actionOptions == null) {
      return const SizedBox.shrink();
    }

    assert(
        _isActionEnabled || _isToggleEnabled,
        'You must provide either an action icon or text or a toggle '
        'widget or a custom toggle builder');

    if (_isActionEnabled && !_isToggleEnabled) {
      return ActionWidget(
        actionText: widget.actionOptions?.actionText,
        actionIcon: widget.actionOptions?.actionIcon,
        actionTextStyle: widget.actionOptions?.actionTextStyle,
        actionPressed: widget.actionOptions?.actionPressed,
      );
    }

    if (_isToggleEnabled && !_isActionEnabled) {
      return widget.actionOptions?.enabledToggle == true
          ? Toggle(value: _toggleValue, onChanged: _onToggle)
          : widget.actionOptions!.customToggleBuilder!.call(
              initial: widget.actionOptions?.toggleInitialValue ?? false,
              onToggle: _onToggle,
            );
    }

    return const SizedBox.shrink();
  }
}
