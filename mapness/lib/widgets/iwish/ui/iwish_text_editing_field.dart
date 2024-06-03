import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishTextEditingField extends StatefulWidget {
  const IwishTextEditingField({
    required this.onChanged,
    super.key,
    this.initialValue,
  });
  final void Function(String) onChanged;
  final String? initialValue;

  @override
  State<IwishTextEditingField> createState() => _IwishTextEditingFieldState();
}

class _IwishTextEditingFieldState extends State<IwishTextEditingField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  static const _minMaxLines = 11;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .extension<ThemeTextStyles>()!
        .text
        .copyWith(color: context.color.textAndIconsBasePrimary);

    return Expanded(
      child: TextField(
        autofocus: true,
        minLines: _minMaxLines,
        maxLines: _minMaxLines,
        focusNode: _focusNode,
        controller: _controller,
        onChanged: widget.onChanged,
        style: style,
        cursorColor: context.color.strokeAccent,
        decoration: InputDecoration(
          filled: true,
          fillColor: context.color.surfaceBasePrimary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        ),
      ),
    );
  }
}
