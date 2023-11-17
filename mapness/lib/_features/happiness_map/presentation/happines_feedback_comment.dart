import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/happiness_map/data/happines_manager.dart';
import 'package:mapness/app/routes/happines_map.dart';
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
  void onClose() {
    const HappinessMapRoute().replace(context);
  }

  void onSubmit() {
    ref.read(happinessManagerProvider.notifier).updateComment(comment);

    onClose();
  }

  String comment = '';

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottomPadding = mq.viewInsets.bottom;

    /// keep provider alive
    ref.watch(happinessManagerProvider.select((value) => null));

    final state = ref.read(happinessManagerProvider);

    return LabeledDraggableSheet(
      onClose: onClose,
      title: 'Share your feelings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          IwishTextEditingField(
            onChanged: (text) => comment = text,
            initialValue: state.comment,
          ),
          const SizedBox(height: 16),
          LabeledElevatedButton(
            onPressed: onSubmit,
            label: 'Ready',
          ),
          const SizedBox(height: 20),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
