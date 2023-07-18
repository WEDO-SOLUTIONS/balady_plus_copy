import 'dart:convert';

class QuranSuraModel {
  String suraName;
  int jozz;
  List<Map<int, String>> suraAyat;

  QuranSuraModel(
      {required this.suraAyat, required this.suraName, required this.jozz});
}
