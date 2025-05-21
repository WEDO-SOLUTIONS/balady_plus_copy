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
    if (trim().isEmpty) {
      return null;
    }

    final words = trim().split(RegExp(r'\s+'));
    final buffer = StringBuffer();
    int charCount = 0;

    for (int i = 0; i < words.length; i++) {
      final word = words[i];

      if (charCount + word.length > maxCharsPerLine) {
        if (charCount > 0) {
          buffer.write('\n');
        }
        buffer.write(word);
        charCount = word.length;
      } else {
        if (charCount > 0) {
          buffer.write(' ');
          charCount++;
        }
        buffer.write(word);
        charCount += word.length;
      }
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
