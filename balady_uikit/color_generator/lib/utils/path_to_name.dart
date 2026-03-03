extension PathToName on String {
  String get nameOfFile => split('/').last.split('.').first;
}
