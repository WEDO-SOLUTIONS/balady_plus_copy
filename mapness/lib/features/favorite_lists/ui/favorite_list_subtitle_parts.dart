import 'package:intl/intl.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

String favoriteListPlacesCountText(AppLocalizations l10n, int placeCount) => l10n.favoriteListPlacesCount(placeCount);

String favoriteListCreatedOnText(AppLocalizations l10n, DateTime date, String languageCode) =>
    l10n.favoriteListCreatedOn(DateFormat('dd.MM', languageCode).format(date));

String favoriteListModifiedOnText(AppLocalizations l10n, DateTime date, String languageCode) =>
    l10n.favoriteListModifiedOn(DateFormat('dd.MM', languageCode).format(date));
