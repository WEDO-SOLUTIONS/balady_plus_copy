import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/feedback/feedback_upload_image.dart';
import 'package:mapness/shared/lib/file_upload.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_action_button.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_item.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_wrapper.dart';

part 'feedback_error_image_item.dart';

class FeedbackImageWidget extends ConsumerWidget {
  final String imagePath;
  final double imageSize;
  final void Function(FileUpload) onUploadStatusChange;
  final VoidCallback onRemove;

  const FeedbackImageWidget({
    required this.onRemove,
    required this.imagePath,
    required this.onUploadStatusChange,
    required this.imageSize,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadProvider = feedbackUploadImageProvider(imagePath);
    final upload = ref.watch(uploadProvider);

    /// notify form about uploading (lock submit until finish)
    ref.listen(uploadProvider, (_, newState) => onUploadStatusChange(newState));

    final isLoading = upload.maybeWhen<bool>(
      init: (_) => true,
      progress: (_, __) => true,
      orElse: () => false,
    );

    return FeedbackImageWrapper(
      imageSize: imageSize,
      isLoading: isLoading,
      onRemove: () {
        detach(ref.read(uploadProvider.notifier).cancelUpload(), tag: 'feedbackImageWidget.cancelUpload');
        onRemove();
      },
      child: switch (upload) {
        FileUploadSuccess() => FeedbackImageItem(
          imagePath: imagePath,
          imageSize: imageSize,
        ),
        FileUploadInit() || FileUploadProgress() => Loading.small(),
        _ => _FeedbackErrorImageItem(
          imagePath: imagePath,
          imageSize: imageSize,
          onRefresh: () => ref.invalidate(uploadProvider),
        ),
      },
    );
  }
}
