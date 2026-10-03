import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_reviews/domain/poi_review.dart';
import 'package:mapness/features/poi_reviews/ui/poi_reviews_format.dart';
import 'package:mapness/features/poi_reviews/ui/widgets/poi_review_stars.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

const _avatarSize = 40.0;
const _photoSize = 56.0;

/// One review: author row with an optional trailing action, stars, date, text and attached photos.
class PoiReviewTile extends StatelessWidget {
  final PoiReview review;
  final Widget avatar;
  final String authorName;
  final Widget? action;

  const PoiReviewTile({
    required this.review,
    required this.avatar,
    required this.authorName,
    this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            avatar,
            const SizedBox(width: Spacing.$3x),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
                  ),
                  Text(
                    l10n.poiReviewsReviewsCount(review.authorReviewsCount),
                    style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
                  ),
                ],
              ),
            ),
            if (action != null) ...[const SizedBox(width: Spacing.$2x), action!],
          ],
        ),
        const SizedBox(height: Spacing.$4x),
        Row(
          children: [
            PoiReviewStars(rating: review.rating.toDouble()),
            const SizedBox(width: Spacing.$2x),
            Text(
              formatPoiReviewDate(review.createdAt, l10n),
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            ),
          ],
        ),
        if (review.text.isNotEmpty) ...[
          const SizedBox(height: Spacing.$1_5x),
          Text(
            review.text,
            style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
          ),
        ],
        if (review.photos.isNotEmpty) ...[
          const SizedBox(height: Spacing.$3x),
          Wrap(
            spacing: Spacing.$2x,
            runSpacing: Spacing.$2x,
            children: [
              for (final path in review.photos)
                ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusBorder.m),
                  child: Image.file(File(path), width: _photoSize, height: _photoSize, fit: BoxFit.cover),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class PoiReviewAvatar extends StatelessWidget {
  final String name;

  const PoiReviewAvatar({required this.name, super.key});

  @override
  Widget build(BuildContext context) => _AvatarCircle(
    child: Text(
      poiReviewAuthorInitials(name),
      style: context.textStyles.bodySmallSemiBold.copyWith(color: context.colors.accentDefault),
    ),
  );
}

class PoiMyAvatar extends StatelessWidget {
  const PoiMyAvatar({super.key});

  @override
  Widget build(BuildContext context) =>
      _AvatarCircle(child: Icon(SystemIcons.avatar, size: 20, color: context.colors.accentDefault));
}

class _AvatarCircle extends StatelessWidget {
  final Widget child;

  const _AvatarCircle({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: _avatarSize,
    height: _avatarSize,
    alignment: Alignment.center,
    decoration: BoxDecoration(shape: BoxShape.circle, color: context.colors.accentContainerDefault),
    child: child,
  );
}

/// Green text-only action used for "Edit" and "Add friend".
class PoiReviewTextAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const PoiReviewTextAction({required this.label, this.onTap, super.key});

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusBorder.m),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$1x),
        child: Text(
          label,
          style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.accentDefault),
        ),
      ),
    ),
  );
}
