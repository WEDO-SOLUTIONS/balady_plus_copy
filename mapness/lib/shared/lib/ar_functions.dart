import 'package:mapness/l10n/generated/app_localizations.dart';

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
