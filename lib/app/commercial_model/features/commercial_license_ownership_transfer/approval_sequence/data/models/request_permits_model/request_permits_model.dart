import 'permit.dart';

class RequestPermitsModel {
  List<Permit>? permits;
  String? term;

  RequestPermitsModel({this.permits, this.term});

  factory RequestPermitsModel.fromJson(Map<String, dynamic> json) {
    return RequestPermitsModel(
      permits: (json['permits'] as List<dynamic>?)
          ?.map((e) => Permit.fromJson(e as Map<String, dynamic>))
          .toList(),
      term: json['term'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'permits': permits?.map((e) => e.toJson()).toList(),
        'term': term,
      };
}
