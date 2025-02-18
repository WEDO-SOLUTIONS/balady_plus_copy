import 'burial_info.dart';
import 'cemetery_data.dart';
import 'death_info.dart';
import 'deceased_info.dart';
import 'location_info.dart';
import 'main_info.dart';
import 'municipality.dart';
import 'transport_info.dart';

class RequestDetailsResponseModel {
  int? requestId;
  String? requestKey;
  int? currentTabId;
  String? requestDate;
  String? submitDate;
  String? lastUpdateDate;
  int? requestTypeId;
  String? requestTypeName;
  int? requestStatusId;
  String? requestStatusName;
  int? entryMode;
  Municipality? municipality;
  DeceasedInfo? deceasedInfo;
  DeathInfo? deathInfo;
  BurialInfo? burialInfo;
  CemeteryData? cemeteryData;
  MainInfo? mainInfo;
  TransportInfo? transportInfo;
  LocationInfo? locationInfo;
  bool? draft;
  bool? editable;
  bool? deletable;
  bool? cancelable;
  bool? assignable;
  bool? tripable;
  bool? transferring;
  bool? done;
  String? cemeteryReservationMsg;
  String? cancelReason;
  String? notes;


  RequestDetailsResponseModel(
      {this.requestId,
      this.requestKey,
      this.currentTabId,
      this.requestDate,
      this.submitDate,
      this.lastUpdateDate,
      this.requestTypeId,
      this.requestTypeName,
      this.requestStatusId,
      this.requestStatusName,
      this.entryMode,
      this.municipality,
      this.deceasedInfo,
      this.deathInfo,
      this.burialInfo,
      this.cemeteryData,
      this.mainInfo,
      this.transportInfo,
      this.locationInfo,
      this.draft,
      this.editable,
      this.deletable,
      this.cancelable,
      this.assignable,
      this.tripable,
      this.transferring,
      this.done,
      this.cemeteryReservationMsg,
      this.cancelReason,
      this.notes});

