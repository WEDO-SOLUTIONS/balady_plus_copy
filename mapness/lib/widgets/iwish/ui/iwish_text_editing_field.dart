import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

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
    final style = context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary);

    return Expanded(
      child: TextField(
        autofocus: true,
        maxLines: 999,
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
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        ),
      ),
    );
  }
}
