import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class NaviFindInFav extends StatelessWidget {
  const NaviFindInFav({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: Spacing.$3x),
        child: ContentWrapper(
          color: context.colorsV3.backgroundSurface1,
          children: [
            ContentRowV2(
              leading: Icon(
                SystemIcons.bookmark,
                color: context.colorsV3.accentDefault,
              ),
              trailing: ContentRowTextTrailingOptions(
                icon: SystemIcons.arrowCornerRightLarge,
                iconColor: context.colorsV3.foregroundMuted,
              ),
              text: const ContentRowTextOptions(
                title: 'Find in Favorites',
              ),
            ),
          ],
        ),
      );
}
