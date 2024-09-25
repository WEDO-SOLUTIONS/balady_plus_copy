/*import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import 'error_result.dart';

class RequestDetailsResponse {
  String? pyId;
  IncidentInformation? incidentInformation;
  CustomerInformation? customerInformation;
  String? statusWork;
  String? pzInsKey;
  String? caseGoal;
  String? caseDeadline;
  String? pyLabel;
  String? amanaIncidentID;

  List<ErrorResult>? errors;
  LocationInfo? locationInfo;
  List<Attachment>? attachmentList;
  AuditInformation? auditInformation;
  RequestDetailsResponse({
    this.pyId,
    this.incidentInformation,
    this.customerInformation,
    this.statusWork,
    this.pzInsKey,
    this.caseGoal,
    this.caseDeadline,
    this.pyLabel,
    this.errors,
    this.locationInfo,
    this.attachmentList,
    this.amanaIncidentID,
    this.auditInformation,
  });

  factory RequestDetailsResponse.fromJson(Map<String, dynamic> json,
      {CRM_REQUEST_TYPE type = CRM_REQUEST_TYPE.inc}) {
    String? date = json["CaseGoal"];
    DateTime? dateTime;
    if (date != null && date.isNotEmpty) {
      String dateWithT = date.substring(0, 8); //+ 'T' + date.substring(8);
      dateTime = DateTime.parse(dateWithT);
    }

    return RequestDetailsResponse(
      pyId: json["pyID"],
      amanaIncidentID: json["AmanaIncidentID"],
      incidentInformation: json["IncidentInformation"] != null
          ? IncidentInformation.fromJson(json["IncidentInformation"])
          : null,
      customerInformation: json["CustomerInformation"] != null
          ? CustomerInformation.fromJson(json["CustomerInformation"])
          : null,
      statusWork: json["StatusWork"],
      pzInsKey: json["pzInsKey"],
      caseGoal:
          dateTime != null ? DateFormat('yyyy-MM-dd').format(dateTime) : "",
      caseDeadline: json["CaseDeadline"],
      pyLabel: json["pyLabel"],
      errors: json["errors"] != null
          ? List<ErrorResult>.from(
              json["errors"].map((x) => ErrorResult.fromJson(x)))
          : [],
      locationInfo: json["LocationInfo"] != null
          ? LocationInfo.fromJson(json["LocationInfo"])
          : null,
      attachmentList: json["AttachmentList"] != null
          ? List<Attachment>.from(
              json["AttachmentList"].map((x) => Attachment.fromMapObject(x)))
          : null,
      auditInformation: json["AuditInformation"] != null
          ? AuditInformation.fromJson(json["AuditInformation"], type: type)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "pyID": pyId,
        "AmanaIncidentID": amanaIncidentID,
        "IncidentInformation": incidentInformation!.toJson(),
        "CustomerInformation": customerInformation!.toJson(),
        "StatusWork": statusWork,
        "pzInsKey": pzInsKey,
        "CaseGoal": caseGoal,
        "CaseDeadline": caseDeadline,
        "pyLabel": pyLabel,
        "errors": List<ErrorResult>.from(errors!.map((x) => x)),
        "LocationInfo": locationInfo != null ? locationInfo!.toJson() : null,
        "AuditInformation":
            auditInformation != null ? auditInformation!.toJson() : null,
      };

/*

String getParkName(){
          if (incidentInformation!=null && incidentInformation.parkID != null &&
          incidentInformation.parkID.isNotEmpty)
        return incidentInformation.parkName != null ? incidentInformation.parkName: "";
return "";
}


String getDescribtion(){
  return (incidentInformation!=null && incidentInformation.issueDescription!=null) ? incidentInformation.issueDescription : " ";
}
*/

}

class AuditInformation {
  AuditInformation({
    this.auditList,
    this.createdDate,
  });

  List<AuditList>? auditList;
  String? createdDate;

  AuditInformation.fromJson(Map<String, dynamic> json,
      {CRM_REQUEST_TYPE type = CRM_REQUEST_TYPE.inc}) {
    auditList = getAuditList(json, type: type);
    createdDate = json["CreatedDate"];
  }

  Map<String, dynamic> toJson() => {
        "AuditList": List<dynamic>.from(auditList!.map((x) => x.toJson())),
        "CreatedDate": createdDate,
      };

  List<AuditList> getAuditList(dynamic json,
      {CRM_REQUEST_TYPE type = CRM_REQUEST_TYPE.inc}) {
    List<AuditList> oldList = List<AuditList>.from(
        json["AuditList"].map((x) => AuditList.fromJson(x)));
    List<AuditList> editedList = [];

    if (type != CRM_REQUEST_TYPE.req) {
      editedList
          .add(AuditList(sortDateTime: json["CreatedDate"], type: "Created"));
    }
    editedList.addAll(oldList);

    return editedList.reversed.toList();
  }

