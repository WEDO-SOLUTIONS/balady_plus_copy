import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

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
    final dataSplits = widget.data.split('\n').where((e) => e.isNotEmpty).map(
          (e) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '•',
                style: context.textStyle.text.apply(
                  color: context.color.textAndIconsBasePrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  e,
                  style: context.textStyle.text.apply(
                    color: context.color.textAndIconsBasePrimary,
                  ),
                ),
              ),
            ],
          ),
        );
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
                  style: context.textStyle.heading2.apply(color: context.color.textAndIconsBasePrimary),
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
                  style: context.textStyle.text.apply(
                    color: context.color.textAndIconsBasePrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
