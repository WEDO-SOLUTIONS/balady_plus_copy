/// Localization for the [PathCard] widget.
///
/// You need to provide locaized strings for the [calories], [steps] and [go] fields.
/// If you need to add more fields, you can do it here.
///
/// Exmaple:
/// ```dart
/// localizations: PathCardLocalization(
///   calories: context.l10n.calories,
///   steps: context.l10n.steps,
///   go: context.l10n.go,
///),
/// ```
class PathCardLocalization {
  final String calories;
  final String steps;
  final String go;

  const PathCardLocalization({
    required this.calories,
    required this.steps,
    required this.go,
  });
}
