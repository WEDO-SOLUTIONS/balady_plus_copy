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
