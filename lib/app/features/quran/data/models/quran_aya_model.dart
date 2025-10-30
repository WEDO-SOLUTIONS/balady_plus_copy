import 'dart:convert';

class QuranAyaModel {
  int id;
  int jozz;
  int suraNo;
  String suraNameEn;
  String suraNameAr;
  int page;
  int lineStart;
  int lineEnd;
  int ayaNo;
  String ayaText;
  String ayaTextEmlaey;
  QuranAyaModel({
    required this.id,
    required this.jozz,
    required this.suraNo,
    required this.suraNameEn,
    required this.suraNameAr,
    required this.page,
    required this.lineStart,
    required this.lineEnd,
    required this.ayaNo,
    required this.ayaText,
    required this.ayaTextEmlaey,
  });

  factory QuranAyaModel.fromMap(Map<String, dynamic> map) {
    return QuranAyaModel(
      id: map['id'] as int,
      jozz: map['jozz'] as int,
      suraNo: map['sura_no'] as int,
      suraNameEn: map['sura_name_en'] as String,
      suraNameAr: map['sura_name_ar'] as String,
      page: map['page'] as int,
      lineStart: map['line_start'] as int,
      lineEnd: map['line_end'] as int,
      ayaNo: map['aya_no'] as int,
      ayaText: map['aya_text'] as String,
      ayaTextEmlaey: map['aya_text_emlaey'] as String,
    );
  }

  factory QuranAyaModel.fromJson(String source) =>
      QuranAyaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
