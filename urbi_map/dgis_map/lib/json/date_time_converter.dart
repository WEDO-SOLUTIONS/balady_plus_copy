import 'package:json_annotation/json_annotation.dart';

//TODO: Implement later
/// Placeholder converter between [DateTime] and its JSON string form.
///
/// Both directions throw [UnimplementedError]; nothing is wired to it yet.
class DateTimeConverter extends JsonConverter<DateTime, String> {
  @override
  DateTime fromJson(String json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  String toJson(DateTime object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
