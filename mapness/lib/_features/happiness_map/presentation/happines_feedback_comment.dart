import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/happiness_map/data/happines_manager.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/sheets/labeled_draggable_sheet.dart';
import 'package:mapness/widgets/iwish/ui/iwish_text_editing_field.dart';

class HappinesFeedbackComment extends ConsumerStatefulWidget {
  // for some reason media query does not rebuild widget. So, do not use const constructor
  // ignore: prefer_const_constructors_in_immutables
  HappinesFeedbackComment({super.key});

  @override
  ConsumerState<HappinesFeedbackComment> createState() =>
      _HappinessFeedbackCommentState();
}

class _HappinessFeedbackCommentState
    extends ConsumerState<HappinesFeedbackComment> {
  String _comment = '';

  void onClose() {
    context.pop();
  }

  void onSubmit() {
    ref.read(happinessManagerProvider.notifier).updateComment(_comment);

    onClose();
  }

  @override
  void initState() {
    super.initState();
    _comment = ref.read(happinessManagerProvider).comment;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottomPadding = mq.viewInsets.bottom;

    /// keep provider alive
    ref.watch(happinessManagerProvider.select((value) => null));

    return SafeArea(
      bottom: false,
      child: LabeledDraggableSheet(
        onClose: onClose,
        title: context.l10n.shareYourFeelings,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            IwishTextEditingField(
              onChanged: (text) => _comment = text,
              initialValue: _comment,
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
      ),
    );
  }
}
