import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/image_denied_dialog.dart';
import 'package:mapness/widgets/feedback/feedback_label.dart';
import 'package:permission_handler/permission_handler.dart';

const _imageSize = 62.0;

class FeedbackImages extends StatelessWidget {
  final FeedbackImageInputEntity field;
  final void Function(List<XFile>) onValueChange;

  const FeedbackImages({
    required this.field,
    required this.onValueChange,
    super.key,
  });

  bool get isAddImageButtonVisible => (field.value ?? []).length < 10;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeedbackLabel(text: field.label),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (isAddImageButtonVisible)
                _Button(onTap: () async {
                  final permission = await Permission.photos.request();
                  if (permission.isDenied || permission.isPermanentlyDenied) {
                    await showPermissionDeniedDialog(context);
                    return;
                  }
                  final image = await _pickedImage();
                  if (image != null) {
                    onValueChange([...field.value ?? [], image]);
                  }
                }),
              ...(field.value ?? []).map(
                (img) {
                  final fileType = img.path.split('.').last.toLowerCase();

                  return _ImageFeedback(
                    img: img,
                    onRemove: () => onValueChange(
                      (field.value ?? []).where((e) => e != img).toList(),
                    ),
                    isSupported: field.acceptedFormats.contains(fileType),
                  );
                },
              ),
            ],
          ),
        ],
      );

  Future<XFile?> _pickedImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image;
  }
}

class _Button extends StatelessWidget {
  final void Function() onTap;
  const _Button({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.l),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RadiusBorder.l),
          child: SizedBox(
            height: _imageSize,
            width: _imageSize,
            child: ColoredBox(
              color: context.colorsV2.backgroundSurface1,
              child: Center(
                child: Icon(
                  GeneralIcons.plusCircle,
                  color: context.colorsV2.accentDefault,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      );
}

class _ImageFeedback extends StatelessWidget {
  final XFile img;
  final VoidCallback onRemove;
  final bool isSupported;

  const _ImageFeedback({
    required this.img,
    required this.onRemove,
    required this.isSupported,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.l),
        child: SizedBox(
          width: _imageSize,
          height: _imageSize,
          child: Stack(
            children: [
              SizedBox(
                height: _imageSize,
                width: _imageSize,
                child: _ImagePreview(
                  img: img,
                  isSupported: isSupported,
                ),
              ),
              CupertinoButton(
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
              ),
            ],
          ),
        ),
      );
}

class _ImagePreview extends StatelessWidget {
  final XFile img;
  final bool isSupported;

  const _ImagePreview({
    required this.img,
    required this.isSupported,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (!isSupported) {
      return Center(
        child: Text(l10n.feedbackImageUnsupportedFormat),
      );
    }

    return Image.file(
      File(img.path),
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text(l10n.feedbackImageError),
      ),
      fit: BoxFit.cover,
    );
  }
}
