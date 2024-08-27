import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/pages/feedback/components/feedback_field_widget.dart';

class FeedbackFormWidget extends StatefulWidget {
  final List<FeedbackBaseEntity> fields;
  final ValueNotifier<bool> isFormValidNotifier;

  const FeedbackFormWidget({
    required this.fields,
    required this.isFormValidNotifier,
    super.key,
  });

  @override
  State<FeedbackFormWidget> createState() => _FeedbackFormWidgetState();
}

class _FeedbackFormWidgetState extends State<FeedbackFormWidget> {
  late List<ValueNotifier<FeedbackBaseEntity>> fieldNotifiers;

  ValueNotifier<bool> isFormValidNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    fieldNotifiers = widget.fields.map((field) => ValueNotifier(field)).toList();

    for (final notifier in fieldNotifiers) {
      /// seems to be disgusting but actually user is limited to modify single field at a time, so
      /// not that bad
      notifier.addListener(() {
        widget.isFormValidNotifier.value = isFormValid();
      });
    }
  }

  @override
  void dispose() {
    for (final notifier in fieldNotifiers) {
      notifier.dispose();
    }
    super.dispose();
  }

  bool isFormValid() => fieldNotifiers.every((notifier) => notifier.value.isValid);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: true,
      shrinkWrap: true,
      itemCount: fieldNotifiers.length,
      itemBuilder: (context, index) {
        final notifier = fieldNotifiers[index];

        return ValueListenableBuilder(
          valueListenable: notifier,
          builder: (context, field, child) => FeedbackFieldWidget(
            field: field,
            onValueChange: (value) => notifier.value = notifier.value.updatedValue(value),
            key: ValueKey(field.id),
          ),
        );
      },
      separatorBuilder: (context, index) => Spacing.$4x.heightBox,
    );
  }
}
