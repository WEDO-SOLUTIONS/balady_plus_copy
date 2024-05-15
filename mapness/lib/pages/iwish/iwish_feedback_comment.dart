import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/features/iwish/providers/iwish_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/sheets/labeled_draggable_sheet.dart';
import 'package:mapness/widgets/iwish/ui/iwish_text_editing_field.dart';

class IwishFeedbackComment extends ConsumerStatefulWidget {
  const IwishFeedbackComment({required this.iwishId, super.key});
  final String iwishId;

  @override
  ConsumerState<IwishFeedbackComment> createState() =>
      _IwishFeedbackCommentState();
}

class _IwishFeedbackCommentState extends ConsumerState<IwishFeedbackComment> {
  void onClose() {
    IwishFeedbackRoute(iwishId: widget.iwishId).replace(context);
  }

  void onSubmit() {
    ref
        .read(iwishFeedbackProvider(widget.iwishId).notifier)
        .updateComment(comment);

    onClose();
  }

  String comment = '';

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    /// keep provider alive
    ref.watch(iwishFeedbackProvider(widget.iwishId).select((_) {}));

    /// screen is not available when provider is not ready
    final state = ref.read(iwishFeedbackProvider(widget.iwishId)).requireValue;
    comment = state.comment ?? '';

    return LabeledDraggableSheet(
      onClose: onClose,
      title: context.l10n.shareFeedback,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          IwishTextEditingField(
            onChanged: (text) => comment = text,
            initialValue: comment,
          ),
          const SizedBox(height: 16),
          LabeledElevatedButton(
            onPressed: onSubmit,
            label: context.l10n.ready,
          ),
          const SizedBox(height: 20),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
