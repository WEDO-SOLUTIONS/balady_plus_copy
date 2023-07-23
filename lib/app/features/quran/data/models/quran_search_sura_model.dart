import 'dart:convert';

class QuranSearchSuraModel {
  String suraName;
  int jozz;
  int suraNo;
  int pageNo;
  int ayahNo;
  String aya;

  QuranSearchSuraModel({
    required this.aya,
    required this.ayahNo,
    required this.jozz,
    required this.pageNo,
    required this.suraName,
    required this.suraNo,
  });
}
