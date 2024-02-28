import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class Description extends StatelessWidget {
  const Description({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => CardContent(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.about,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()
                  ?.textM
                  .copyWith(
                    color: context.color.text_and_icons_base_primary,
                    height: 1.5,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()
                  ?.textS
                  .copyWith(
                    color: context.color.text_and_icons_base_tertiary,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
}
