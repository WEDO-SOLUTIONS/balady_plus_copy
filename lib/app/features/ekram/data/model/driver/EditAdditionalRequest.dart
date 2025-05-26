import 'deceased_attachment.dart';

class EditAdditionalRequest {

  String? ghuslEmployeeIdentityNumber;
  List<DeceasedAttachment>? attachments;
  int? requestId;
  EditAdditionalRequest({
      this.ghuslEmployeeIdentityNumber, 
      this.attachments,
    this.requestId,});

  EditAdditionalRequest.fromJson(dynamic json) {
    ghuslEmployeeIdentityNumber = json['ghuslEmployeeIdentityNumber'];
    if (json['attachments'] != null) {
      attachments = [];
      json['attachments'].forEach((v) {
        attachments?.add(DeceasedAttachment.fromJson(v));
      });
    }
  }

EditAdditionalRequest copyWith({  String? ghuslEmployeeIdentityNumber,int? requestId,
  List<DeceasedAttachment>? attachments,
}) => EditAdditionalRequest(
  ghuslEmployeeIdentityNumber: ghuslEmployeeIdentityNumber ?? this.ghuslEmployeeIdentityNumber,
  requestId: requestId ?? this.requestId,
  attachments: attachments ?? this.attachments,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ghuslEmployeeIdentityNumber'] = ghuslEmployeeIdentityNumber;
    if (attachments != null) {
      map['attachments'] = attachments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