  bool isResolved() {
    if (auditList != null) {
      AuditList? l =
          auditList?.firstWhereOrNull((element) => element.type == "Resolved");

      if (l != null) return true;
      return false;
    }
    return false;
  }
}

class AuditList {
  AuditList(
      {this.escalationReason,
      this.escalatedDate,
      this.type,
      this.sortDateTime,
      this.escalatedClosedDate,
      this.closedDate,
      this.closureReason,
      this.createdDate,
      this.endDate,
      this.updateDateTime,
      this.comments});

  String? escalationReason;
  String? escalatedDate;
  String? type;
  String? sortDateTime;
  String? escalatedClosedDate;
  String? closedDate;
  String? closureReason;

  String? createdDate;
  String? updateDateTime;
  String? endDate;
  String? comments;

  factory AuditList.fromJson(Map<String, dynamic> json) => AuditList(
      escalationReason: json["EscalationReason"],
      escalatedDate: json["EscalatedDate"],
      type: json["Type"],
      sortDateTime: json["SortDateTime"],
      escalatedClosedDate: json["EscalatedClosedDate"],
      closedDate: json["ClosedDate"],
      closureReason: json["ClosureReason"],
      createdDate: json["CreatedDate"],
      updateDateTime: json["UpdateDateTime"],
      endDate: json["EndDate"],
      comments: json["Comments"]);

  Map<String, dynamic> toJson() => {
        "EscalationReason": escalationReason,
        "EscalatedDate": escalatedDate,
        "Type": type,
        "SortDateTime": sortDateTime,
        "EscalatedClosedDate": escalatedClosedDate,
        "ClosedDate": closedDate,
        "ClosureReason": closureReason,
      };

