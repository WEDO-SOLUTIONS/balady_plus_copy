import 'package:flutter/material.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class About extends StatelessWidget {
  const About({required this.text, super.key});

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
                style: context.textStyle.callout.copyWith(
                  color: context.color.textAndIconsBasePrimary,
                  height: 1.5,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                text,
                style: context.textStyle.footNote.copyWith(
                  color: context.color.textAndIconsBasePrimary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
}
