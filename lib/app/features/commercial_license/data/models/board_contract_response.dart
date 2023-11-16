// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

// To parse this JSON data, do
//
//     final boardContractResponse = boardContractResponseFromJson(jsonString);

import 'dart:convert';

class BoardContractResponse extends Equatable {
  final List<BoardContractItem>? result;

  BoardContractResponse({
    this.result,
  });

  factory BoardContractResponse.fromJson(Map<String, dynamic> json) =>
      BoardContractResponse(
        result: json["result"] == null
            ? []
            : List<BoardContractItem>.from(
                json["result"]!.map((x) => BoardContractItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };

  BoardContractResponse copyWith({
    List<BoardContractItem>? result,
  }) {
    return BoardContractResponse(
      result: result ?? this.result,
    );
  }

  factory BoardContractResponse.fromMap(Map<String, dynamic> json) {
    return BoardContractResponse(
      result: json["result"] == null
          ? []
          : List<BoardContractItem>.from(
              json["result"]!.map((x) => BoardContractItem.fromJson(x))),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [result];
}

class BoardContractItem {
  final int? contractId;
  final int? requestId;
  final Activity? activity;
  final Type? type;
  final Status? status;
  final Type? actionType;
  final ActualSubmitter? owner;
  final ActualSubmitter? actualSubmitter;
  final ActualSubmitter? submitter;

  BoardContractItem({
    this.contractId,
    this.requestId,
    this.activity,
    this.type,
    this.status,
    this.actionType,
    this.owner,
    this.actualSubmitter,
    this.submitter,
  });

  factory BoardContractItem.fromJson(Map<String, dynamic> json) =>
      BoardContractItem(
        contractId: json["contractId"],
        requestId: json["requestId"],
        activity: json["activity"] == null
            ? null
            : Activity.fromJson(json["activity"]),
        type: json["type"] == null ? null : Type.fromJson(json["type"]),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        actionType: json["actionType"] == null
            ? null
            : Type.fromJson(json["actionType"]),
        owner: json["owner"] == null
            ? null
            : ActualSubmitter.fromJson(json["owner"]),
        actualSubmitter: json["actualSubmitter"] == null
            ? null
            : ActualSubmitter.fromJson(json["actualSubmitter"]),
        submitter: json["submitter"] == null
            ? null
            : ActualSubmitter.fromJson(json["submitter"]),
      );

  Map<String, dynamic> toJson() => {
        "contractId": contractId,
        "requestId": requestId,
        "activity": activity?.toJson(),
        "type": type?.toJson(),
        "status": status?.toJson(),
        "actionType": actionType?.toJson(),
        "owner": owner?.toJson(),
        "actualSubmitter": actualSubmitter?.toJson(),
        "submitter": submitter?.toJson(),
      };
}

class Type {
  final int? id;
  final String? name;

  Type({
    this.id,
    this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Activity {
  final int? isicNumber;
  final String? name;

  Activity({
    this.isicNumber,
    this.name,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        isicNumber: json["isicNumber"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "isicNumber": isicNumber,
        "name": name,
      };
}

class ActualSubmitter {
  final String? identityNumber;
  final int? identityType;

  ActualSubmitter({
    this.identityNumber,
    this.identityType,
  });

  factory ActualSubmitter.fromJson(Map<String, dynamic> json) =>
      ActualSubmitter(
        identityNumber: json["identityNumber"],
        identityType: json["identityType"],
      );

  Map<String, dynamic> toJson() => {
        "identityNumber": identityNumber,
        "identityType": identityType,
      };
}

class Status {
  final String? id;
  final String? name;

  Status({
    this.id,
    this.name,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
