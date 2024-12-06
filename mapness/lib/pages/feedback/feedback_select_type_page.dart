import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/feedback/components/feedback_select_options_component_widget.dart';
import 'package:mapness/pages/feedback/feedback_failure_widget.dart';

@RoutePage()
class FeedbackSelectTypePage extends ConsumerWidget {
  final String objectId;

  const FeedbackSelectTypePage({
    required this.objectId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(objectId);
    if (id == null) {
      return const FeedbackFailureWidget();
    }

    return FeedbackSelectOptionsComponentWidget(
      objectId: id,
    );
  }
}
