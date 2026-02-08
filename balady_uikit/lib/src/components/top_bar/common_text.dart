import 'package:flutter/material.dart';

/// A [ActionText] is a text widget that is used in the [Leading] and [Trailing] widgets.
/// This widget set base common behavior for the text.
/// Is not a part of 'top_bar.dart' file because we need to use it in other places.
/// Should not be used directly and be added to library.
class ActionText extends StatelessWidget {
  /// The [text] is the String text.
  final String text;

  /// The [textStyle] is the TextStyle for the text.
  final TextStyle textStyle;

  /// Main constructor for the [ActionText] widget.
  const ActionText({
    required this.text,
    required this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Flexible(
        child: Text(
          text,
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
}
