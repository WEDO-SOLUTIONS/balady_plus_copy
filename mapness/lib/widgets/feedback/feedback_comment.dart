import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';

class FeedbackComment extends StatelessWidget {
  final void Function(String)? onChanged;
  const FeedbackComment({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) => BaladyInput(
        labelText: 'Comment',
        hintText: 'Add extra information',
        labelStyle: context.textStyleV3.captionMediumRegular,
        fillColor: context.colorsV2.backgroundSurface1,
        onChanged: onChanged,
      );
}
