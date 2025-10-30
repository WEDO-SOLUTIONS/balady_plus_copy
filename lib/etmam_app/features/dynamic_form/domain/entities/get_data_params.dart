class GetDataParams {
  String fieldId;
  String profileId;
  Map<String, dynamic>? fields;

  GetDataParams({required this.fieldId, required this.profileId, this.fields});
  Map<String, dynamic> toMap() => {
        "profileId": profileId,
        if (fields != null && fields!.isNotEmpty)
          "fields": fields!.map((key, value) {
            return MapEntry(key, {"value": value});
          }),
      };
}
