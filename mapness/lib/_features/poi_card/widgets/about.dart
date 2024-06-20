import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class About extends StatefulWidget {
  const About({
    required this.onEntranceTap,
    required this.title,
    required this.exits,
    super.key,
  });

  final String title;
  final int? exits;
  final Function() onEntranceTap;

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) => CardContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            if (widget.exits != null && widget.exits != 0) ...[
              const SizedBox(height: 8),
              Material(
                color: context.color.textAndIconsBasePrimary.withAlpha(10),
                borderRadius: borderRadius,
                child: InkWell(
                  onTap: widget.onEntranceTap,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: borderRadius,
                    ),
                    child: Text(
                      '${context.l10n.exits} ${widget.exits ?? ''}',
                      style: context.textStyle.footNoteBold.copyWith(color: context.color.textAndIconsBasePrimary),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}
