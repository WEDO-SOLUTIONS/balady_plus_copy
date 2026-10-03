import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/poi_reviews/domain/poi_review.dart';
import 'package:mapness/features/poi_reviews/state/poi_reviews_providers.dart';
import 'package:mapness/features/poi_reviews/ui/poi_reviews_toast.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_my_review_card.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_rate_card.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_review_tile.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_reviews_summary_view.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Content of the POI card "Reviews" tab.
class PoiReviewsSliver extends ConsumerStatefulWidget {
  final int objectId;
  final String poiName;

  const PoiReviewsSliver({required this.objectId, required this.poiName, super.key});

  @override
  ConsumerState<PoiReviewsSliver> createState() => _PoiReviewsSliverState();
}

class _PoiReviewsSliverState extends ConsumerState<PoiReviewsSliver> {
  bool _isListExpanded = true;
  bool _isLoadingMore = false;

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(poiReviewsSummaryProvider(widget.objectId));
    final myReview = ref.watch(poiMyReviewProvider(widget.objectId));

    final Widget content;
    if ((summary.hasError && !summary.hasValue) || (myReview.hasError && !myReview.hasValue)) {
      content = _ErrorView(
        onRetry: () => ref
          ..invalidate(poiReviewsSummaryProvider(widget.objectId))
          ..invalidate(poiMyReviewProvider(widget.objectId)),
      );
    } else if (!summary.hasValue || !myReview.hasValue) {
      content = const _LoadingView();
    } else {
      content = _buildContent(summary.requireValue, myReview.value);
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
      sliver: SliverToBoxAdapter(child: content),
    );
  }

  Widget _buildContent(PoiReviewsSummary summary, PoiReview? myReview) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (summary.ratingsCount > 0) ...[
        PoiReviewsSummaryView(summary: summary),
        const SizedBox(height: Spacing.$6x),
      ],
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: myReview == null
            ? PoiRateCard(onRate: (rating) => _openRateSheet(rating: rating))
            : PoiMyReviewCard(
                review: myReview,
                onEdit: () => _openRateSheet(review: myReview),
              ),
      ),
      const SizedBox(height: Spacing.$6x),
      if (summary.reviewsCount == 0)
        const _EmptyView()
      else ...[
        _ListHeader(
          reviewsCount: summary.reviewsCount,
          isExpanded: _isListExpanded,
          onTap: () => setState(() => _isListExpanded = !_isListExpanded),
        ),
        if (_isListExpanded) _buildFeed(),
      ],
    ],
  );

  Widget _buildFeed() {
    final feed = ref.watch(poiReviewsFeedProvider(widget.objectId));
    if (feed.hasError && !feed.hasValue) {
      return _ErrorView(onRetry: () => ref.invalidate(poiReviewsFeedProvider(widget.objectId)));
    }
    final page = feed.value;
    if (page == null) {
      return const _LoadingView();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: Spacing.$4x),
            decoration: BoxDecoration(
              color: context.colors.backgroundSurface1,
              borderRadius: BorderRadius.circular(RadiusBorder.xl),
            ),
            child: Column(
              children: [
                for (final review in page.items)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Spacing.$4x, Spacing.$4x, Spacing.$4x, Spacing.$2x),
                    child: PoiReviewTile(
                      review: review,
                      avatar: PoiReviewAvatar(name: review.authorName),
                      authorName: review.authorName,
                      // Social graph doesn't exist yet: the action is a stub.
                      action: PoiReviewTextAction(label: context.l10n.poiReviewsAddFriend, onTap: () {}),
                    ),
                  ),
              ],
            ),
          ),
          if (page.hasMore)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.$3x),
              child: _isLoadingMore
                  ? Loading.small()
                  : PoiReviewTextAction(label: context.l10n.showMore, onTap: _loadMore),
            ),
        ],
      ),
    );
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) {
      return;
    }
    setState(() => _isLoadingMore = true);
    try {
      await ref.read(poiReviewsFeedProvider(widget.objectId).notifier).loadMore();
    } catch (e) {
      logger.log('POI reviews page load failed: $e', logLevel: MapnessLogLevel.error);
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _openRateSheet({int rating = 0, PoiReview? review}) async {
    final saved = await context.router.push<bool>(
      PoiRateSheetRoute(objectId: widget.objectId, poiName: widget.poiName, initialRating: rating, review: review),
    );
    if (saved != true) {
      return;
    }
    showRootToast(
      (toast, context) => toast.show(
        title: context.l10n.poiReviewsRatedToast,
        icon: ToastIconData(General16Icons.starSolid, color: context.colors.warningDefault),
        actions: [ToastAction(title: context.l10n.feedbackBreaksSheetClose)],
        displayDuration: const Duration(seconds: 4),
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  final int reviewsCount;
  final bool isExpanded;
  final VoidCallback onTap;

  const _ListHeader({required this.reviewsCount, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.$4x, 0, Spacing.$4x, Spacing.$3x),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.poiReviewsReviewsCount(reviewsCount),
              style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
            ),
          ),
          Icon(
            isExpanded ? SystemIcons.arrowCornerUpSmall : SystemIcons.arrowCornerDownSmall,
            color: context.colors.foregroundMuted,
          ),
        ],
      ),
    ),
  );
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$6x),
    child: Center(child: Loading.medium()),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.$4x),
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface1,
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
      ),
      child: Text(
        context.l10n.poiReviewsEmpty,
        textAlign: TextAlign.center,
        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
      ),
    ),
  );
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: Column(
      children: [
        Text(
          context.l10n.poiReviewsLoadError,
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
        ),
        const SizedBox(height: Spacing.$3x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.neutral,
          primaryLabel: context.l10n.tryAgain,
          onTap: onRetry,
        ),
      ],
    ),
  );
}
