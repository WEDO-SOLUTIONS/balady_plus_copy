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
