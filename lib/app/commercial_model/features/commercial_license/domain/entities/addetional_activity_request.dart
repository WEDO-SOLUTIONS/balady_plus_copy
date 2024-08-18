// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:balady_plus/app/commercial_model/features/commercial_license/data/models/additional_activity_details_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/data/models/additional_activity_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/domain/entities/sub_activity_details_entity.dart';
import 'package:equatable/equatable.dart';

class AddetionalActivityRequest extends Equatable {
  AddetionalActivityItem? item;
  AddetionalActivityItemDetails? detailsItem;
  SubActivityDetails? details;
  String? faweryMessage;

  double? area;
  AddetionalActivityRequest(
      {this.item,
      this.detailsItem,
      this.details,
      this.area,
      this.faweryMessage});

  AddetionalActivityRequest copyWith(
      {AddetionalActivityItem? item,
      AddetionalActivityItemDetails? detailsItem,
      SubActivityDetails? details,
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
