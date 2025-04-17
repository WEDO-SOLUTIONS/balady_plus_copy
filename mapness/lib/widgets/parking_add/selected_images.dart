import 'dart:async';
import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/widgets/feedback/images/add_image_button.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_widget.dart';

class SelectedImages extends StatefulWidget {
  final void Function(List<XFile> images) selectedImages;

  const SelectedImages({
    required this.selectedImages,
    super.key,
  });

  @override
  State<SelectedImages> createState() => _SelectedImagesState();
}

class _SelectedImagesState extends State<SelectedImages> {
  final _maxImageResolution = 5000;
  final _photoPadding = 8.0;
  final _maxImages = 10;
  final _maxSizeInBytes = 5 * 1024 * 1024; // 5MB
  final _imageSize = 62.0;

  final List<XFile> _images = [];

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images',
          style: context.textStyleV3.captionMediumRegular.copyWith(
            color: context.colorsV3.foregroundDefault,
          ),
        ),
        Spacing.$2x.heightBox,
        Wrap(
          spacing: _photoPadding,
          runSpacing: _photoPadding,
          children: [
            if (_images.length < _maxImages)
              AddImageButton(
                onTap: _onAddImages,
                size: _imageSize,
              ),
            ..._images.indexed.map(
                  (indexedUpload) => FeedbackImageWidget(
                key: ValueKey(indexedUpload),
                imagePath: indexedUpload.$2.path,
                onRemove: () => _removeImage(indexedUpload.$1),
                onUploadStatusChange: (_) {},
                imageSize: _imageSize,
              ),
            ),
          ],
        ),
        Spacing.$3x.heightBox,
        Text(
          context.l10n.feedbackImageLimitsError(
            _maxImages,
            '$_maxImageResolution x $_maxImageResolution',
            _maxSizeInBytes.formatAsFileSize(),
          ),
          style: context.textStyleV3.captionMediumRegular.copyWith(
            color: context.colorsV3.foregroundSoft,
          ),
        ),
      ],
    );

  Future<void> _onAddImages() async {
    final picked = await ImagePicker().pickMultiImage(
      maxWidth: _maxImageResolution.toDouble(),
      maxHeight: _maxImageResolution.toDouble(),
    );

    final availableSlots = _maxImages - _images.length;
    final filtered = await _filterValidImages(picked, availableSlots);

    if (filtered.isNotEmpty) {
      setState(() => _images.addAll(filtered));
      widget.selectedImages.call(filtered);
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  Future<List<XFile>> _filterValidImages(List<XFile> images, int limit) async {
    final filtered = <XFile>[];

    for (final image in images) {
      if (filtered.length >= limit) break;

      final isValid = await _isValidImage(image.path);
      if (isValid) filtered.add(image);
    }

    return filtered;
  }

  Future<bool> _isValidImage(String path) async {
    final file = File(path);
    final size = await file.length();
    if (size > _maxSizeInBytes) {
      return false;
    }

    final dim = await _getImageDimensions(path);
    return dim.width <= _maxImageResolution && dim.height <= _maxImageResolution;
  }

  Future<Size> _getImageDimensions(String path) {
    final completer = Completer<Size>();
    final image = Image.file(File(path));
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((imageInfo, _) {
        final img = imageInfo.image;
        completer.complete(Size(img.width.toDouble(), img.height.toDouble()));
      }),
    );
    return completer.future;
  }
}
