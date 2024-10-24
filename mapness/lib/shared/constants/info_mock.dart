import 'package:mapness/shared/constants/names_ar.dart';
import 'package:mapness/shared/constants/names_en.dart';
import 'package:mapness/shared/providers/app_language.dart';

String? nameMock(int dgisObjectId, Language lang) {
  if (lang == Language.arabic) {
    return namesAr[dgisObjectId];
  }
  return namesEn[dgisObjectId];
}
