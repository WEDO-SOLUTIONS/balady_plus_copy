import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_action_button.dart';

class FeedbackImageWrapper extends HookWidget {
  final double imageSize;
  final bool isLoading;
  final VoidCallback onRemove;
  final Widget child;

  const FeedbackImageWrapper({
    required this.imageSize,
    required this.onRemove,
    required this.isLoading,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(milliseconds: 300));
    final opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(controller);

    return AnimatedBuilder(
        animation: opacityAnimation,
        builder: (context, child) => Opacity(
              opacity: opacityAnimation.value,
              child: child,
            ),
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusBorder.l),
            color: context.colorsV2.backgroundSurface3,
          ),
          child: Stack(
            children: [
              Center(
                child: child,
              ),
              if (!isLoading)

                /// cancel upload and remove image
                Positioned(
                  right: 3,
                  top: 3,
                  child: ImageActionButton(
                      size: imageSize * .3,
                      iconSize: imageSize * .2,
                      icon: SystemIcons.closeSmall,
                      onTap: () async {
                        await controller.forward();
                        onRemove();
                      }),
                ),
            ],
          ),
        ));
  }
}
