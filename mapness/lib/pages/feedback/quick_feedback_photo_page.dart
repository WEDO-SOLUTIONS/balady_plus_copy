import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/feedback/feedback_image_error.dart';
import 'package:mapness/features/feedback/feedback_image_selector.dart';
import 'package:mapness/features/feedback/quick_feedback_provider.dart';
import 'package:mapness/pages/feedback/quick_feedback_page.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/int_extention.dart';
import 'package:mapness/shared/lib/image_denied_dialog.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_selector_sheet.dart';

@RoutePage()
class QuickFeedbackPhotoPage extends ConsumerWidget {
  final FeedbackObjectIdParams params;

  const QuickFeedbackPhotoPage({required this.params, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen(feedbackImageTypeProvider, (_, next) {})
      ..listen(feedbackImageSelectorProvider, (_, next) {});

    return Scaffold(
      backgroundColor: context.colors.screenOverlayDimming60,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: FeedbackImageSelectorSheet(
          onSelect: (type) async {
            if (type == null) {
              context.router.pop();
              return;
            } else {
              final provider = quickFeedbackProvider(QuickFeedbackType.addPhoto, params);
              try {
                final categories = await ref.read(provider.future);

                if (categories.isEmpty) {
                  context.router.pop();
                  return;
                }

                // Bad solution, but i don't know how to get it better
                final firstImageField = categories.first.fields.firstOrNull;

                if (firstImageField == null || firstImageField is! FeedbackImageInputEntity) {
                  context.router.pop();
                  return;
                }

                await _handleCategories(ref, type, firstImageField, context);
              } catch (e) {
                context.router.pop();
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> _handleCategories(
    WidgetRef ref,
    FeedbackImageSelectorType type,
    FeedbackImageInputEntity firstImageField,
    BuildContext context,
  ) async {
    try {
      ref.read(feedbackImageTypeProvider.notifier).type = type;
      await ref
          .read(feedbackImageSelectorProvider.notifier)
          .pickImages(
            acceptedFormats: firstImageField.acceptedFormats,
            maxSize: firstImageField.maxSize,
            maxImages: firstImageField.maxImages,
          );

      final images = ref.read(feedbackImageSelectorProvider);
      if (images.isNotEmpty) {
        await context.router.replace(
          QuickFeedbackRoute(
            type: QuickFeedbackType.addPhoto,
            params: params,
          ),
        );
      } else {
        context.router.pop();
      }
    } catch (e) {
      await _handleError(e, context, ref, firstImageField);
    }
  }

  Future<void> _handleError(
    Object e,
    BuildContext context,
    WidgetRef ref,
    FeedbackImageInputEntity firstImageField,
  ) async {
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
                firstImageField.maxImages.toString(),
                firstImageField.maxSize.formatAsFileSize(),
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
