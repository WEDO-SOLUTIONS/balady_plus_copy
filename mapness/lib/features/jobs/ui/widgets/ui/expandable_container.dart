import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ExpandableContainer extends StatefulWidget {

  const ExpandableContainer({
    required this.title,
    required this.data,
    super.key,
  });
  final String title;
  final String data;

  @override
  ExpandableContainerState createState() => ExpandableContainerState();
}

class ExpandableContainerState extends State<ExpandableContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox.shrink();
    }
    final dataSplits =
        widget.data.split('\n').where((e) => e.isNotEmpty).map((e) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .apply(
                        color: context.color.text_and_icons_base_primary,
                      ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textM
                        .apply(
                          color: context.color.text_and_icons_base_primary,
                        ),
                  ),
                ),
              ],
            ),);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onTap: () => setState(() {
          isExpanded = !isExpanded;
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .accentL
                      .apply(color: context.color.text_and_icons_base_primary),
                ),
                if (widget.data.split('\n').length > 5)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            if (isExpanded) ...dataSplits else ...dataSplits.take(5),
            if (!isExpanded && widget.data.split('\n').length > 5)
              GestureDetector(
                onTap: () => setState(() {
                  isExpanded = !isExpanded;
                }),
                child: Text(
                  '...',
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .apply(
                        color: context.color.text_and_icons_base_primary,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
