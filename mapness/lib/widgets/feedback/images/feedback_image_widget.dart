import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/feedback/feedback_upload_image.dart';
import 'package:mapness/shared/lib/file_upload.dart';

class FeedbackImageWidget extends ConsumerStatefulWidget {
  final String imagePath;
  final double imageSize;
  final void Function(FileUpload) onUploadStatusChange;
  final VoidCallback onRemove;

  const FeedbackImageWidget({
    required this.onRemove,
    required this.imagePath,
    required this.onUploadStatusChange,
    required this.imageSize,
    super.key,
  });

  @override
  ConsumerState<FeedbackImageWidget> createState() =>
      _FeedbackImageWidgetState();
}

class _FeedbackImageWidgetState extends ConsumerState<FeedbackImageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadProvider = feedbackUploadImageProvider(widget.imagePath);
    final upload = ref.watch(uploadProvider);

    /// notify form about uploading (lock submit until finish)
    ref.listen(
        uploadProvider, (_, newState) => widget.onUploadStatusChange(newState));

    final isLoading = upload is FileUploadInit;

    return AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) => Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
        child: Container(
          width: widget.imageSize,
          height: widget.imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusBorder.l),
            color: context.colorsV2.backgroundSurface3,
          ),
          child: Stack(
            children: [
              Center(
                child: switch (upload) {
                  FileUploadSuccess() => ClipRRect(
                      borderRadius: BorderRadius.circular(RadiusBorder.l),
                      child: Image.file(
                        File(upload.srcPath),
                        fit: BoxFit.cover,
                        width: widget.imageSize,
                        height: widget.imageSize,
                      ),
                    ),
                  FileUploadInit() => const CircularProgressIndicator(),
                  FileUploadProgress(progress: final progress) =>
                    CircularProgressIndicator(value: progress),
                  _ => Icon(
                      GeneralIcons.infoCircle,
                      color: context.colorsV2.errorDefault,
                    ),
                },
              ),
              if (!isLoading)

                /// cancel upload and remove image
                Positioned(
                  right: 3,
                  top: 3,
                  child: _ImageRemoveButton(onRemove: () async {
                    await ref.read(uploadProvider.notifier).cancelUpload();
                    await _controller.forward();
                    widget.onRemove();
                  }),
                ),
            ],
          ),
        ));
  }
}

class _ImageRemoveButton extends StatelessWidget {
  final VoidCallback onRemove;

  const _ImageRemoveButton({
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onRemove,
        child: Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.black.withOpacity(0.6),
          ),
          child: Center(
            child: Icon(
              SystemIcons.closeSmall,
              color: context.colorsV2.backgroundSurface1,
              size: 16,
            ),
          ),
        ),
      );
}
