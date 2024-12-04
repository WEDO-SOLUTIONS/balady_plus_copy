import 'package:mapness/l10n/generated/app_localizations.dart';

extension FeedbackImageFormatExtention on List<String> {
  String formatAcceptedFormats(AppLocalizations l10n) {
    if (length <= 1) {
      return first;
    }
    final formats = List<String>.generate(
      length - 1,
      (index) => this[index].toUpperCase(),
    );
    final lastFormat = formats.removeLast();

    return '${formats.join(', ')} ${l10n.and} $lastFormat';
  }
}
