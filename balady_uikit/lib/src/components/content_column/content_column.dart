import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';

class ContentColumn extends StatelessWidget {
  final String headerTitle;
  final List<Widget> content;

  const ContentColumn({
    required this.headerTitle,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Text(
            headerTitle,
            style: context.textStyles.captionLargeRegular.copyWith(
              color: context.colors.foregroundMuted,
            ),
          ),
        ),
        Spacing.$1x.heightBox,
        ...content,
      ],
    );
  }
}
