import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/facility.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/tobacco_schedule.dart';

class DisclosureRequest {
  // String identityNumber;
  DisclosureSchedule disclosureSchedule;
  Facility facility;
  String? attachmentId;
  double? disclosureAmount;
  int? removeDisclosureReasonId;
  String? removeDisclosureComments;

  DisclosureRequest({
    required this.disclosureSchedule,
    // required this.identityNumber,
    required this.facility,
    this.attachmentId,
    this.disclosureAmount,
    this.removeDisclosureReasonId,
    this.removeDisclosureComments,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "disclosureScheduleId": disclosureSchedule.disclosureScheduleId,
      "registrationNumber": facility.registrationNumber,
      // "identityNumber": identityNumber,
      "disclosureAmount": disclosureAmount ?? 0.0,
      "attachmentId": attachmentId,
    };
    if (removeDisclosureReasonId != null) {
      data['removeDisclosureReasonId'] = removeDisclosureReasonId.toString();
    }
    if (removeDisclosureComments != null) {
      data['removeDisclosureComments'] = removeDisclosureComments;
    }
    return data;
  }
}
