import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/phone_number_formatter.dart';
import 'package:mapness/widgets/feedback/feedback_input.dart';

class FeedbackTextListField extends StatefulWidget {
  final FeedbackTextListEntity field;

  const FeedbackTextListField({
    required this.field,
    super.key,
  });

  @override
  State<FeedbackTextListField> createState() => _FeedbackTextListFieldState();
}

class _InputItem {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Key key;

  _InputItem({required this.controller, required this.key}) : focusNode = FocusNode();
}

class _FeedbackTextListFieldState extends State<FeedbackTextListField> {
  late List<_InputItem> _inputItems;
  late final bool _isRequired = widget.field.isRequired;
  late final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _inputItems = widget.field.oldValues
        .map(
          (value) => _InputItem(
            controller: TextEditingController(text: value),
            key: UniqueKey(),
          ),
        )
        .toList();

    if (_inputItems.isEmpty) {
      _addInput();
    }
  }

  @override
  void dispose() {
    for (final item in _inputItems) {
      item.controller.dispose();
      item.focusNode.dispose();
    }

    _focusNode.dispose();
    super.dispose();
  }

  void _addInput() {
    setState(() {
      _inputItems.add(
        _InputItem(controller: TextEditingController(), key: UniqueKey()),
      );
    });
  }

  void _removeInput(int index) {
    setState(() {
      _inputItems[index].controller.dispose();
      _inputItems[index].focusNode.dispose();
      _inputItems.removeAt(index);
    });
  }

  bool _isValid(String? value) {
    final validator = switch (widget.field.type) {
      FeedbackTextType.email => FormBuilderValidators.email(checkNullOrEmpty: false),
      FeedbackTextType.phone => PhoneNumberFormatter.validateSaudiMobile,
      FeedbackTextType.url => FormBuilderValidators.url(checkNullOrEmpty: false),
      _ => (_) => null,
    };

    return validator(value) == null;
  }

  List<String> get _currentValues => _inputItems.map((item) => item.controller.text).toList();

  @override
  Widget build(BuildContext context) {
    final isPhoneField = widget.field.type == FeedbackTextType.phone;
    final keyboardType = switch (widget.field.type) {
      FeedbackTextType.phone => TextInputType.phone,
      FeedbackTextType.url => TextInputType.url,
      _ => TextInputType.text,
    };
    final allowedInputPattern = switch (widget.field.type) {
      FeedbackTextType.email => RegExp(r'[a-zA-Z0-9\._+\-@]'),
      FeedbackTextType.url => RegExp(r'[a-zA-Z0-9./:?_\-]'),
      _ => null,
    };

    return FormBuilderField<List<String>>(
      name: widget.field.id,
      initialValue: _currentValues,
      focusNode: _focusNode,
      valueTransformer: (values) {
        if (values == null) {
          return <String>[];
        }
        return values.where((v) => v.trim().isNotEmpty).map(
          (v) {
            if (widget.field.type == FeedbackTextType.phone) {
              return PhoneNumberFormatter.formatPure(v);
            } else {
              return v.trim();
            }
          },
        ).toList();
      },
      validator: (values) {
        if (_isRequired && (values == null || values.isEmpty)) {
          return FormBuilderValidators.required()(values);
        }
        for (final value in values ?? []) {
          if (!_isValid(value)) {
            return 'Wrong field';
          }
        }
        return null;
      },
      builder: (fieldState) => Column(
        children: [
          for (int i = 0; i < _inputItems.length; i++) ...[
            Row(
              key: _inputItems[i].key,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FeedbackTextInput(
                    focusNode: _inputItems[i].focusNode,
                    controller: _inputItems[i].controller,
                    labelText: i == 0 ? widget.field.label : null,
                    hintText: widget.field.hint,
                    errorText: _isValid(_inputItems[i].controller.text)
                        ? null
                        : context.l10n.feedbackTextFieldWrongFormat,
                    allowedInputPattern: allowedInputPattern,
                    isRequired: widget.field.isRequired,
                    maxLength: widget.field.maxLength,
                    keyboardType: keyboardType,
                    onChanged: (value) => fieldState.didChange(_currentValues),
                    type: widget.field.type,
                  ),
                ),
                if (i != 0)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: Spacing.$2x),
                    child: AppButton.close(
                      onTap: () {
                        _removeInput(i);
                        fieldState.didChange(_currentValues);
                      },
                      buttonColorScheme: ButtonColorScheme.onColor,
                      padding: EdgeInsets.zero,
                      size: ButtonSize.medium,
                    ),
                  ),
              ],
            ),
            Spacing.$2x.heightBox,
          ],
          SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonType: ButtonType.secondary,
              buttonColorScheme: ButtonColorScheme.accent,
              primaryLabel: isPhoneField ? context.l10n.addPhoneNumber : context.l10n.add,
              primaryIcon: isPhoneField ? null : GeneralIcons.plusCircle,
              onTap: () {
                _addInput();
                fieldState.didChange(_currentValues);
              },
            ),
          ),
        ],
      ),
    );
  }
}
