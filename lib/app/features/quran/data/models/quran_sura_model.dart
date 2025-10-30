import 'dart:convert';

class QuranSuraModel {
  String suraName;
  int jozz;
  int suraNo;
  List<Map<int, String>> suraAyat;
  List<Map<int, String>> suraAyatNormal;

  QuranSuraModel(
      {required this.suraAyat,
      required this.suraName,
      required this.jozz,
      required this.suraNo,
      required this.suraAyatNormal});
}
