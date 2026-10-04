import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/features/feedback/feedback_image_error.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_selector_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_image_selector.g.dart';

@riverpod
class FeedbackImageType extends _$FeedbackImageType {
  @override
  FeedbackImageSelectorType build() => FeedbackImageSelectorType.camera;

  // ignore: avoid_setters_without_getters
  set type(FeedbackImageSelectorType value) {
    state = value;
  }
}

@riverpod
class FeedbackImageSelector extends _$FeedbackImageSelector {
  late FeedbackImageSelectorType photoSourceType = ref.read(feedbackImageTypeProvider);

  static const _maxImageResolution = 5000;

  /// JPEG quality passed to image_picker. When only `maxWidth`/`maxHeight` are
  /// given, image_picker re-encodes every picked/captured image as JPEG with
  /// quality 100, so a 12 MP camera shot easily exceeds the 5 MB limit and
  /// gets rejected by [_isValidImage] even though the original was within limits.
  static const _imageQuality = 85;

  @override
  List<XFile> build() {
    ref.listen(feedbackImageTypeProvider, (_, next) {
      photoSourceType = next;
    });

    return [];
  }

  Future<void> pickImages({
    required List<String> acceptedFormats,
    required int maxSize,
    required int maxImages,
    List<XFile> selectedImages = const [],
  }) async {
    if (await _isPermissionDenied(photoSourceType)) {
      // Throw permission error and show permission dialog
      throw FeedbackPerrmissionError();
    }

    final images = await _pickedImage(photoSourceType);
    if (images.isEmpty) {
      return;
    }

    final filteredImages = await _filterImages(
      images: images,
      selectedImages: selectedImages,
      maxSize: maxSize,
      acceptedFormats: acceptedFormats,
      maxImages: maxImages,
    );

    final value = selectedImages;

    /// avoid upload same image twice
    filteredImages.removeWhere(
      (element) => value.any(
        (element2) => element2.path == element.path,
      ),
    );

    state = [...value, ...filteredImages];

    final aliveLink = ref.keepAlive();

    Timer(const Duration(seconds: 5), () => aliveLink.close());
  }

  void reset() {
    state = [];
  }

  Future<Size> _calculateImageDimension(String imagePath) {
    final Completer<Size> completer = Completer();
    final Image image = Image.file(File(imagePath));
    image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener(
            (image, synchronousCall) {
              final myImage = image.image;
              final Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
              completer.complete(size);
            },
            // Without this a file Flutter can't decode would leave the completer
            // pending forever and the pick flow would hang silently.
            onError: (error, stackTrace) {
              if (!completer.isCompleted) {
                completer.completeError(error, stackTrace);
              }
            },
          ),
        );
    return completer.future;
  }

  Future<bool> _isValidImage(String path, {required int maxSize, List<String> acceptFormats = const []}) async {
    final fileType = path.split('.').last.toLowerCase();
    final isImageFormatAccepted = acceptFormats.isNotEmpty && acceptFormats.contains(fileType);
    final size = await File(path).length();
    final isSizeAccepted = size <= maxSize;
    final isDimAccepted = await _isDimensionAccepted(path);
    return isImageFormatAccepted && isSizeAccepted && isDimAccepted;
  }

  Future<bool> _isDimensionAccepted(String path) async {
    try {
      final dim = await _calculateImageDimension(path);
      return dim.width <= _maxImageResolution && dim.height <= _maxImageResolution;
    } catch (_) {
      // Undecodable image — treat as not matching the accepted image limits.
      return false;
    }
  }

  Future<List<XFile>> _filterImages({
    required List<XFile> images,
    required List<XFile> selectedImages,
    required int maxSize,
    required List<String> acceptedFormats,
    required int maxImages,
  }) async {
    final List<XFile> filteredImages = [];
    bool isAllImagesValid = true;
    for (final image in images) {
      final isImageValid = await _isValidImage(image.path, maxSize: maxSize, acceptFormats: acceptedFormats);
      isAllImagesValid &= isImageValid;
      if (isImageValid) {
        filteredImages.add(image);
      }
    }

    if (filteredImages.length >= maxImages - selectedImages.length) {
      filteredImages.removeRange(maxImages - selectedImages.length, filteredImages.length);
    }

    if (!isAllImagesValid) {
      throw FeedbackImageSizeError();
    }

    return filteredImages;
  }

  Future<List<XFile>> _pickFromGallery() async => ImagePicker().pickMultiImage(
    maxWidth: _maxImageResolution.toDouble(),
    maxHeight: _maxImageResolution.toDouble(),
    imageQuality: _imageQuality,
  );

  Future<List<XFile>> _pickFromCamera() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: _maxImageResolution.toDouble(),
      maxHeight: _maxImageResolution.toDouble(),
      imageQuality: _imageQuality,
    );
    if (image == null) {
      return [];
    }
    return [image];
  }

  Future<List<XFile>> _pickedImage(FeedbackImageSelectorType type) async {
    final images = switch (type) {
      FeedbackImageSelectorType.gallery => await _pickFromGallery(),
      FeedbackImageSelectorType.camera => await _pickFromCamera(),
    };

    return images;
  }

  Future<bool> _isPermissionDenied(FeedbackImageSelectorType type) async {
    final permission = await _getPermissionForType(type);

    final permissionStatus = await permission.request();

    return permissionStatus.isDenied || permissionStatus.isPermanentlyDenied;
  }

  Future<Permission> _getPermissionForType(FeedbackImageSelectorType type) async {
    switch (type) {
      case FeedbackImageSelectorType.camera:
        return Permission.camera;
      case FeedbackImageSelectorType.gallery:
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          return androidInfo.version.sdkInt <= 32 ? Permission.storage : Permission.photos;
        }
        return Permission.photos;
    }
  }
}
