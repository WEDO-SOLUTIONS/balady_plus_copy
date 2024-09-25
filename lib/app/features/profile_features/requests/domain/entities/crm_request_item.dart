import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/enums/enums.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';


class CRMRequestItem extends Equatable {
  final String? subClassificationName;
  final String? newClassificationName;
  final String? mainClassificationName;
  final String? incidentStatus;
  final String? nationalId;
  final String? latitude;
  final String? pyResolvedTimestamp;
  final String? municipalityId;
  final String? iqamaId;
  final String? pyId;
  final bool? damagedVehicles;
  final String? splClassificationName;
  final String? statusAr;
  final String? pxCreateDateTime;
  final String? incidentNumber;
  final int? reOpenCount;
  final String? amanaIncidentId;
  final String? pyStatusWork;
  final String? pxInsName;
  final String? specialClassificationType;
  final String? municipalityName;
  final String? pzInsKey;
  final String? longitude;
  final String? mobileNumber;
  final String? pyLabel;
  final String? closureFlag;
  final String? sourceSystem;
  final String? requestTypeId;
  final String? requestType;
  final String? category;
  final String? description;
  final String? categoryAr;
  final String? issueType;
  final String? channel;
  final String? lastUserComment;
  final String? area;
  final String? subCategory;
  final int? totalServiceFee;
  final String? splClassification;
  final String? municipality;
  final String? subClassification;
  final String? mainClassification;

  CRMRequestItem({
    this.subClassificationName,
    this.newClassificationName,
    this.mainClassificationName,
    this.incidentStatus,
    this.nationalId,
    this.latitude,
    this.pyResolvedTimestamp,
    this.municipalityId,
    this.iqamaId,
    this.pyId,
    this.damagedVehicles,
    this.splClassificationName,
    this.statusAr,
    this.pxCreateDateTime,
    this.incidentNumber,
    this.reOpenCount,
    this.amanaIncidentId,
    this.pyStatusWork,
    this.pxInsName,
    this.specialClassificationType,
    this.municipalityName,
    this.pzInsKey,
    this.longitude,
    this.mobileNumber,
    this.pyLabel,
    this.closureFlag,
    this.sourceSystem,
    this.requestTypeId,
    this.requestType,
    this.category,
    this.description,
    this.categoryAr,
    this.issueType,
    this.channel,
    this.lastUserComment,
    this.area,
    this.subCategory,
    this.totalServiceFee,
    this.splClassification,
    this.municipality,
    this.subClassification,
    this.mainClassification,
  });

  factory CRMRequestItem.fromJson(Map<String, dynamic> json) => CRMRequestItem(
        subClassificationName: json["SubClassificationName"],
        newClassificationName: json["NewClassificationName"],
        mainClassificationName: json["MainClassificationName"],
        incidentStatus: json["IncidentStatus"],
        nationalId: json["NationalID"],
        latitude: json["Latitude"],
        pyResolvedTimestamp: json["pyResolvedTimestamp"],
        municipalityId: json["MunicipalityID"],
        iqamaId: json["IqamaID"],
        pyId: json["pyID"],
        damagedVehicles: json["DamagedVehicles"],
        splClassificationName: json["SplClassificationName"],
        statusAr: json["Status_Ar"],
        pxCreateDateTime: json["pxCreateDateTime"],
        incidentNumber: json["IncidentNumber"],
        reOpenCount: json["ReOpenCount"],
        amanaIncidentId: json["AmanaIncidentID"],
        pyStatusWork: json["pyStatusWork"],
        pxInsName: json["pxInsName"],
        specialClassificationType: json["SpecialClassificationType"],
        municipalityName: json["MunicipalityName"],
        pzInsKey: json["pzInsKey"],
        longitude: json["Longitude"],
        mobileNumber: json["MobileNumber"],
        pyLabel: json["pyLabel"],
        closureFlag: json["ClosureFlag"],
        sourceSystem: json["SourceSystem"],
        requestTypeId: json["RequestTypeID"],
        requestType: json["RequestType"],
        category: json["Category"],
        description: json["Description"],
        categoryAr: json["CategoryAR"],
        issueType: json["IssueType"],
        channel: json["Channel"],
        lastUserComment: json["LastUserComment"],
        area: json["Area"],
        subCategory: json["SubCategory"],
        totalServiceFee: json["TotalServiceFee"],
        splClassification: json["SplClassification"],
        municipality: json["Municipality"],
        subClassification: json["SubClassification"],
        mainClassification: json["MainClassification"],
      );

  RequestsType getRequestType() {
    String id = pyId ?? "";

    if (id.contains("REQ")) {
      return RequestsType.REQ;
    } else if (id.contains("INQ")) {
      return RequestsType.INQ;
    } else if (id.contains("TSR")) {
      return RequestsType.TSR;
    } else if (id.contains("VHR")) {
      return RequestsType.VHR;
    } else if (damagedVehicles == true) {
      return RequestsType.DC;
    } else {
      return RequestsType.INC;
    }
  }

  String getId() {
    String id = pyId ?? "";
    if (getRequestType() == RequestsType.TSR) return incidentNumber ?? "";
    bool isInRiyadhOrEastern =
        municipalityId == "004" || municipalityId == "006";
    if (isInRiyadhOrEastern && (id.contains("INC"))) {
      if (amanaIncidentId != null && amanaIncidentId!.isNotEmpty) {
        return amanaIncidentId ?? "";
      } else {
        if (pyStatusWork != null && pyStatusWork == "Rejected") {
          return Helpers.translatingWord("no_amanah_number");
        } else {
          return Helpers.translatingWord("waiting_for_amana_number");
        }
      }
    } else {
      return pyId ?? " ";
    }
  }

  String getSplClassificationName() {
    if (getRequestType() == RequestsType.TSR)
      return categoryAr ?? "";
    else {
      if (splClassificationName?.isNotEmpty ?? false)
        return splClassificationName ?? "";
      if (newClassificationName?.isNotEmpty ?? false)
        return newClassificationName ?? "";
    }
    return "";
  }

  String getStatusSTR() {
    if (getRequestType() == RequestsType.VHR) return getStatus() ?? "";
    if (closureFlag == "Yes") return Helpers.translatingWord("solved");

    return Helpers.translatingWord("in_progress");
  }

  String getCreateDate() {
    String? date = pxCreateDateTime;
    DateTime? dateTime;
    try {
      if (date != null && date.isNotEmpty) {
        String dateWithT = date.substring(0, 15) + "z";

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
      String? dateWithT =
          date?.substring(0, 8) ?? ""; //+ 'T' + date.substring(8);
      dateTime = DateTime.parse(dateWithT);
    }
    return dateTime != null ? DateFormat.yMd().format(dateTime) : "";
  }

  String getStatus() {
    return (CommonFunctions.isAppAR ? statusAr : pyStatusWork) ?? "";
  }

  @override
  List<Object?> get props => [];
}
