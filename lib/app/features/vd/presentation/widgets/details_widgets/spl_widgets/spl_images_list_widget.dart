import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';

class SplImagesListWidget extends StatelessWidget {
  List<String>? images;
  bool? showSwipe;

  SplImagesListWidget({Key? key, this.images, this.showSwipe = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMultipleImage = (images?.length ?? 0) > 1;
    return SizedBox(
      height: 279,
      width: MediaQuery.of(context).size.width / 2,
      child: Ink(
        color: Colors.transparent,
        child: Stack(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                physics: isMultipleImage
                    ? ScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                itemCount: images?.length ?? 0,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: SplImageWidget(
                        image: images?[index] ?? "",
                        imageHeight: isMultipleImage ? 240 : 279),
                  );
                }),
            if (isMultipleImage && (showSwipe ?? true))
              Align(
                alignment: Alignment.center,
                child: SwipeWidget(),
              )
          ],
        ),
      ),
    );
  }
}

class SplImageWidget extends StatelessWidget {
  final String image;
  final double imageHeight;

  const SplImageWidget(
      {Key? key, required this.image, required this.imageHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CustomNetworkImageWidget(
        image,
        imageHeight: imageHeight,
        imageWidth: double.infinity,
        ssoAuth: true,
      ),
    );
  }
}

class SwipeWidget extends StatefulWidget {
  const SwipeWidget({Key? key}) : super(key: key);

  @override
  State<SwipeWidget> createState() => _SwipeWidgetState();
}

class _SwipeWidgetState extends State<SwipeWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  bool showSwipeIcon = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0,
      upperBound: 100,
    );

    controller.addListener(() {
      setState(() {
        if (controller.value == 100) {
          showSwipeIcon = false;
        }
      });
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: controller.value),
      child: Image.asset(
        IconPath.vdSwipeIcon,
        height: showSwipeIcon ? 48 : 0,
        width: showSwipeIcon ? 48 : 0,
      ),
    );
  }
}
