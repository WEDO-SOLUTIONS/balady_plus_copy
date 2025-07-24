// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../../../features/_shared_feature_/data/entities/drop_down_item.dart';
import 'sub_activity_details_data.dart';

class AddetionalActivityRequest extends Equatable {
  AllowedActivities? item;
  AddetionalActivityItemDetails? detailsItem;
  SubActivityDetailsData? details;
  String? faweryMessage;

  double? area;
  AddetionalActivityRequest(
      {this.item,
      this.detailsItem,
      this.details,
      this.area,
      this.faweryMessage});

  AddetionalActivityRequest copyWith(
      {AllowedActivities? item,
      AddetionalActivityItemDetails? detailsItem,
        SubActivityDetailsData? details,
      double? area,
      String? faweryMessage}) {
    return AddetionalActivityRequest(
        item: item ?? this.item,
        detailsItem: detailsItem ?? this.detailsItem,
        details: details ?? this.details,
        area: area ?? this.area,
        faweryMessage: faweryMessage ?? this.faweryMessage);
  }

  @override
  List<Object?> get props => [item];
}

class AddetionalActivityItemDetails extends DropDownItem {
  final int? activityId;
  final String? activityName;
  final int? isicNumber;
  final String? isicName;
  final int? masterActivityId;
  final String? masterActivityName;
  final double? maxArea;
  final double? minArea;
  final bool? homogeneous;

  AddetionalActivityItemDetails({
    this.activityId,
    this.activityName,
    this.isicNumber,
    this.isicName,
    this.masterActivityId,
    this.masterActivityName,
    this.maxArea,
    this.minArea,
    this.homogeneous,
  }) : super(
    id: activityId ?? '',
    name: isicName ?? '',
  );

  factory AddetionalActivityItemDetails.fromJson(Map<String, dynamic> json) =>
      AddetionalActivityItemDetails(
        activityId: json["activityId"],
        activityName: json["activityName"],
        isicNumber: json["isicNumber"],
        isicName: json["isicName"],
        masterActivityId: json["masterActivityId"],
        masterActivityName: json["masterActivityName"],
        maxArea: json["maxArea"]?.toDouble(),
        minArea: json["minArea"]?.toDouble(),
        homogeneous: json["homogeneous"],
      );

  Map<String, dynamic> toJson() => {
    "activityId": activityId,
    "activityName": activityName,
    "isicNumber": isicNumber,
    "isicName": isicName,
    "masterActivityId": masterActivityId,
    "masterActivityName": masterActivityName,
    "maxArea": maxArea,
    "minArea": minArea,
    "homogeneous": homogeneous,
  };
}
