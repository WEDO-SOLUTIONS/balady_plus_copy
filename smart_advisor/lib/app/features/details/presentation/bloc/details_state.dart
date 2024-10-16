import '../../data/models/violation_details_vd_model.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/details/domain/entities/entity_activity_details_response.dart';
import '/app/features/details/domain/entities/regulation_response.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/entity_violation_activity_model.dart';

class DetailsState extends Equatable {
  final RegulationResponse? regulationResponse;
  final BlocStatus regulationStatus;
  final String? regulationErrorMsg;

  final EntityActivityDetailsResponse? entityActivityDetailsResponse;
  final BlocStatus entityActivityDetailsStatus;
  final String? entityActivityDetailsErrorMsg;

  final List<EntityViolationActivityModel>? violations;
  final BlocStatus violationStatus;
  final BlocStatus violationDetailsStatus;
  final List<ViolationDetailsVdModel>? vdViolationList;
  final BlocStatus vdViolationStatus;

  DetailsState(
      {this.regulationResponse,
      this.regulationStatus = BlocStatus.initial,
      this.regulationErrorMsg,
      this.entityActivityDetailsResponse,
      this.entityActivityDetailsStatus = BlocStatus.initial,
      this.violationDetailsStatus = BlocStatus.initial,
      this.violationStatus = BlocStatus.initial,
      this.vdViolationStatus = BlocStatus.initial,
      this.vdViolationList,
      this.violations,
      this.entityActivityDetailsErrorMsg});

  @override
  List<Object?> get props => [
        violationDetailsStatus,
        regulationResponse,
        regulationStatus,
        regulationErrorMsg,
        entityActivityDetailsResponse,
        entityActivityDetailsStatus,
        entityActivityDetailsErrorMsg,
        violationStatus,
        vdViolationList,
        vdViolationStatus
      ];

  DetailsState copyWith(
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
      final BlocStatus? vdViolationStatus}) {
    return DetailsState(
        vdViolationList: vdViolationList ?? this.vdViolationList,
        vdViolationStatus: vdViolationStatus ?? this.vdViolationStatus,
        violationStatus: violationStatus ?? this.violationStatus,
        violationDetailsStatus:
            violationDetailsStatus ?? this.violationDetailsStatus,
        regulationResponse: regulationResponse ?? this.regulationResponse,
        regulationStatus: regulationStatus ?? this.regulationStatus,
        regulationErrorMsg: regulationErrorMsg ?? this.regulationErrorMsg,
        entityActivityDetailsResponse:
            entityActivityDetailsResponse ?? this.entityActivityDetailsResponse,
        entityActivityDetailsStatus:
            entityActivityDetailsStatus ?? this.entityActivityDetailsStatus,
        entityActivityDetailsErrorMsg:
            entityActivityDetailsErrorMsg ?? this.entityActivityDetailsErrorMsg,
        violations: violations ?? this.violations);
  }

  Map<String, List<EntityViolationActivityModel>> getViolations() {
    Map<String, List<EntityViolationActivityModel>> maps = {};

    violations?.forEach((element) {
      if (maps.containsKey(element.regulationName)) {
        List<EntityViolationActivityModel> list =
            maps[element.regulationName] ?? [];
        list.add(element);
        maps[element.regulationName ?? ""] = list;
      } else {
        List<EntityViolationActivityModel> list = [];
        list.add(element);
        maps[element.regulationName ?? ""] = list;
      }
    });
    print("FDDD ${maps.keys}");
    return maps;
  }

  List<String> getSubClauses() {
    return vdViolationList
            ?.map((e) => e.subClauseName)
            .nonNulls
            .toSet()
            .toList() ??
        [];
  }
}
