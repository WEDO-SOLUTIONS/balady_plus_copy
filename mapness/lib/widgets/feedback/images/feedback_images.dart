import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/widget_label.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/extentions/feedback_image_format_extention.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/lib/file_upload.dart';
import 'package:mapness/shared/lib/image_denied_dialog.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../shared/ui/error_widget/base_error_widget.dart';

const _maxImageResolution = 5000;
const _minPhotoWidth = 100;
const _photoPadding = 8.0;

class FeedbackImages extends StatelessWidget {
  final FeedbackImageInputEntity field;

  const FeedbackImages({
    required this.field,
    super.key,
  });

  Future<Size> _calculateImageDimension(String imagePath) {
    final Completer<Size> completer = Completer();
    final Image image = Image.file(File(imagePath));
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (image, synchronousCall) {
          final myImage = image.image;
          final Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: WidgetLabel(
                  isRequired: field.isRequired,
                  label: field.label,
                  labelStyle: context.textStyleV3.captionMediumRegular.copyWith(
                    color: context.colorsV2.foregroundDefault,
                  ),
                ),
              ),
            ],
          ),
          FormBuilderField<IList<FileUpload>>(
            name: field.id,
            valueTransformer: (value) => value
                ?.map(
                  (fileUpload) => fileUpload is FileUploadSuccess ? fileUpload.serverUrl : null,
                )
                .nonNulls
                .toList(),
            validator: (value) {
              /// check does field has value
              if (value == null || value.isEmpty) {
                return field.isRequired ? 'NEED PHOTOS' : null;
              }

              /// check are all fields uploaded
              if (value.every((fu) => fu is FileUploadSuccess)) {
                return null;
              }
              return 'UPLOAD NOT FINISHED';
            },
            builder: (fieldState) {
              final value = fieldState.value ?? const IList.empty();

              return LayoutBuilder(
                builder: (context, constraints) {
                  final imagesInRow =
                      ((constraints.maxWidth + _photoPadding) / (_minPhotoWidth + _photoPadding)).floor();
                  final size = (constraints.maxWidth + _photoPadding) / imagesInRow - _photoPadding;

                  return Wrap(
                    spacing: _photoPadding,
                    runSpacing: _photoPadding,
                    children: [
                      if (value.length < field.maxImages)
                        _AddImageButton(
                          onTap: () => _handlePickImage(context, fieldState),
                          size: size,
                        ),
                      ...value.indexed.map(
                        (indexedUpload) => FeedbackImageWidget(
                          key: ValueKey(indexedUpload),
                          imagePath: indexedUpload.$2.srcPath,
                          onRemove: () => fieldState.didChange(
                            value.removeAt(indexedUpload.$1),
                          ),
                          onUploadStatusChange: (status) =>
                              fieldState.didChange(value.replace(indexedUpload.$1, status)),
                          imageSize: size,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Spacing.$2x.heightBox,
          Text(
            context.l10n.feedbackImageVadidationDiscription(
              field.maxImages,
              _maxImageResolution,
              _maxImageResolution,
              field.maxSize.formatAsFileSize(),
              field.acceptedFormats.formatAcceptedFormats(context.l10n),
            ),
            style: context.textStyleV3.captionMediumRegular.copyWith(
              color: context.colorsV2.foregroundSoft,
            ),
          ),
        ],
      );

  Future<void> _handlePickImage(BuildContext context, FormFieldState<IList<FileUpload>> fieldState) async {
    if (await _isGalleryPermissionDenied()) {
      await showPermissionDeniedDialog(context);
      return;
    }
    final images = await _pickedImage(limit: field.maxImages);
    if (images.isEmpty) {
      return;
    }

    final filteredImages = await filterImages(context, images: images, fieldState: fieldState);
    final value = fieldState.value ?? const IList.empty();
    fieldState.didChange(
      value.addAll(
        filteredImages.map(
          (image) => FileUpload.init(srcPath: image.path),
        ),
      ),
    );
  }

  Future<bool> isValidImage(String path) async {
    final fileType = path.split('.').last.toLowerCase();
    final isImageFormatAccepted = field.acceptedFormats.isNotEmpty && field.acceptedFormats.contains(fileType);
    final size = await File(path).length();
    final isSizeAccepted = size <= field.maxSize;
    final dim = await _calculateImageDimension(path);
    final isDimAccepted = dim.width <= _maxImageResolution && dim.height <= _maxImageResolution;
    return isImageFormatAccepted && isSizeAccepted && isDimAccepted;
  }

  Future<List<XFile>> filterImages(BuildContext context,
      {required List<XFile> images, required FormFieldState<IList<FileUpload>> fieldState}) async {
    final List<XFile> filteredImages = [];
    bool isAllImagesValid = true;
    for (final image in images) {
      final isImageValid = await isValidImage(image.path);
      isAllImagesValid &= isImageValid;
      if (isImageValid) {
        filteredImages.add(image);
      }
    }

    if (filteredImages.length > field.maxImages) {
      filteredImages.removeRange(field.maxImages, filteredImages.length);
    }

    if (!isAllImagesValid) {
      unawaited(
        _showImageActionErrorSheet(
          context,
          error: BaseErrorWidget(
            errorLabel: context.l10n.feedbackImageSizeExceedFailure(
              field.maxSize.formatAsFileSize(),
            ),
            buttonLabel: context.l10n.done,
            onRetry: () {
              Navigator.of(context).pop(true);
            },
          ),
          // FeedbackImageSizeExceededError(maxFileSize: field.maxSize),
          onRetry: () => _handlePickImage(context, fieldState),
        ),
      );
    }
    return filteredImages;
  }

  Future<List<XFile>> _pickedImage({int? limit}) async {
    final images = await ImagePicker().pickMultiImage(
        maxWidth: _maxImageResolution.toDouble(), maxHeight: _maxImageResolution.toDouble(), limit: limit);

    return images;
  }

  Future<void> _showImageActionErrorSheet(
    BuildContext context, {
    required Widget error,
    required AsyncCallback onRetry,
  }) async {
    final route = ModalRoute.of(context);
    if (route?.isCurrent == false) {
      return;
    }
    final needToRetry = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusBorder.l),
        ),
      ),
      builder: (_) => error,
    );
    if (needToRetry ?? false) {
      await onRetry();
    }
  }

  Future<bool> _isGalleryPermissionDenied() async {
    final Permission permission;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permission = Permission.storage;
      } else {
        permission = Permission.photos;
      }
    } else {
      permission = Permission.photos;
    }

    final permissionStatus = await permission.request();
    return permissionStatus.isDenied || permissionStatus.isPermanentlyDenied;
  }
}

class _AddImageButton extends StatelessWidget {
  final void Function() onTap;
  final double size;

  const _AddImageButton({
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.l),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RadiusBorder.l),
          child: SizedBox(
            height: size,
            width: size,
            child: ColoredBox(
              color: context.colorsV2.backgroundSurface1,
              child: Center(
                child: Icon(
                  GeneralIcons.plusCircle,
                  color: context.colorsV2.accentDefault,
                  size: size * .4,
                ),
              ),
            ),
          ),
        ),
      );
}
