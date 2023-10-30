import 'package:balady_plus/app/features/transaction_inquiry/customer_voice_exports.dart';

class CrAttachmentRequest {
  int? requestId;
  AttachmentData? data;
  int? type;

  CrAttachmentRequest({this.data, this.requestId, this.type});
}
