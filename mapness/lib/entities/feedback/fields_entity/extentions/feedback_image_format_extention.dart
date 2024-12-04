import 'package:mapness/l10n/generated/app_localizations.dart';

extension FeedbackImageFormatExtention on List<String> {
  String formatAcceptedFormats(AppLocalizations l10n) {
    if (isEmpty) {
      return '';
    }
    final formats = List<String>.generate(
      length,
      (index) => this[index].toUpperCase(),
    );

    if (formats.length == 1) {
      return formats.first;
    }

    final lastFormat = formats.removeLast();

    return '${formats.join(', ')} ${l10n.and} $lastFormat';
  }
}
