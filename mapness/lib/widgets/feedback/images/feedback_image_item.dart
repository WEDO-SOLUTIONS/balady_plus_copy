import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

class FeedbackImageItem extends StatelessWidget {
  final String imagePath;
  final double imageSize;

  const FeedbackImageItem({
    required this.imagePath,
    required this.imageSize,
    super.key,
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
