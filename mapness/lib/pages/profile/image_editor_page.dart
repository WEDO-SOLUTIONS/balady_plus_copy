import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

@RoutePage()
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
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: context.read<ThemeController>().systemOverlayStyle,
    child: Material(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: CustomImageCrop(cropController: controller, image: MemoryImage(widget.image)),
          ),
          Row(
            children: [
              const Spacer(),
              TextButton(
                child: Text(context.l10n.feedbackBreaksSheetClose),
                onPressed: () {
                  context.router.pop();
                },
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.refresh), onPressed: controller.reset),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () => controller.addTransition(CropImageData(scale: 1.33)),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () => controller.addTransition(CropImageData(scale: 0.75)),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_left),
                onPressed: () => controller.addTransition(CropImageData(angle: -pi / 4)),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_right),
                onPressed: () => controller.addTransition(CropImageData(angle: pi / 4)),
              ),
              const Spacer(),
              TextButton(
                child: const Text('Accept'),
                onPressed: () async {
                  final image = await controller.onCropImage();
                  context.router.pop(image?.bytes);
                },
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    ),
  );
}
