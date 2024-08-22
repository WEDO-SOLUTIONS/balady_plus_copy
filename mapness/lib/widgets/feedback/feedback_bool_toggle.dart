import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';

class FeedbackBusinessOwner extends StatelessWidget {
  final void Function(bool) onChanged;
  final bool value;
  const FeedbackBusinessOwner({required this.onChanged, required this.value, super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: context.colorsV2.borderMuted,
          ),
          Spacing.$4x.heightBox,
          Row(
            children: [
              Expanded(
                child: Text(
                  'Business owner',
                  style: context.textStyleV3.bodyLargeRegular,
                ),
              ),
              Toggle(value: value, onChanged: onChanged),
            ],
          ),
          Spacing.$4x.heightBox,
          Divider(
            height: 1,
            thickness: 1,
            color: context.colorsV2.borderMuted,
          ),
        ],
      );
}
