import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/poi_reviews/domain/poi_review.dart';
import 'package:mapness/features/poi_reviews/state/poi_reviews_providers.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';
import 'package:mapness/widgets/feedback/images/add_image_button.dart';
import 'package:mapness/widgets/feedback/images/feedback_image_preview.dart';
import 'package:sheetify/sheetify.dart';

const _maxImages = 10;
const _imageSize = 62.0;

/// Rate & review sheet of a POI; pops `true` once the review is saved.
@RoutePage()
class PoiRateSheetPage extends ConsumerStatefulWidget {
  final int objectId;
  final String poiName;
  final int initialRating;

  /// Existing review of the user, opened for editing.
  final PoiReview? review;

  const PoiRateSheetPage({
    required this.objectId,
    required this.poiName,
    this.initialRating = 0,
    this.review,
    super.key,
  });

  @override
  ConsumerState<PoiRateSheetPage> createState() => _PoiRateSheetPageState();
}

class _PoiRateSheetPageState extends ConsumerState<PoiRateSheetPage> {
  late final ToggleSheetController _sheetController;
  late final TextEditingController _textController;
  late int _rating;
  late List<String> _imagePaths;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _sheetController = ToggleSheetController(onClose: (_) => context.router.pop());
    final review = widget.review;
    _rating = review?.rating ?? widget.initialRating;
    _textController = TextEditingController(text: review?.text ?? '');
    _imagePaths = [...?review?.photos];
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ToggleSheet(
    scrollController: _sheetController,
    backgroundColor: context.colors.backgroundSurface4,
    safeAreaColor: context.colors.backgroundSurface4,
    dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
    header: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              widget.poiName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
            ),
          ),
          const SizedBox(width: Spacing.$3x),
          CustomCloseButton(padding: EdgeInsets.zero, onClose: () => context.router.pop()),
        ],
      ),
    ),
    content: [
      Padding(
        padding: const EdgeInsets.all(Spacing.$4x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: RatingBar(rating: _rating, onRatingChanged: (value) => setState(() => _rating = value as int)),
            ),
            const SizedBox(height: Spacing.$4x),
            _buildTextInput(),
            const SizedBox(height: Spacing.$4x),
            Text(
              context.l10n.images,
              style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundDefault),
            ),
            const SizedBox(height: Spacing.$2x),
            Wrap(
              spacing: Spacing.$2x,
              runSpacing: Spacing.$2x,
              children: [
                if (_imagePaths.length < _maxImages) AddImageButton(onTap: _pickImages, size: _imageSize),
                for (final path in _imagePaths)
                  FeedbackImagePreview(
                    key: ValueKey(path),
                    imagePath: path,
                    imageSize: _imageSize,
                    onRemove: () => setState(() => _imagePaths = [..._imagePaths]..remove(path)),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.$3x),
            Text(
              context.l10n.poiReviewsPhotosLimit(_maxImages),
              style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
            ),
          ],
        ),
      ),
    ],
    footer: Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.$4x, 0, Spacing.$4x, Spacing.$4x),
      child: SizedBox(
        width: double.infinity,
        child: AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.save,
          buttonState: switch ((_rating, _isSaving)) {
            (0, _) => ButtonState.disabled,
            (_, true) => ButtonState.loading,
            _ => ButtonState.defaultState,
          },
          onTap: _save,
        ),
      ),
    ),
  );

  // Same pattern as Send Feedback: the field is a preview, typing happens in AppFeedbackInputSheet.
  Widget _buildTextInput() => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 85),
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result = await context.router.push(
          AppFeedbackInputSheet(initialText: _textController.text),
        );
        if (result is String && mounted) {
          setState(() => _textController.text = result);
        }
      },
      child: IgnorePointer(
        child: BaladyTextInput(
          inputStyle: BaladyInputStyle.multiline,
          controller: _textController,
          config: BaladyInputConfig(
            maxLines: 4,
            hintText: context.l10n.poiReviewsInputHint,
            fillColor: context.colors.neutralContainerDefault,
          ),
        ),
      ),
    ),
  );

  Future<void> _pickImages() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await context.router.push<List<XFile>>(const AddPhotoRoute());
    if (picked == null || picked.isEmpty || !mounted) {
      return;
    }
    final newPaths = picked.map((file) => file.path).where((path) => !_imagePaths.contains(path));
    setState(() => _imagePaths = [..._imagePaths, ...newPaths].take(_maxImages).toList());
  }

  Future<void> _save() async {
    if (_rating == 0 || _isSaving) {
      return;
    }
    setState(() => _isSaving = true);
    try {
      await ref
          .read(poiMyReviewProvider(widget.objectId).notifier)
          .save(MyReviewDraft(rating: _rating, text: _textController.text, imagePaths: _imagePaths));
      if (mounted) {
        context.router.pop(true);
      }
    } catch (e) {
      logger.log('POI review save failed: $e', logLevel: MapnessLogLevel.error);
      if (mounted) {
        ToastOverlay.of(context).showBaseError(onRetry: _save);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
