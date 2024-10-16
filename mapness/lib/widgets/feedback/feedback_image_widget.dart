import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/feedback/feedback_upload_image.dart';
import 'package:mapness/shared/lib/file_upload.dart';

class FeedbackImageWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadProvider = feedbackUploadImageProvider(imagePath);
    final upload = ref.watch(uploadProvider);

    /// notify form about uploading (lock submit until finish)
    ref.listen(uploadProvider, (_, newState) => onUploadStatusChange(newState));

    return Container(
      width: imageSize,
      height: imageSize,
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
                    width: imageSize,
                    height: imageSize,
                  ),
                ),
              FileUploadInit() => const CircularProgressIndicator(),
              FileUploadProgress(progress: final progress) => CircularProgressIndicator(value: progress),
              _ => Icon(
                  GeneralIcons.infoCircle,
                  color: context.colorsV2.errorDefault,
                ),
            },
          ),

          /// cancel upload and remove image
          _ImageRemoveButton(onRemove: () {
            ref.read(uploadProvider.notifier).cancelUpload();
            onRemove();
          }),
        ],
      ),
    );
  }
}

class _ImageRemoveButton extends StatelessWidget {
  final VoidCallback onRemove;

  const _ImageRemoveButton({
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: const EdgeInsetsDirectional.fromSTEB(3, 3, 3, 8),
        onPressed: onRemove,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 18,
            width: 18,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Center(
              child: Icon(
                Icons.close_rounded,
                color: context.colorsV2.backgroundSurface1,
                size: 16,
              ),
            ),
          ),
        ),
      );
}
