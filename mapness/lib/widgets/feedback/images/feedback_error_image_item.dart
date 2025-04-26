part of 'feedback_image_widget.dart';

class _FeedbackErrorImageItem extends StatelessWidget {
  final String imagePath;
  final double imageSize;
  final VoidCallback onRefresh;

  const _FeedbackErrorImageItem({
    required this.imagePath,
    required this.imageSize,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: FeedbackImageItem(
              imagePath: imagePath,
              imageSize: imageSize,
            ),
          ),
          Center(
            child: ImageActionButton(
              icon: GeneralIcons.reload,
              size: 24,
              iconSize: 12,
              onTap: onRefresh,
            ),
          ),
        ],
      );
}
