extension StringExt on String {
  // Replaces all localazy '\n' with new lines character
  String multilines() => replaceAll(r'\n', '\n');

  String skipMultilines() => replaceAll(r'\n', '');
}