  String getDate({CRM_REQUEST_TYPE incidentType = CRM_REQUEST_TYPE.inc}) {
    DateTime? dateTime;
    try {
      if (sortDateTime != null && sortDateTime!.isNotEmpty) {
        String dateWithT = sortDateTime!.substring(0, 15) + "z";

        dateTime = DateTime.parse(dateWithT).toLocal();
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      String dateWithT =
          sortDateTime!.substring(0, 8); //+ 'T' + date.substring(8);
      dateTime = DateTime.parse(dateWithT);
    }

    if (incidentType == CRM_REQUEST_TYPE.req) {
      return dateTime != null
          ? Helpers.changeToEnglish(
              DateFormat('dd MMM yyyy, hh:mm a', "ar").format(dateTime))
          : " ";
    } else {
      return dateTime != null
          ? Helpers.changeToEnglish(DateFormat.yMMMd('ar').format(dateTime))
          : " ";
    }
  }

  String getTypeTitle({CRM_REQUEST_TYPE incidentType = CRM_REQUEST_TYPE.inc}) {
    if (incidentType == CRM_REQUEST_TYPE.req) return getTypeTitleForMSR();

    switch (type) {
      case "Escalation":
        return Helpers.translatingWord("incident_esclated");

      case "Closure":
        return Helpers.translatingWord("incident_clousure");
      case "Created":
        return Helpers.translatingWord("incident_created");

      case "Resolved":
        return Helpers.translatingWord("incident_resolved");

      case "Rejected":
        return Helpers.translatingWord("incident_rejected");

      default:
        return " ";
    }
  }

  String getTypeTitleForMSR() {
    switch (type) {
      case "Created":
        return Helpers.translatingWord("msr_created");

      case "In Progress":
        return Helpers.translatingWord("msr_inProgress");

      case "Resolved":
        return Helpers.translatingWord("msr_Resolved");

      case "Future project":
        return Helpers.translatingWord("msr_future");
      case "Processed":
        return Helpers.translatingWord("msr_processed");
      case "Rejected":
        return Helpers.translatingWord("msr_rejected");
      case "Reopened":
        return Helpers.translatingWord("msr_reopened");

//
      case "Pending Sadad Payment":
        return Helpers.translatingWord("msr_Pending_Sadad_Payment");
      case "ReProcessed":
        return Helpers.translatingWord("msr_ReProcessed");
      case "Quality check":
        return Helpers.translatingWord("msr_Quality_check");

      default:
        return type ?? "";
    }
  }

  String getDescFor940(String municipalityName) {
    switch (type) {
      /* case "Escalation":
        return escalationReason;
        break;

      case "Closure":
        return closureReason;
        break;

      case "Created":
        return "بإنتظار مراجعة الطلب من قبل المختصين";
        break;*/
      case "Rejected":
        return municipalityName != null && municipalityName.isNotEmpty
            ? Helpers.translatingWord("reject_desc")
                .replaceAll("%s", municipalityName)
            : "";
      default:
        return "";
    }
  }

  String getDesc(String municipalityName,
      {CRM_REQUEST_TYPE incidentType = CRM_REQUEST_TYPE.inc}) {
    if (incidentType == CRM_REQUEST_TYPE.req) {
      return getDescForMSR();
    } else {
      return getDescFor940(municipalityName);
    }
  }

  String getDescForMSR() {
    if (type == "Future project" && getFutureDate().isNotEmpty) {
      String comment = "";

      comment = getFutureDate();

      if (comments != null && comments!.isNotEmpty) comment += "\n" + comments!;
      return comment;
    }
    if (comments != null) return comments!;
    return "";
  }

  String getFutureDate() {
    DateTime? dateTime;
    try {
      if (endDate != null && endDate!.isNotEmpty) {
        String dateWithT = endDate!;

        dateTime = DateTime.parse(dateWithT);
      }
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
    return dateTime != null
        ? (Helpers.translatingWord("future_compleation_date") +
            ": " +
            Helpers.changeToEnglish(
                DateFormat('dd MMM yyyy', "ar").format(dateTime)))
        : "";
  }
}

class IncidentInformation {
  String? mainClassificationId;
  String? subClassificationId;
  String? splClassificationId;
  String? priority;
  String? responseTime;
  String? issueDescription;
  String? isCallBackSelected;
  String? description;
  String? continueIncidentCreation;
  String? parkID;
  String? parkName;
  String? scBusinessTypeID;
  String? scBusinessType;
  String? inquiryReply;
  String? evaluationStatus;
  String? isinzone;
  List<String>? zoneList;
  List<QuestionList>? questionList;

  IncidentInformation({
    this.mainClassificationId,
    this.subClassificationId,
    this.splClassificationId,
    this.priority,
    this.responseTime,
    this.issueDescription,
    this.description,
    this.isCallBackSelected,
    this.continueIncidentCreation,
    this.parkID,
    this.parkName,
    this.scBusinessTypeID,
    this.scBusinessType,
    this.inquiryReply,
    this.evaluationStatus,
    this.isinzone,
    this.zoneList,
    this.questionList,
  });

  factory IncidentInformation.fromJson(Map<String, dynamic> json) =>
      IncidentInformation(
        mainClassificationId: json["MainClassificationID"],
        subClassificationId: json["SubClassificationID"],
        splClassificationId: json["SplClassificationID"],
        priority: json["Priority"],
        responseTime: "" + json["ResponseTime"].toString(),
        issueDescription: json["IssueDescription"],
        isCallBackSelected: json["IsCallBackSelected"].toString(),
        parkID: json["ParkID"],
        parkName: json["ParkName"],
        scBusinessTypeID: json["SCBusinessTypeID"],
        scBusinessType: json["SCBusinessType"],
        inquiryReply: json["InquiryReply"],
        description: json["Description"],
        evaluationStatus: json["EvaluationStatus"],
        questionList: json["QuestionList"] != null
            ? List<QuestionList>.from(
                json["QuestionList"].map((x) => QuestionList.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "MainClassificationID": mainClassificationId,
        "SubClassificationID": subClassificationId,
        "SplClassificationID": splClassificationId,
        "Priority": priority,
        "ResponseTime": responseTime,
        "IssueDescription": issueDescription,
        "IsCallBackSelected": isCallBackSelected,
        "ContinueIncidentCreation": continueIncidentCreation,
        "ParkID": parkID,
        "ParkName": parkName,
        "SCBusinessTypeID": scBusinessTypeID,
        "SCBusinessType": scBusinessType,
        "Description": description,
        "EvaluationStatus": evaluationStatus
      };
}

class CustomerInformation {
  String? nationalId;
  String? iqamaId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dateOfBirth;
  String? mobileNumber;
  String? emailAddress;

  CustomerInformation({
    this.nationalId,
    this.iqamaId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.mobileNumber,
    this.emailAddress,
  });

  factory CustomerInformation.fromJson(Map<String, dynamic> json) =>
      CustomerInformation(
        nationalId: json["NationalID"],
        iqamaId: json["IqamaID"],
        firstName: json["FirstName"],
        middleName: json["MiddleName"],
        lastName: json["LastName"],
        dateOfBirth: json["DateOfBirth"],
        mobileNumber: json["MobileNumber"],
        emailAddress: json["EmailAddress"],
      );

  Map<String, dynamic> toJson() => {
        "NationalID": nationalId,
        "IqamaID": iqamaId,
        "FirstName": firstName,
        "MiddleName": middleName,
        "LastName": lastName,
        "DateOfBirth": dateOfBirth,
        "MobileNumber": mobileNumber,
        "EmailAddress": emailAddress,
      };
}

class LocationInfo {
  String? municipalityId;
  String? subMunicipalityId;
  String? subSubMunicipalityId;
  String? longitude;
  String? latitude;
  String? address;
  String? streetName;
  String? districtName;

  LocationInfo(
      {this.municipalityId,
      this.subMunicipalityId,
      this.subSubMunicipalityId,
      this.longitude,
      this.latitude,
      this.address,
      this.streetName,
      this.districtName});

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
      municipalityId: json["MunicipalityID"],
      subMunicipalityId: json["SubMunicipalityID"],
      subSubMunicipalityId: json["Sub_SubMunicipalityID"],
      longitude: json["Longitude"],
      latitude: json["Latitude"],
      address: json["Address"],
      streetName: json["StreetName"],
      districtName: json["DistrictName"]);

  Map<String, dynamic> toJson() => {
        "MunicipalityID": municipalityId,
        "SubMunicipalityID": subMunicipalityId,
        "Sub_SubMunicipalityID": subSubMunicipalityId,
        "Longitude": longitude,
        "Latitude": latitude,
        "Address": address,
        "StreetName": streetName,
        "DistrictName": districtName
      };
}

class Attachment {
  String? pyCategory;
  String? pyID;
  String? pzInsKey;
  String? pyLabel;
  String? pxCreateOpName;
  String? pyMemo;

  Attachment(
      {this.pyCategory,
      this.pyID,
      this.pzInsKey,
      this.pyLabel,
      this.pxCreateOpName,
      this.pyMemo});

  factory Attachment.fromMapObject(Map<String, dynamic> map) => Attachment(
        pyCategory: map["pyCategory"],
        pyID: map["pyID"],
        pzInsKey: map["pzInsKey"],
        pyLabel: map["pyLabel"],
        pxCreateOpName: map["pxCreateOpName"],
        pyMemo: map["pyMemo"],
      );
}

class QuestionList {
  QuestionList({
    this.textinput6,
    this.fieldLength,
    this.fieldName,
    this.fieldType,
    this.multiselectList,
    this.textinput3,
    this.textinput2,
    this.integerinput1,
    this.textinput4,
    this.textinput1,
    this.textinput5,
  });

  String? textinput6;
  String? fieldLength;
  String? fieldName;
  String? fieldType;
  List<MultiselectList>? multiselectList;
  String? textinput3;
  String? textinput2;
  String? integerinput1;
  String? textinput4;
  String? textinput1;
  String? textinput5;

  factory QuestionList.fromJson(Map<String, dynamic> json) => QuestionList(
        textinput6: json["Textinput6"] == null ? null : json["Textinput6"],
        fieldLength: json["FieldLength"],
        fieldName: json["FieldName"],
        fieldType: json["FieldType"],
        multiselectList: json["MultiselectList"] == null
            ? null
            : List<MultiselectList>.from(json["MultiselectList"]
                .map((x) => MultiselectList.fromJson(x))),
        textinput3: json["Textinput3"] == null ? null : json["Textinput3"],
        textinput2: json["Textinput2"] == null ? null : json["Textinput2"],
        integerinput1:
            json["Integerinput1"] == null ? null : json["Integerinput1"],
        textinput4: json["Textinput4"] == null ? null : json["Textinput4"],
        textinput1: json["Textinput1"] == null ? null : json["Textinput1"],
        textinput5: json["Textinput5"] == null ? null : json["Textinput5"],
      );

  String? getSelectedFieldValue() {
    switch (fieldType) {
      case Constants.Textbox:
        return textinput1;
      case Constants.DropdownList:
        return textinput2;
      case Constants.TextArea:
        return textinput3;
      case Constants.Radiobutton:
        return textinput4;
      case Constants.HijriCalendar:
        return textinput6;
      case Constants.GregorianCalendar:
        return textinput5;
      case Constants.Numbersfield:
        return integerinput1;
      case Constants.MultiSelectDropdown:
        return multiselectList?.map((e) => e.addlFeildValue).toList().join(",");
      default:
        return "";
    }
  }
}

class MultiselectList {
  MultiselectList({
    this.addlFeildValue,
  });

  String? addlFeildValue;

  factory MultiselectList.fromJson(Map<String, dynamic> json) =>
      MultiselectList(
        addlFeildValue: json["AddlFeildValue"],
      );

  Map<String, dynamic> toJson() => {
        "AddlFeildValue": addlFeildValue,
      };
}
*/
