import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/extentions/feedback_image_format_extention.dart';
import 'package:mapness/features/feedback/feedback_image_error.dart';
import 'package:mapness/features/feedback/feedback_image_selector.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/lib/file_upload.dart';
import 'package:mapness/shared/lib/image_denied_dialog.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/feedback/images/add_image_button.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_selector_sheet.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_widget.dart';

const _maxImageResolution = 5000;
const _minPhotoWidth = 100;
const _photoPadding = 8.0;

class FeedbackImages extends StatelessWidget {
  final FeedbackImageInputEntity field;

  final GlobalKey<FormFieldState<IList<FileUpload>>> fieldKey = GlobalKey<FormFieldState<IList<FileUpload>>>();

  FeedbackImages({required this.field, super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Consumer(
        builder: (context, ref, _) {
          ref.listen(feedbackImageSelectorProvider, (_, next) {
            final oldValue = fieldKey.currentState?.value ?? const IList.empty();
            final newValue = next.map((newXFile) {
              final existing = oldValue.firstWhereOrNull((f) => f.srcPath == newXFile.path);
              return existing ?? FileUpload.init(srcPath: newXFile.path);
            }).toIList();
            fieldKey.currentState?.didChange(newValue);
          });
          return FormBuilderField<IList<FileUpload>>(
            key: fieldKey,
            name: field.id,
            initialValue: ref
                .read(feedbackImageSelectorProvider)
                .map((e) => FileUpload.init(srcPath: e.path))
                .toIList(),
            valueTransformer: (value) => value
                ?.map((fileUpload) => fileUpload is FileUploadSuccess ? fileUpload.serverUrl : null)
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

              // Recreate
              return LayoutBuilder(
                builder: (context, constraints) {
                  final imagesInRow = ((constraints.maxWidth + _photoPadding) / (_minPhotoWidth + _photoPadding))
                      .floor();
                  final size = (constraints.maxWidth + _photoPadding) / imagesInRow - _photoPadding;

                  return Wrap(
                    spacing: _photoPadding,
                    runSpacing: _photoPadding,
                    children: [
                      if (value.length < field.maxImages)
                        AddImageButton(onTap: () => _showImageSelectorDialog(context, ref), size: size),
                      ...value.indexed.map(
                        (indexedUpload) => FeedbackImageWidget(
                          key: ValueKey(indexedUpload),
                          imagePath: indexedUpload.$2.srcPath,
                          onRemove: () => fieldState.didChange(value.removeAt(indexedUpload.$1)),
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
          );
        },
      ),
      Spacing.$2x.heightBox,
      Text(
        context.digits(
          context.l10n.feedbackImageVadidationDiscription(
            field.maxImages,
            _maxImageResolution,
            _maxImageResolution,
            field.maxSize.formatAsFileSize(),
            field.acceptedFormats.formatAcceptedFormats(context.l10n),
          ),
        ),
        style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
      ),
    ],
  );

  Future<void> _showImageSelectorDialog(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      showDragHandle: false,
      builder: (context) => const FeedbackImageSelectorSheet(),
    );

    if (result == null) {
      return;
    }

    ref.read(feedbackImageTypeProvider.notifier).type = result;

    try {
      // Get previous selected images
      final selectedImages = (fieldKey.currentState?.value ?? const IList.empty())
          .map((e) => XFile(e.srcPath))
          .toList();

      await ref
          .read(feedbackImageSelectorProvider.notifier)
          .pickImages(
            acceptedFormats: field.acceptedFormats,
            maxSize: field.maxSize,
            maxImages: field.maxImages,
            selectedImages: selectedImages,
          );
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (e) {
      switch (e) {
        case FeedbackPerrmissionError():
          await showPermissionDeniedDialog(context, ref.read(feedbackImageTypeProvider));
          break;
        case FeedbackImageSizeError():
          await _showImageActionErrorSheet(
            context,
            error: BaseErrorWidget(
              errorTitle: context.l10n.photoLimitExceeded,
              errorLabel: context.digits(
                context.l10n.feedbackImageLimitsError(
                  field.maxImages.toString(),
                  field.maxSize.formatAsFileSize(),
                ),
              ),
              buttonLabel: context.l10n.tryAgain,
              onRetry: () {
                Navigator.of(context).pop(true);
              },
              onClose: () {
                Navigator.of(context).pop(false);
              },
            ),
            onRetry: () => _showImageSelectorDialog(context, ref),
          );
          break;
        default:
          logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
          break;
      }
    }
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusBorder.l))),
      builder: (_) => error,
    );
    if (needToRetry ?? false) {
      await onRetry();
    }
  }
}