  factory RequestDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      RequestDetailsResponseModel(
        requestId: json['requestId'] as int?,
        requestKey: json['requestKey'] as String?,
        currentTabId: json['currentTabId'] as int?,
        requestDate: json['requestDate'] as String?,
        submitDate: json['submitDate'] as String?,
        lastUpdateDate: json['lastUpdateDate'] as String?,
        requestTypeId: json['requestTypeId'] as int?,
        requestTypeName: json['requestTypeName'] as String?,
        requestStatusId: json['requestStatusId'] as int?,
        requestStatusName: json['requestStatusName'] as String?,
        entryMode: json['entryMode'] as int?,
        municipality: json['municipality'] == null
            ? null
            : Municipality.fromJson(
                json['municipality'] as Map<String, dynamic>),
        deceasedInfo: json['deceasedInfo'] == null
            ? null
            : DeceasedInfo.fromJson(
                json['deceasedInfo'] as Map<String, dynamic>),
        deathInfo: json['deathInfo'] == null
            ? null
            : DeathInfo.fromJson(json['deathInfo'] as Map<String, dynamic>),
        burialInfo: json['burialInfo'] == null
            ? null
            : BurialInfo.fromJson(json['burialInfo'] as Map<String, dynamic>),
        cemeteryData: json['cemeteryData'] == null
            ? null
            : CemeteryData.fromJson(
                json['cemeteryData'] as Map<String, dynamic>),
        mainInfo: json['mainInfo'] == null
            ? null
            : MainInfo.fromJson(json['mainInfo'] as Map<String, dynamic>),
        transportInfo: json['transportInfo'] == null
            ? null
            : TransportInfo.fromJson(
                json['transportInfo'] as Map<String, dynamic>),
        locationInfo: json['locationInfo'] == null
            ? null
            : LocationInfo.fromJson(
                json['locationInfo'] as Map<String, dynamic>),
        draft: json['draft'] as bool?,
        editable: json['editable'] as bool?,
        deletable: json['deletable'] as bool?,
        cancelable: json['cancelable'] as bool?,
        assignable: json['assignable'] as bool?,
        tripable: json['tripable'] as bool?,
        transferring: json['transferring'] as bool?,
        done: json['done'] as bool?,
        cemeteryReservationMsg: json['cemeteryReservationMsg'] as String?,
        cancelReason: json['cancelReason'] as String?,
        notes: json['notes'] as String?,


      );

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'requestKey': requestKey,
        'currentTabId': currentTabId,
        'requestDate': requestDate,
        'submitDate': submitDate,
        'lastUpdateDate': lastUpdateDate,
        'requestTypeId': requestTypeId,
        'requestTypeName': requestTypeName,
        'requestStatusId': requestStatusId,
        'requestStatusName': requestStatusName,
        'entryMode': entryMode,
        'municipality': municipality?.toJson(),
        'deceasedInfo': deceasedInfo?.toJson(),
        'deathInfo': deathInfo?.toJson(),
        'burialInfo': burialInfo?.toJson(),
        'cemeteryData': cemeteryData?.toJson(),
        'mainInfo': mainInfo?.toJson(),
        'transportInfo': transportInfo?.toJson(),
        'locationInfo': locationInfo?.toJson(),
        'draft': draft,
        'editable': editable,
        'deletable': deletable,
        'cancelable': cancelable,
        'assignable': assignable,
        'tripable': tripable,
        'transferring': transferring,
        'done': done,
        'cemeteryReservationMsg': cemeteryReservationMsg,
        'cancelReason': cancelReason,
        'notes': notes

      };

  RequestDetailsResponseModel copyWith({
    DeceasedInfo? deceasedInfo,
    DeathInfo? deathInfo,
    MainInfo? mainInfo,
    BurialInfo? burialInfo,
    TransportInfo? transportInfo,
    CemeteryData? cemeteryData,
    int? requestId,
    String? requestKey,
    int? currentTabId,
    String? requestDate,
    String? submitDate,
    String? lastUpdateDate,
    int? requestTypeId,
    String? requestTypeName,
    int? requestStatusId,
    String? requestStatusName,
    int? entryMode,
    Municipality? municipality,
    LocationInfo? locationInfo,
    bool? draft,
    bool? editable,
    bool? deletable,
    bool? cancelable,
    bool? assignable,
    bool? tripable,
    bool? transferring,
    bool? done,
    String? cemeteryReservationMsg,
    String? cancelReason,
    String? notes,
  }) {
    return RequestDetailsResponseModel(
      requestId: requestId ?? this.requestId,
      requestKey: requestKey ?? this.requestKey,
      currentTabId: currentTabId ?? this.currentTabId,
      requestDate: requestDate ?? this.requestDate,
      submitDate: submitDate ?? this.submitDate,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      requestTypeId: requestTypeId ?? this.requestTypeId,
      requestTypeName: requestTypeName ?? this.requestTypeName,
      requestStatusId: requestStatusId ?? this.requestStatusId,
      requestStatusName: requestStatusName ?? this.requestStatusName,
      entryMode: entryMode ?? this.entryMode,
      municipality: municipality ?? this.municipality,
      locationInfo: locationInfo ?? this.locationInfo,
      draft: draft ?? this.draft,
      editable: editable ?? this.editable,
      deletable: deletable ?? this.deletable,
      cancelable: cancelable ?? this.cancelable,
      assignable: assignable ?? this.assignable,
      tripable: tripable ?? this.tripable,
      transferring: transferring ?? this.transferring,
      done: done ?? this.done,
      deceasedInfo: deceasedInfo ?? this.deceasedInfo,
      mainInfo: mainInfo ?? this.mainInfo,
      deathInfo: deathInfo ?? this.deathInfo,
      burialInfo: burialInfo ?? this.burialInfo,
      transportInfo: transportInfo ?? this.transportInfo,
      cemeteryData: cemeteryData ?? this.cemeteryData,
      cemeteryReservationMsg:
      cemeteryReservationMsg ?? this.cemeteryReservationMsg,
      cancelReason:  cancelReason ?? this.cancelReason,
      notes: notes ?? this.notes,

    );
  }
}
