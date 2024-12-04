import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_image_action_error.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/ui/error_widget/error_widget.dart';

class FeedbackImagesActionErrorSheet extends StatelessWidget {
  final FeedbackImageActionError error;

  const FeedbackImagesActionErrorSheet({
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final label = switch (error) {
      FeedbackImageUploadFailError() => context.l10n.feedbackImageUploadFailure,
      FeedbackImageWrongFormatError(supportedFormats: final supportedFormats) =>
        context.l10n.feedbackImageWrongFormatFailure(supportedFormats),
      FeedbackImageSizeExceededError(maxFileSize: final maxFileSize) =>
        context.l10n.feedbackImageSizeExceedFailure(
          maxFileSize.formatAsFileSize(),
        ),
    };
    return BaseErrorWidget(
      errorLabel: label,
      onRetry: (){
        Navigator .of(context).pop(true);
      },
    );
  }
}
