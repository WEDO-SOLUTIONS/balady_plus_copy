import 'package:flutter/material.dart';

abstract class ComponentLocalizationsBase {
  final Locale? locale;
  const ComponentLocalizationsBase(this.locale);
  Object? getItem(String key);
  String? get cancelText => getItem('cancelText') as String;
  String? get confirmText => getItem('confirmText') as String;
  String? get seacrhFor => getItem("searchFor") as String;
  List? get ampm => getItem('ampm') as List;
  List? get months => getItem('months') as List;
  List? get monthsLong => getItem('monthsLong') as List;
  bool isRTL() =>
      (locale != null && locale!.languageCode != "ar") ? false : true;
}

/// localizations
class ComponentLocalizations extends ComponentLocalizationsBase {
  static ComponentLocalizations _static = ComponentLocalizations(null);
  const ComponentLocalizations(Locale? locale) : super(locale);

  @override
  Object? getItem(String key) {
    Map? localData;
    if (locale != null) {
      localData = localizedValues[locale!.languageCode];
    }
    if (localData == null) return localizedValues['ar']![key];
    return localData[key];
  }

  static ComponentLocalizations of(BuildContext context) {
    return Localizations.of<ComponentLocalizations>(
            context, ComponentLocalizations) ??
        _static;
  }

  /// Language Support
  static const List<String> languages = [
    'en',
    'ar',
  ];

  /// Language Values
  static const Map<String, Map<String, Object>> localizedValues = {
    'en': {
      'cancelText': 'Cancel',
      'confirmText': 'Confirm',
      'searchFor': "Search...",
      'ampm': ['AM', 'PM'],
    },
    'ar': {
      'cancelText': 'إلغاء',
      'confirmText': 'تأكيد',
      'searchFor': 'ابحث...',
      'ampm': ['صباحاً', 'مساءً'],
    },
    'tr': {
      'cancelText': 'İptal',
      'confirmText': 'Onay',
      'ampm': ['ÖÖ', 'ÖS'],
      'months': [
        'Oca',
        'Şub',
        'Mar',
        'Nis',
        'May',
        'Haz',
        'Tem',
        'Ağu',
        'Eyl',
        'Eki',
        'Kas',
        'Ara'
      ],
      'monthsLong': [
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık'
      ]
    },
  };
}
