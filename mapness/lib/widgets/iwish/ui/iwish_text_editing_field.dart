import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishTextEditingField extends StatefulWidget {

  const IwishTextEditingField({
    required this.onChanged, super.key,
    this.initialValue,
  });
  final void Function(String) onChanged;
  final String? initialValue;

  @override
  State<IwishTextEditingField> createState() => _IwishTextEditingFieldState();
}

class _IwishTextEditingFieldState extends State<IwishTextEditingField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
      minLines: 11,
      maxLines: 11,
      controller: _controller,
      style: Theme.of(context)
          .extension<ThemeTextStyles>()!
          .textM
          .copyWith(color: context.color.text_and_icons_base_primary),
      cursorColor: context.color.stroke_accent,
      decoration: InputDecoration(
        filled: true,
        fillColor: context.color.surface_base_primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
    );
}
