import 'package:flutter/material.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_selector_sheet.dart';
import 'package:mapness/widgets/feedback/images/feedback_permission_sheet.dart';

Future<void> showPermissionDeniedDialog(BuildContext context, FeedbackImageSelectorType type) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    elevation: 0,
    showDragHandle: false,
    builder: (context) => FeedbackPermissionSheet(type: type),
  );
}
