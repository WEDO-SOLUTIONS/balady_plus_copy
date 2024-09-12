import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/pages/feedback/components/feedback_field_widget.dart';

class FeedbackFormWidget extends ConsumerStatefulWidget {
  final IList<FeedbackBaseEntity> fields;
  final ValueNotifier<bool> isFormValidNotifier;
  final String payloadId;
  final int objectId;
  final String categoryId;

  const FeedbackFormWidget({
    required this.payloadId,
    required this.fields,
    required this.isFormValidNotifier,
    required this.objectId,
    required this.categoryId,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeedbackFormWidgetState();
}

class _FeedbackFormWidgetState extends ConsumerState<FeedbackFormWidget> {
  /// almost free. And protects from redundant updates. Form is not bounded by size actually.
  late final List<ValueNotifier<FeedbackBaseEntity>> fieldNotifiers;

  ValueNotifier<bool> isFormValidNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // fieldNotifiers =
    //     widget.fields.map((field) => ValueNotifier(field)).toList();

    for (final notifier in fieldNotifiers) {
      /// seems to be disgusting but actually user is limited to modify single field at a time, so
      /// not that bad
      notifier.addListener(() {
        widget.isFormValidNotifier.value = isFormValid();

        /// TODO(Demezy): refactor this in prefer of
        // ref
        //     .read(submitFeedbackPayloadProvider(widget.payloadId).notifier)
        //     .collectForm(
        //       objectId: widget.objectId,
        //       categoryId: widget.categoryId,
        //       fields: fieldNotifiers.map((e) => e.value),
        //     );
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

  bool isFormValid() =>
      fieldNotifiers.every((notifier) => notifier.value.isValid);

  @override
  Widget build(BuildContext context) => ListView.separated(
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
              onValueChange: (value) =>
                  notifier.value = notifier.value.updatedValue(value),
              key: ValueKey(field.id),
            ),
          );
        },
        separatorBuilder: (context, index) => Spacing.$4x.heightBox,
      );
}
