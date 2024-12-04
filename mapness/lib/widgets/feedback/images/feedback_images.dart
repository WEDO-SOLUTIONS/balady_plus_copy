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
import 'package:mapness/entities/feedback/feedback_image_action_error.dart';
import 'package:mapness/entities/feedback/fields_entity/extentions/feedback_image_format_extention.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/lib/file_upload.dart';
import 'package:mapness/shared/lib/image_denied_dialog.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_widget.dart';
import 'package:mapness/widgets/feedback/images/feedback_images_action_error_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

const _imageSize = 62.0;
const _maxImageResolution = 5000;

class FeedbackImages extends StatelessWidget {
  final FeedbackImageInputEntity field;

  const FeedbackImages({
    required this.field,
    super.key,
  });

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
                  (fileUpload) => fileUpload is FileUploadSuccess
                      ? fileUpload.serverUrl
                      : null,
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
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (value.length < field.maxImages)
                    _AddImageButton(
                      onTap: () => _handlePickImage(context, fieldState),
                    ),
                  ...value.indexed.map(
                    (indexedUpload) => FeedbackImageWidget(
                      key: ValueKey(indexedUpload),
                      imagePath: indexedUpload.$2.srcPath,
                      onRemove: () => fieldState.didChange(
                        value.removeAt(indexedUpload.$1),
                      ),
                      onUploadStatusChange: (status) => fieldState
                          .didChange(value.replace(indexedUpload.$1, status)),
                      imageSize: _imageSize,
                    ),
                  ),
                ],
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

  Future<void> _handlePickImage(BuildContext context,
      FormFieldState<IList<FileUpload>> fieldState) async {
    if (await _isGalleryPermissionDenied()) {
      await showPermissionDeniedDialog(context);
      return;
    }

    final image = await _pickedImage();
    if (image == null) {
      return;
    }

    final pickError = await isImageSupported(
      context,
      image: image,
    );

    if (pickError != null) {
      unawaited(_showImageActionErrorSheet(
        context,
        error: pickError,
        onRetry: () => _handlePickImage(context, fieldState),
      ));
      return;
    }
    final value = fieldState.value ?? const IList.empty();

    fieldState.didChange(value.add(FileUpload.init(srcPath: image.path)));
  }

  Future<FeedbackImagePickError?> isImageSupported(
    BuildContext context, {
    required XFile image,
  }) async {
    final imageSize = await image.length();

    FeedbackImagePickError? error;

    if (imageSize > field.maxSize) {
      error = FeedbackImageSizeExceededError(maxFileSize: field.maxSize);
    }
    final fileType = image.path.split('.').last.toLowerCase();
    final imageFormatAccepted = field.acceptedFormats.isNotEmpty &&
        field.acceptedFormats.contains(fileType);

    if (!imageFormatAccepted) {
      error = FeedbackImageWrongFormatError(
          supportedFormats: field.acceptedFormats);
    }
    return error;
  }

  Future<XFile?> _pickedImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> _showImageActionErrorSheet(
    BuildContext context, {
    required FeedbackImagePickError error,
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
      builder: (_) => FeedbackImagesActionErrorSheet(
        error: error,
      ),
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
  const _AddImageButton({
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
