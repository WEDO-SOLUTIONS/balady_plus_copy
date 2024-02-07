import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class About extends StatefulWidget {
  final DirectoryObjectMessage? data;

  final Function() onEntranceTap;

  const About(this.data, {super.key, required this.onEntranceTap});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int? exits;

  @override
  void initState() {
    exits = widget.data?.entrances.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final entrances = data?.entrances;
    return CardContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            data?.address?.buildingName ?? data?.title ?? '',
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textM
                .copyWith(color: colorPrimary),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 8,
          ),
          // Text(
          //   data!.makeAddress(),
          //   style: Theme.of(context)
          //       .extension<ThemeTextStyles>()!
          //       .textS
          //       .copyWith(color: colorPrimary),
          //   maxLines: 5,
          //   textAlign: TextAlign.start,
          // ),
          if (entrances != null && entrances.isNotEmpty) ...[
            const SizedBox(
              height: 8,
            ),
            Material(
              color: colorPrimary.withAlpha(10),
              borderRadius: borderRadius,
              child: InkWell(
                onTap: widget.onEntranceTap,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: boxDecoration(),
                  child: Text(
                    '${context.l10n.exits} ${exits ?? ''}',
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .accentS
                        .copyWith(color: colorPrimary),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
