import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';

class FeedbackLabel extends StatelessWidget {
  final String text;
  final bool? isRequired;
  const FeedbackLabel({required this.text, this.isRequired, super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.$2x),
              child: Text(
                isRequired ?? false ? '* $text' : text,
                style: context.textStyle.caption,
              ),
            ),
          ),
        ],
      );
}
