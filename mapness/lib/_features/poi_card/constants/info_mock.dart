import 'package:mapness/_features/poi_card/constants/about_ar.dart';
import 'package:mapness/_features/poi_card/constants/about_en.dart';
import 'package:mapness/_features/poi_card/constants/names_en.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/_features/poi_card/constants/names_ar.dart';

String? aboutMock(int dgisObjectId, Language lang) {
  if (lang == Language.arabic) {
    return aboutAr[dgisObjectId];
  }
  return aboutEn[dgisObjectId];
}

String? nameMock(int dgisObjectId, Language lang) {
  if (lang == Language.arabic) {
    return namesAr[dgisObjectId];
  }
  return namesEn[dgisObjectId];
}
