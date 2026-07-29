import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

class IwishTextEditingField extends StatefulWidget {
  const IwishTextEditingField({
    required this.onChanged,
    this.maxLength = 1000,
    super.key,
    this.initialValue,
  });
  final void Function(String) onChanged;
  final String? initialValue;
  final int maxLength;

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

  OutlineInputBorder _getBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(Spacing.$2x),
    borderSide: BorderSide(
      color: color,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final style = context.textStyle.text.copyWith(color: context.colors.foregroundDefault);
    final errorColor = context.colors.errorOnContainer;
    final errorBorder = _getBorder(errorColor);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, value, __) => Text(
              context.digits('${value.text.length}/${widget.maxLength}'),
              style: context.textStyle.caption.copyWith(
                color: value.text.length > widget.maxLength ? errorColor : context.textStyle.caption.color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextFormField(
              focusNode: _focusNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _controller,
              maxLines: 1000,
              onChanged: widget.onChanged,
              style: style,
              cursorColor: context.colors.accentOnContainer,
              validator: (value) => (value?.length ?? 0) > widget.maxLength ? '' : null,
              autofocus: true,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                errorStyle: const TextStyle(height: 0),
                hintText: context.l10n.shareYourFeedback,
                fillColor: context.colors.backgroundSurface4,
                enabledBorder: _getBorder(Colors.transparent),
                focusedBorder: _getBorder(context.colors.accentOnContainer),
                focusedErrorBorder: errorBorder,
                errorBorder: errorBorder,
                contentPadding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$2x),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
