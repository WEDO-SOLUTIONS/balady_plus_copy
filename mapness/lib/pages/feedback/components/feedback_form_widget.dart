import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/pages/feedback/components/feedback_field_widget.dart';

class FeedbackFormWidget extends ConsumerWidget {
  final List<FeedbackBaseEntity> fields;
  final int? objectId;

  const FeedbackFormWidget({
    required this.fields,
    this.objectId,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: true,
      shrinkWrap: true,
      separatorBuilder: (context, index) => Spacing.$3x.heightBox,
      itemCount: fields.length,
      itemBuilder: (context, index) => FeedbackFieldWidget(
        field: fields[index],
        objectId: objectId,
        key: ValueKey(fields[index].id),
      ),
    );
  }
}
