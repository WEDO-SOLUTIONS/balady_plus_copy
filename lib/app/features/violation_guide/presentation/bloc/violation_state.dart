import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/nullable.dart';
import '../../data/models/classification_response.dart';
import '../../data/models/establishment_size_response.dart';
import '../../data/models/regualation_cluses_details.dart';
import '../../data/models/regulation_clause_response.dart';
import '../../data/models/violator_response.dart';

class ViolationState extends Equatable {
  final BlocStatus status;
  final BlocStatus establishmentStatus;
  final BlocStatus ViolatorsStatus;
  final BlocStatus classificationStatus;
  final int currentStep;
  final int selectedIndex;
  final String? errorMessage;
  final GISParams? gisParams;
  final EstablishmentSizeResponse? establishmentSizeResponse;
  final ViolatorResponse? violatorResponse;
  final ViolationClassificationResponse? violationClassificationResponse;
  final RegulationClausesResponse? regulationClausesResponse;
  final EstablishmentSizeItem? selectedEstablishmentSizeItem;
  final ViolatorItem? violatorItem;
  final RegulationClauseDetails? details;
  final int? noOfRepetition;
  final RegulationClauseItem? selectedRegulationClauseItem;

  const ViolationState(
      {this.status = BlocStatus.initial,
      this.establishmentStatus = BlocStatus.initial,
      this.ViolatorsStatus = BlocStatus.initial,
      this.classificationStatus = BlocStatus.initial,
      required this.selectedIndex,
      this.errorMessage,
      required this.currentStep,
      this.gisParams,
      this.violationClassificationResponse,
      this.violatorResponse,
      this.establishmentSizeResponse,
      this.regulationClausesResponse,
      this.selectedEstablishmentSizeItem,
      this.violatorItem,
      this.details,
      this.noOfRepetition,
      this.selectedRegulationClauseItem});

  ViolationState copyWith(
      {final BlocStatus? status,
      final int? selectedIndex,
      final String? errorMessage,
      final int? currentStep,
      final BlocStatus? establishmentStatus,
      final BlocStatus? ViolatorsStatus,
      final BlocStatus? classificationStatus,
      final GISParams? gisParams,
      final EstablishmentSizeResponse? establishmentSizeResponse,
      final ViolatorResponse? violatorResponse,
      final ViolationClassificationResponse? violationClassificationResponse,
      final RegulationClausesResponse? regulationClausesResponse,
      final Nullable<EstablishmentSizeItem?>? selectedEstablishmentSizeItem,
      final ViolatorItem? violatorItem,
      final RegulationClauseDetails? details,
      final int? noOfRepetition,
      final RegulationClauseItem? selectedRegulationClauseItem}) {
    return ViolationState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        status: status ?? this.status,
        currentStep: currentStep ?? this.currentStep,
        errorMessage: errorMessage ?? this.errorMessage,
        establishmentStatus: establishmentStatus ?? this.establishmentStatus,
        ViolatorsStatus: ViolatorsStatus ?? this.ViolatorsStatus,
        classificationStatus: classificationStatus ?? this.classificationStatus,
        gisParams: gisParams ?? this.gisParams,
        regulationClausesResponse:
            regulationClausesResponse ?? this.regulationClausesResponse,
        establishmentSizeResponse:
            establishmentSizeResponse ?? this.establishmentSizeResponse,
        violatorResponse: violatorResponse ?? this.violatorResponse,
        violationClassificationResponse: violationClassificationResponse ??
            this.violationClassificationResponse,
        selectedEstablishmentSizeItem: selectedEstablishmentSizeItem == null
            ? this.selectedEstablishmentSizeItem
            : selectedEstablishmentSizeItem.value,
        violatorItem: violatorItem ?? this.violatorItem,
        details: details ?? this.details,
        noOfRepetition: noOfRepetition ?? this.noOfRepetition,
        selectedRegulationClauseItem:
            selectedRegulationClauseItem ?? this.selectedRegulationClauseItem);
  }

  List<RegulationClauseItem> critical() {
    return regulationClausesResponse?.result
            ?.where((element) => element.isCritical == true)
            .toList() ??
        [];
  }

  List<RegulationClauseItem> notCritical() {
    return regulationClausesResponse?.result
            ?.where((element) => element.isCritical == false)
            .toList() ??
        [];
  }

  @override
  List<Object?> get props => [
        status,
        selectedIndex,
        currentStep,
        classificationStatus,
        ViolatorsStatus,
        establishmentStatus,
        gisParams,
        selectedEstablishmentSizeItem,
        violatorItem,
        details,
        noOfRepetition,
        selectedRegulationClauseItem
      ];

  bool isFormValid() {
    bool isValid = true;
    if (violatorItem?.violatorIdNumber != null &&
        violatorItem?.violatorIdNumber != "003" &&
        selectedEstablishmentSizeItem == null) {
      isValid = false;
    }

    if (violationClassificationResponse == null) {
      isValid = false;
    }

    return isValid;
  }
}
