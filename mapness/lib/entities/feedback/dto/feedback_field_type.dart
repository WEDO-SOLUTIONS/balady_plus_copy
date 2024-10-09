import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum FeedbackFieldType {
  boolean,
  email,
  singleline,
  @JsonValue('list_singleline')
  listSingleline,
  multiline,
  phone,
  url,
  image,
  dropdown,
  schedule,
  location;

  bool get isTextField => switch (this) {
        email || singleline || listSingleline || multiline || phone || url => true,
        _ => false,
      };
}
