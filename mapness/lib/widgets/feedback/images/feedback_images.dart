import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/widget_label.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/feedback_image_action_error.dart';
import 'package:mapness/features/feedback/feedback_upload_image.dart';
import 'package:mapness/shared/lib/file_upload.dart';
import 'package:mapness/shared/lib/image_denied_dialog.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_widget.dart';
import 'package:mapness/widgets/feedback/images/feedback_images_action_error_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

const _imageSize = 62.0;

class FeedbackImages extends ConsumerWidget {
  final FeedbackImageInputEntity field;

  const FeedbackImages({
    required this.field,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
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
                    _AddImageButton(onTap: () async {
                      final path = await _handlePickeImage(context);
                      if (path == null) {
                        return;
                      }
                      fieldState.didChange(
                        value.add(FileUpload.init(srcPath: path)),
                      );
                    }),
                  ...value.indexed.map(
                    (indexedUpload) => FeedbackImageWidget(
                      key: ValueKey(indexedUpload),
                      imagePath: indexedUpload.$2.srcPath,
                      onRemove: () => fieldState.didChange(
                        value.removeAt(indexedUpload.$1),
                      ),
                      onUploadStatusChange: (status) {
                        final isError = status.maybeWhen(
                          clientError: (_, __) => true,
                          networkError: (_, __) => true,
                          unknownError: (_, __) => true,
                          orElse: () => false,
                        );
                        if (isError) {
                          _showImageActionErrorSheet(
                            context,
                            error: const FeedbackImageUploadFailError(),
                            onRetry: () async {
                              ref.invalidate(feedbackUploadImageProvider(
                                indexedUpload.$2.srcPath,
                              ));
                            },
                          );
                          return;
                        }
                        fieldState.didChange(
                          value.replace(indexedUpload.$1, status),
                        );
                      },
                      imageSize: _imageSize,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      );

  Future<String?> _handlePickeImage(BuildContext context) async {
    if (await _isGalleryPermissionDenied()) {
      await showPermissionDeniedDialog(context);
      return null;
    }

    final image = await _pickedImage();
    if (image == null) {
      return null;
    }
    final isSupported = await isImageSupported(
      context,
      image: image,
    );

    return isSupported ? image.path : null;
  }

  Future<bool> isImageSupported(
    BuildContext context, {
    required XFile image,
  }) async {
    final imageSize = await image.length();

    FeedbackImageActionError? error;

    if (imageSize > field.maxSize) {
      error = FeedbackImageSizeExceededError(maxFileSize: field.maxSize);
    }
    final fileType = image.path.split('.').last.toLowerCase();
    final imageFormatAccepted = field.acceptedFormats.contains(fileType);

    if (!imageFormatAccepted) {
      error = FeedbackImageWrongFormatError(
          supportedFormats: field.acceptedFormats);
    }
    if (error != null) {
      unawaited(_showImageActionErrorSheet(
        context,
        error: error,
        onRetry: () async {
          await _handlePickeImage(context);
        },
      ));
      return false;
    }

    return error == null;
  }

  Future<XFile?> _pickedImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> _showImageActionErrorSheet(
    BuildContext context, {
    required FeedbackImageActionError error,
    required AsyncCallback onRetry,
  }) async {
    final route = ModalRoute.of(context);
    if (route?.isCurrent == false) {
      return;
    }
    final needToRetry = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => FeedbackImagesActionErrorSheet(
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
