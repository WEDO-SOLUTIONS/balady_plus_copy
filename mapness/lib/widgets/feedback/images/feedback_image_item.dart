part of 'feedback_image_widget.dart';

class _FeedbackImageItem extends StatelessWidget {
  final String imagePath;
  final double imageSize;

  const _FeedbackImageItem({
    required this.imagePath,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.l),
        child: Image(
          image: FileImage(File(imagePath)),
          fit: BoxFit.cover,
          width: imageSize,
          height: imageSize,
        ),
      );
}
