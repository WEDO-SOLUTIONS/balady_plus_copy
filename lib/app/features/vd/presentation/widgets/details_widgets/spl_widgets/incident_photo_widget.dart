import 'dart:io';

import 'package:flutter/material.dart';

class IncidentPhotoWidget extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  const IncidentPhotoWidget(
      {Key? key, required this.image, this.height = 296, this.width = 231})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(File(image),
          height: height, width: width, fit: BoxFit.fill),
    );
  }
}
