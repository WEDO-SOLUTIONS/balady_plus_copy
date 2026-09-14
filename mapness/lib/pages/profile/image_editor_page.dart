import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
  late final CustomImageCropController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = CustomImageCropController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final image = await _controller.onCropImage();
      if (!mounted) return;
      context.router.pop(image?.bytes);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final accent = colors.accentDefault;
    final barTextStyle = textStyles.bodyLargeSemiBold.copyWith(color: accent);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: Material(
        color: colors.backgroundSurface4,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomImageCrop(
                  cropController: _controller,
                  image: MemoryImage(widget.image),
                  backgroundColor: colors.backgroundSurface4,
                  overlayColor: colors.backgroundSurface4.withValues(alpha: 0.92),
                  outlineColor: accent,
                  pathPaint: Paint()
                    ..color = accent
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2,
                ),
              ),
              ColoredBox(
                color: colors.backgroundSurface1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
                  child: Row(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: accent),
                        onPressed: _isSaving ? null : () => context.router.pop(),
                        child: Text(context.l10n.feedbackBreaksSheetClose, style: barTextStyle),
                      ),
                      const Spacer(),
                      IconButton(
                        color: accent,
                        icon: const Icon(Icons.refresh),
                        onPressed: _controller.reset,
                      ),
                      IconButton(
                        color: accent,
                        icon: const Icon(Icons.zoom_in),
                        onPressed: () => _controller.addTransition(CropImageData(scale: 1.33)),
                      ),
                      IconButton(
                        color: accent,
                        icon: const Icon(Icons.zoom_out),
                        onPressed: () => _controller.addTransition(CropImageData(scale: 0.75)),
                      ),
                      IconButton(
                        color: accent,
                        icon: const Icon(Icons.rotate_left),
                        onPressed: () => _controller.addTransition(CropImageData(angle: -pi / 4)),
                      ),
                      IconButton(
                        color: accent,
                        icon: const Icon(Icons.rotate_right),
                        onPressed: () => _controller.addTransition(CropImageData(angle: pi / 4)),
                      ),
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: accent),
                        onPressed: _isSaving ? null : _onSave,
                        child: _isSaving
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: accent,
                                ),
                              )
                            : Text('saveButton'.tr(), style: barTextStyle),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
