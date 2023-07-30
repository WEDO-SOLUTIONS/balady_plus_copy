import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomIndicatorWidget, CustomVerticalSpace, ProjectImageWidget;
import 'package:flutter/material.dart';

class ProjectImagesSliderWidget extends StatefulWidget {
  final List<String> images;

  const ProjectImagesSliderWidget({Key? key, required this.images})
      : super(key: key);

  @override
  State<ProjectImagesSliderWidget> createState() =>
      _ProjectImagesSectionState();
}

class _ProjectImagesSectionState extends State<ProjectImagesSliderWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: widget.images.length,
            controller: PageController(),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int itemIndex) {
              return ProjectImageWidget(
                imageUrl: widget.images[itemIndex],
              );
            },
          ),
        ),
        const CustomVerticalSpace(height: 12),
        // indicator
        SizedBox(
            height: 10.0,
            child: CustomIndicatorWidget(
              currentIndex: currentIndex,
              length: widget.images.length,
            ))
      ],
    );
  }
}
