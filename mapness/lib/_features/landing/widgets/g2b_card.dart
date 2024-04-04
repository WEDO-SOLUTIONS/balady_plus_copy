import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

class G2BCard extends StatelessWidget {
  const G2BCard({
    required this.title, required this.subtitle, required this.color, required this.onTap, super.key,
  });

  final String title;
  final String subtitle;
  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Text(
                  title,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .callout
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .footNote
                      .copyWith(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
