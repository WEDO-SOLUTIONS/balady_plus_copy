import 'package:flutter/material.dart';

import '../../../../../../../app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';

class ProjectImageWidget extends StatelessWidget {
  final String imageUrl;

  const ProjectImageWidget({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1),
      width: double.infinity,
      height: 193,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: CustomNetworkImageWidget(
          imageUrl,
          imageWidth: double.infinity,
          imageHeight: 193,
          imageFit: BoxFit.fill,
        ),
      ),
    );
  }
}
