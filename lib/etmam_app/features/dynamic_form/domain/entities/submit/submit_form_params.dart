class SubmitFormParams {
  String cityId;
  String profileId;
  String formId;
  String relationId;
  Map<String, dynamic>? fields;
  List<SubmitFormParams>? subBiddings;
  String? uploadTransactionId;
  String? descAttachmentId;
  SubmitFormParams(
      {required this.cityId,
      required this.relationId,
      required this.profileId,
      required this.formId,
      this.subBiddings,
      this.fields,
      this.uploadTransactionId,
      this.descAttachmentId});
  Map<String, dynamic> toMap() => {
        "profileId": profileId,
        "cityId": cityId,
        "relationId": relationId,
        if (uploadTransactionId != null)
          "uploadTransactionId": uploadTransactionId,
        if (descAttachmentId != null) "descAttachmentId": descAttachmentId,
        if (fields != null && fields!.isNotEmpty)
          "inputs": {
            "fields": fields!.map((key, value) {
              return MapEntry(key, {"value": value});
            }),
            "id": formId
          },
        if (subBiddings != null && subBiddings!.isNotEmpty)
          "subBiddings": subBiddings!
              .map((e) => {
                    "relationId": e.relationId,
                    /*if (fields != null && fields!.isNotEmpty)
                      "inputs": {
                        "fields": fields!.map((key, value) {
                          return MapEntry(key, {"value": value});
                        }),
                        "id": formId
                      },*/
                  })
              .toList()
      };

  Map<String, dynamic> toEditMap() => {
        "profileId": profileId,
        if (fields != null && fields!.isNotEmpty)
          "biddings": [
            {
              "id": relationId,
              "inputs": {
                "fields": fields!.map((key, value) {
                  return MapEntry(key, {"value": value});
                }),
                "id": formId
              },
            }
          ]
      };
}
