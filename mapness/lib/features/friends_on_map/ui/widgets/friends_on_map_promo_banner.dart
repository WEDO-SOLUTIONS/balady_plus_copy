import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Decorative header on the friend list (S-11) — this screen is already the
/// destination the copy describes, so it's non-interactive. The background
/// is the exact Figma-exported illustration (a static map photo with two
/// location-pin markers baked in, node `492:10471`, downloaded via the
/// Figma MCP's `download_assets`) — not one of this app's generic
/// `lightMapPreview`/`darkMapPreview` assets, which don't match the design
/// and have no equivalent markers. Single static image, no dark variant.
class FriendsOnMapPromoBanner extends StatelessWidget {
  const FriendsOnMapPromoBanner({super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(RadiusBorder.xl),
    child: SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Edge-to-edge, no padding — only the text below is padded
          // relative to this image, matching the Figma layer's own
          // `inset-0` background vs. its padded text row.
          Positioned.fill(
            child: Assets.images.friendsOnMapPromoBackground.image(
              fit: BoxFit.fitWidth,
              alignment: const Alignment(0, -0.47),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
            child: FractionallySizedBox(
              // Figma caps this column at ~56% of the card's width (191px
              // of 343px) so the subtitle wraps to 2-3 lines instead of one
              // wide line — that wrapping is what gives the banner its real
              // height and keeps the photo's marker clear of the text.
              widthFactor: 0.56,
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.friendsOnMapTitle,
                    style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                  ),
                  const SizedBox(height: Spacing.$1x),
                  Text(
                    context.l10n.friendListPromoSubtitle,
                    style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.accentActive),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
