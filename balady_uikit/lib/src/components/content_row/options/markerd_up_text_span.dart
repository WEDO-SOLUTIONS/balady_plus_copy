import 'dart:ui';

/// Describes a subset of bytes in the string text.
///
/// A set of disjoint Span in the order of their location in the text string,
/// describing the parts that match the user request.
///
/// Copy of 2GIS SDK class. Used to highlight text in [ContentRow]
class UIMarkedUpTextSpan {
  /// From what position in current text we start count.
  ///
  /// Starts from zero
  final int offset;

  /// The length of the substring with which we're working
  final int length;

  /// Highlight color
  final Color? highlightColor;

  /// Constructor
  const UIMarkedUpTextSpan({
    required this.offset,
    required this.length,
    this.highlightColor,
  });
}
