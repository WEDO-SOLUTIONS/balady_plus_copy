import 'dart:math';

import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ImageEditorPage extends ConsumerStatefulWidget {
  const ImageEditorPage(this.image, {super.key});

  final Uint8List image;

  @override
  ConsumerState<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends ConsumerState<ImageEditorPage> {
  late CustomImageCropController controller;
  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: CustomImageCrop(
                  cropController: controller,
                  image: MemoryImage(
                    widget.image,
                  ), // Any Imageprovider will work, try with a NetworkImage for example...
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: controller.reset),
                  IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: () =>
                          controller.addTransition(CropImageData(scale: 1.33))),
                  IconButton(
                      icon: const Icon(Icons.zoom_out),
                      onPressed: () =>
                          controller.addTransition(CropImageData(scale: 0.75))),
                  IconButton(
                      icon: const Icon(Icons.rotate_left),
                      onPressed: () => controller
                          .addTransition(CropImageData(angle: -pi / 4))),
                  IconButton(
                      icon: const Icon(Icons.rotate_right),
                      onPressed: () => controller
                          .addTransition(CropImageData(angle: pi / 4))),
                  const Spacer(),
                  TextButton(
                    child: const Text("Accept"),
                    onPressed: () async {
                      final image = await controller.onCropImage();
                      context.pop(image?.bytes);
                    },
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
