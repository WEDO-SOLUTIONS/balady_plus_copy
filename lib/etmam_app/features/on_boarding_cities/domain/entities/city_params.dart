import 'dart:convert';

class CityParams {
  int pageNo;
  int pageSize;
  String? text;

  CityParams({required this.pageNo, required this.pageSize, this.text});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page-no': pageNo,
      'page-size': pageSize,
      if (text != null) 'text': text
    };
  }
}
