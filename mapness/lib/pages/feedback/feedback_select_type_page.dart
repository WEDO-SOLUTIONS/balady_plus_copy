import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/feedback/components/feedback_select_options_component_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';

class FeedbackSelectTypePage extends ConsumerWidget {
  final String? objectId;

  const FeedbackSelectTypePage({
    required this.objectId,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    if (objectId == null) {
      return const SizedBox();
    }
    final id = int.tryParse(objectId!);

    return FeedbackFormContainer(
      title: context.l10n.feedbackWhatsWrong,
      isSendVisible: false,
      child: id == null
          ? Center(child: Loading.large())
          : FeedbackSelectOptionsComponentWidget(objectId: id),
    );
  }
}
