import '../../data/models/entity_violation_activity_details_model.dart';
import '../../data/models/violation_details_vd_model.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/details/domain/entities/entity_activity_details_response.dart';
import '/app/features/details/domain/entities/regulation_response.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/entity_violation_activity_model.dart';

class ViolationDetailsState extends Equatable {
  final String? regulationErrorMsg;
  final EntityViolationActivityDetailsModel? response;

  final EntityActivityDetailsResponse? entityActivityDetailsResponse;
  final BlocStatus entityActivityDetailsStatus;
  final String? entityActivityDetailsErrorMsg;
  final BlocStatus violationDetailsStatus;
  final int noOfOccurences;

  ViolationDetailsState(
      {this.regulationErrorMsg,
      this.response,
      this.entityActivityDetailsResponse,
      this.entityActivityDetailsStatus = BlocStatus.initial,
      this.violationDetailsStatus = BlocStatus.initial,
      this.entityActivityDetailsErrorMsg,
      this.noOfOccurences = 1});

  @override
  List<Object?> get props => [
        violationDetailsStatus,
        regulationErrorMsg,
        entityActivityDetailsResponse,
        entityActivityDetailsStatus,
        entityActivityDetailsErrorMsg,
        noOfOccurences
      ];

  ViolationDetailsState copyWith(
      {RegulationResponse? regulationResponse,
      BlocStatus? regulationStatus,
      BlocStatus? violationDetailsStatus,
      String? regulationErrorMsg,
      final EntityActivityDetailsResponse? entityActivityDetailsResponse,
      final BlocStatus? entityActivityDetailsStatus,
      final String? entityActivityDetailsErrorMsg,
      final BlocStatus? violationStatus,
      final List<EntityViolationActivityModel>? violations,
      final List<ViolationDetailsVdModel>? vdViolationList,
      final BlocStatus? vdViolationStatus,
      final EntityViolationActivityDetailsModel? response,
      final int? noOfOccurences}) {
    return ViolationDetailsState(
        response: response ?? this.response,
        violationDetailsStatus:
            violationDetailsStatus ?? this.violationDetailsStatus,
        regulationErrorMsg: regulationErrorMsg ?? this.regulationErrorMsg,
        entityActivityDetailsResponse:
            entityActivityDetailsResponse ?? this.entityActivityDetailsResponse,
        entityActivityDetailsStatus:
            entityActivityDetailsStatus ?? this.entityActivityDetailsStatus,
        entityActivityDetailsErrorMsg:
            entityActivityDetailsErrorMsg ?? this.entityActivityDetailsErrorMsg,
        noOfOccurences: noOfOccurences ?? this.noOfOccurences);
  }
}
