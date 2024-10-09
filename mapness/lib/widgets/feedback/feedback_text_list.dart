import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_text_field.dart';

class FeedbackTextListField extends StatefulWidget {
  final FeedbackTextListEntity field;

  const FeedbackTextListField({
    required this.field,
    super.key,
  });

  @override
  State<FeedbackTextListField> createState() => _FeedbackTextListFieldState();
}

class _FeedbackTextListFieldState extends State<FeedbackTextListField> {
  late final _inputs = List<FeedbackTextEntity>.of(widget.field.fields);

  void _addInput() {
    if (_inputs.isEmpty) {
      return;
    }
    setState(() {
      _inputs.add(FeedbackTextEntity(
        type: widget.field.type,
        id: '${widget.field.id}${_inputs.length}',
        isRequired: widget.field.isRequired,
        label: _inputs.last.label,
        maxLenght: _inputs.last.maxLenght,
        hint: _inputs.last.hint,
        isHidden: false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneField = widget.field.type == FeedbackTextType.phone;
    return Column(
      children: [
        for (var i = 0; i < _inputs.length; i++) ...[
          FeedbackInput(
            field: _inputs[i],
            isFirst: i == 0,
          ),
          Spacing.$4x.heightBox,
        ],
        SizedBox(
          width: double.infinity,
          child: AppButton(
            buttonColorScheme: ButtonColorScheme.secondary,
            primaryLabel: isPhoneField ? context.l10n.addPhoneNumber : context.l10n.add,
            primaryIcon: isPhoneField ? null : GeneralIcons.plusCircle,
            onTap: _addInput,
          ),
        ),
      ],
    );
  }
}
