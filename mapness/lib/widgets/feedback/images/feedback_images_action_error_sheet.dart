import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_image_action_error.dart';
import 'package:mapness/entities/feedback/fields_entity/extentions/feedback_image_format_extention.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';

class FeedbackImagesActionErrorSheet extends StatelessWidget {
  final FeedbackImagePickError error;

  const FeedbackImagesActionErrorSheet({
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = switch (error) {
      FeedbackImageWrongFormatError(supportedFormats: final supportedFormats) =>
        l10n.feedbackImageWrongFormatFailure(
            supportedFormats.formatAcceptedFormats(l10n)),
      FeedbackImageSizeExceededError(maxFileSize: final maxFileSize) =>
        l10n.feedbackImageSizeExceedFailure(
          maxFileSize.formatAsFileSize(),
        ),
    };
    return BaseErrorWidget(
      errorLabel: label,
      onRetry: () {
        Navigator.of(context).pop(true);
      },
    );
  }
}
