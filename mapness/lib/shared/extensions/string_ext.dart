extension StringExt on String {
  // Replaces all localazy '\n' with new lines character
  String get multilines => replaceAll(r'\n', '\n');

  String get skipMultilines => replaceAll(r'\n', '');

  DateTime? get dateTime {
    if (isEmpty) {
      return null;
    }
    return DateTime.tryParse(this);
  }

  String get reversed => split('').reversed.join();

  String? breakMarkerLabel({int maxCharsPerLine = 40}) {
    final text = trim();
    if (text.isEmpty) {
      return null;
    }

    final buffer = StringBuffer();
    int start = 0;

    while (start < text.length) {
      // Set initial end of line candidate
      int end = (start + maxCharsPerLine < text.length) ? start + maxCharsPerLine : text.length;

      if (end < text.length) {
        // Try to find a space within 2 characters to the right
        final int spaceRight = text.indexOf(' ', end);
        if (spaceRight != -1 && spaceRight - end <= 2) {
          end = spaceRight;
        } else {
          // If not found, try to find a space within 2 characters to the left
          final int spaceLeft = text.lastIndexOf(' ', end);
          if (spaceLeft != -1 && end - spaceLeft <= 2) {
            end = spaceLeft;
          }
        }
      }

      // Add the substring to the buffer, trimming leading/trailing spaces
      final line = text.substring(start, end).trim();
      buffer.write(line);
      if (end < text.length) {
        buffer.write('\n');
      }

      // Move start to the next character after the current end
      start = end + 1;
    }

    return buffer.toString();
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
