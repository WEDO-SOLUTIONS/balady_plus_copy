import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomNetworkImageWidget;
import 'package:flutter/material.dart';

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
