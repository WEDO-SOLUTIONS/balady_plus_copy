import 'dart:ui';

extension StringExt on String {
  // Replaces all localazy '\n' with new lines character
  String get multilines => replaceAll(r'\n', '\n');

  /// Truncates the string to [maxLength] characters, adding "..." if truncated.
  String truncateWithEllipsis({int maxLength = 40}) {
    final text = trim();
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  String get skipMultilines => replaceAll(r'\n', '');

  DateTime? get dateTime {
    if (isEmpty) {
      return null;
    }
    return DateTime.tryParse(this);
  }

  String get reversed => split('').reversed.join();

  /// Breaks text into multiple lines for marker labels, respecting word boundaries.
  ///
  /// - [maxCharsPerLine]: Target maximum characters per line (default 40)
  /// - [maxLines]: Maximum number of lines to return (default 2)
  ///
  /// The method will:
  /// 1. Try to break at word boundaries (spaces)
  /// 2. Only break mid-word if a single word exceeds maxCharsPerLine
  /// 3. Truncate with "..." if text exceeds maxLines
  String? breakMarkerLabel({int maxCharsPerLine = 40, int maxLines = 2}) {
    final text = trim();
    if (text.isEmpty) {
      return null;
    }

    // If text fits in one line, return as-is
    if (text.length <= maxCharsPerLine) {
      return text;
    }

    final words = text.split(' ');
    final lines = <String>[];
    var currentLine = StringBuffer();

    for (var i = 0; i < words.length; i++) {
      final word = words[i];

      // If current line is empty, add the word (even if it's too long)
      if (currentLine.isEmpty) {
        // Handle words longer than maxCharsPerLine
        if (word.length > maxCharsPerLine) {
          // Break long word with hyphen
          currentLine
            ..write(word.substring(0, maxCharsPerLine - 1))
            ..write('-');
          lines.add(currentLine.toString());
          currentLine = StringBuffer();
          // Add remaining part as next word to process
          final remaining = word.substring(maxCharsPerLine - 1);
          words.insert(i + 1, remaining);
        } else {
          currentLine.write(word);
        }
      }
      // Check if adding this word would exceed the limit
      else if (currentLine.length + 1 + word.length <= maxCharsPerLine) {
        currentLine
          ..write(' ')
          ..write(word);
      }
      // Need to start a new line
      else {
        lines.add(currentLine.toString());
        currentLine = StringBuffer();

        // Check if we've reached max lines
        if (lines.length >= maxLines) {
          // Add ellipsis to last line if there's more content
          final lastLine = lines.last;
          if (lastLine.length > maxCharsPerLine - 3) {
            lines[lines.length - 1] = '${lastLine.substring(0, maxCharsPerLine - 3)}...';
          } else {
            lines[lines.length - 1] = '$lastLine...';
          }
          return lines.join('\n');
        }

        // Handle words longer than maxCharsPerLine
        if (word.length > maxCharsPerLine) {
          currentLine
            ..write(word.substring(0, maxCharsPerLine - 1))
            ..write('-');
          lines.add(currentLine.toString());
          currentLine = StringBuffer();
          final remaining = word.substring(maxCharsPerLine - 1);
          words.insert(i + 1, remaining);
        } else {
          currentLine.write(word);
        }
      }
    }

    // Add remaining content
    if (currentLine.isNotEmpty) {
      if (lines.length >= maxLines) {
        // Already at max lines, add ellipsis to last line
        final lastLine = lines.last;
        if (!lastLine.endsWith('...')) {
          if (lastLine.length > maxCharsPerLine - 3) {
            lines[lines.length - 1] = '${lastLine.substring(0, maxCharsPerLine - 3)}...';
          } else {
            lines[lines.length - 1] = '$lastLine...';
          }
        }
      } else {
        lines.add(currentLine.toString());
      }
    }

    return lines.join('\n');
  }
}

extension StringNullableExt on String? {
  bool containsArabic() {
    final text = this;
    if (text == null) {
      return false;
    }
    // Regular expression for checking Arabic characters
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F]');
    return arabicRegex.hasMatch(text);
  }
}

extension HexColor on String {
  Color? toColor() {
    final intValue = int.tryParse(this, radix: 16);
    if (intValue != null) {
      return Color(0xFF000000 + intValue);
    }
    return null;
  }
}
