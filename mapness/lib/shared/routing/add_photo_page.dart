import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/feedback/feedback_image_error.dart';
import 'package:mapness/features/feedback/feedback_image_selector.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/lib/image_denied_dialog.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_selector_sheet.dart';

@RoutePage()
class AddPhotoPage extends ConsumerWidget {
  static const _maxImages = 10;
  static const _maxSizeInBytes = 5 * 1024 * 1024; // 5MB
  static const _acceptedFormats = ['png', 'jpg', 'jpeg'];

  const AddPhotoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen(feedbackImageTypeProvider, (_, next) {})
      ..listen(feedbackImageSelectorProvider, (_, next) {});

    return FeedbackImageSelectorSheet(
      onSelect: (type) async {
        switch (type) {
          case FeedbackImageSelectorType.camera:
          case FeedbackImageSelectorType.gallery:
            await _handleCategories(ref, type!, context);
          case null:
            context.router.pop();
            return;
        }
      },
    );
  }

  Future<void> _handleCategories(
    WidgetRef ref,
    FeedbackImageSelectorType type,
    BuildContext context,
  ) async {
    try {
      ref.read(feedbackImageTypeProvider.notifier).type = type;
      await ref
          .read(feedbackImageSelectorProvider.notifier)
          .pickImages(
            acceptedFormats: _acceptedFormats,
            maxSize: _maxSizeInBytes,
            maxImages: _maxImages,
          );

      final images = ref.read(feedbackImageSelectorProvider);
      if (images.isNotEmpty) {
        context.router.pop(images);
      } else {
        context.router.pop();
      }
    } catch (e) {
      await _handleError(
        e,
        context,
        ref,
      );
    }
  }

  Future<void> _handleError(Object e, BuildContext context, WidgetRef ref) async {
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
                _maxImages.toString(),
                _maxSizeInBytes.formatAsFileSize(),
              ),
            ),
            buttonLabel: context.l10n.done,
            onRetry: () {
              Navigator.of(context).pop();
            },
            onClose: () {
              Navigator.of(context).pop(false);
            },
          ),
          onRetry: () => Future(() => Navigator.of(context).pop()),
        );
        break;
      default:
        logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
        break;
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
      backgroundColor: context.themeRead.colors.backgroundSurface1,
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
}
