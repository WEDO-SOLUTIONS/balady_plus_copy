import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

enum Plurals {
  zero,
  one,
  two,
  few,
  many,
  others,
}

/// This is the rule how to convert number to plural for Arabic language
/// One of the sources: https://localazy.com/docs/general/translating-plurals
Plurals getPluralForAr(int number) {
  if (number == 0) {
    return Plurals.zero;
  } else if (number == 1) {
    return Plurals.one;
  } else if (number == 2) {
    return Plurals.two;
  } else if (number % 100 >= 3 && number % 100 <= 10) {
    return Plurals.few;
  } else if (number % 100 >= 11 && number % 100 <= 99) {
    return Plurals.many;
  } else {
    return Plurals.others;
  }
}

String brunch(int number, AppLocalizations l10n) {
  final brunchLocalized = getPluralForAr(number);
  switch (brunchLocalized) {
    case Plurals.zero:
      return l10n.brunchZero;
    case Plurals.one:
      return l10n.brunchOne;
    case Plurals.two:
      return l10n.brunchTwo;
    case Plurals.few:
      return l10n.brunchFew;
    case Plurals.many:
      return l10n.brunchMany;
    case Plurals.others:
      return l10n.brunchOther;
  }
}

String lots(int number, AppLocalizations l10n) {
  final lotsLocalized = getPluralForAr(number);
  switch (lotsLocalized) {
    case Plurals.zero:
      return l10n.lotsPluralZero;
    case Plurals.one:
      return l10n.lotsPluralOne;
    case Plurals.two:
      return l10n.lotsPluralTwo;
    case Plurals.few:
      return l10n.lotsPluralFew;
    case Plurals.many:
      return l10n.lotsPluralMany;
    case Plurals.others:
      return l10n.lotsPluralOther;
  }
}

class ArPlurals {
  /// IMPORTANT: zero, one, two is not used with the number (it integrated into the translation)
  /// This is because of the arabic language and specific rules for plurals
  static String stations(int number, AppLocalizations l10n) {
    final stationsLocalized = getPluralForAr(number);
    switch (stationsLocalized) {
      case Plurals.zero:
        return l10n.stationsZero;
      case Plurals.one:
        return l10n.stationsOne;
      case Plurals.two:
        return l10n.stationsTwo;
      case Plurals.few:
        return '${l10n.number(number)} ${l10n.stationsFew}';
      case Plurals.many:
        return '${l10n.number(number)} ${l10n.stationsMany}';
      case Plurals.others:
        return '${l10n.number(number)} ${l10n.stationsOther}';
    }
  }

  /// IMPORTANT: zero, one, two is not used with the number (it integrated into the translation)
  /// This is because of the arabic language and specific rules for plurals
  static String transfers(int number, AppLocalizations l10n) {
    final transfersLocalized = getPluralForAr(number);
    switch (transfersLocalized) {
      case Plurals.zero:
        return l10n.transfersZero;
      case Plurals.one:
        return l10n.transfersOne;
      case Plurals.two:
        return l10n.transfersTwo;
      case Plurals.few:
        return '${l10n.number(number)} ${l10n.transfersFew}';
      case Plurals.many:
        return '${l10n.number(number)} ${l10n.transfersMany}';
      case Plurals.others:
        return '${l10n.number(number)} ${l10n.transfersOther}';
    }
  }
}
