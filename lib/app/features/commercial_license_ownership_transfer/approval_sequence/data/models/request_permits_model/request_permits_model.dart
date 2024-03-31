import 'permit.dart';

class RequestPermitsModel {
  List<Permit>? permits;

  RequestPermitsModel({this.permits});

  factory RequestPermitsModel.fromJson(Map<String, dynamic> json) {
    return RequestPermitsModel(
      permits: (json['permits'] as List<dynamic>?)
          ?.map((e) => Permit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'permits': permits?.map((e) => e.toJson()).toList(),
      };
}
