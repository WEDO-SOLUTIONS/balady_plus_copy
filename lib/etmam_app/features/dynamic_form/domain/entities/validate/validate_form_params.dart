class ValidateFormParams {
  String profileId;
  String formId;
  Map<String, dynamic>? fields;
  ValidateFormParams(
      {required this.profileId, required this.formId, this.fields});
  Map<String, dynamic> toMap() => {
        "profileId": profileId,
        if (fields != null && fields!.isNotEmpty)
          "fields": fields!.map((key, value) {
            return MapEntry(key, {"value": value});
          }),
      };
}
