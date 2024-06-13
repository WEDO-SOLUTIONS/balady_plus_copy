import 'package:equatable/equatable.dart';

import 'cemetry_request_item.dart';

class CemetryRequestResponse extends Equatable {
  final List<CemetryRequestItem>? items;
  final int? totalItemCount;
  final int? totalPageCount;

  CemetryRequestResponse(
      {this.items, this.totalItemCount, this.totalPageCount});

  @override
  List<Object?> get props => [totalItemCount, totalPageCount];
}
