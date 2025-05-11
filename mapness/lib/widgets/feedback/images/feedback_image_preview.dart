import 'package:flutter/material.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_item.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_wrapper.dart';

class FeedbackImagePreview extends StatelessWidget {
  final String imagePath;
  final double imageSize;

  final VoidCallback onRemove;
  const FeedbackImagePreview({
    required this.imagePath,
    required this.imageSize,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) => FeedbackImageWrapper(
        imageSize: imageSize,
        isLoading: false,
        onRemove: onRemove,
        child: FeedbackImageItem(
          imagePath: imagePath,
          imageSize: imageSize,
        ),
      );
}
