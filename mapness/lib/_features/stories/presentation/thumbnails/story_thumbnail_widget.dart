import 'package:balady_uikit/colors/app_color_scheme.dart';
import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/_features/common/image/loading_image/loading_shimmer_image.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class StoryThumbnailWidget extends ConsumerWidget {

  const StoryThumbnailWidget({
    required this.onPress, required this.title, required this.imageUrl, required this.isWatched, super.key,
  });
  final String title;
  final String imageUrl;
  final bool isWatched;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorSchemeType = ref.watch(colorSchemeProvider);

    return InkWell(
      onTap: onPress,
      child: AspectRatio(
        aspectRatio: 98 / 112,
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                color: isWatched
                    ? Colors.transparent
                    : context.color.stroke_accent,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 0.50, color: NonThemeColor.color6),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  // TODO: avoid cliprrect
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: LoadingShimmerImage(
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 8,
                    right: 8,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(13),
                      top: Radius.circular(4),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: switch (colorSchemeType) {
                          AppColorScheme.brown => [
                              NonThemeColor.colorBgStories,
                              NonThemeColor.colorBgStories2,
                            ],
                          AppColorScheme.main => [
                              NonThemeColor.color55.withOpacity(0),
                              NonThemeColor.color56.withOpacity(0.66),
                            ],
                        },),
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      Text(
                        title,
                        // TODO: move to theme
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentS
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
