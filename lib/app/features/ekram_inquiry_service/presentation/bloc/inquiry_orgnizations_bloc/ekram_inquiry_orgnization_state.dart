import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/nullable.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../data/models/find_cemetry_response_model.dart';
import '../../../data/models/orgnization_charity_list.dart';

class EkramOrgnizationCemetryState extends Equatable {
  final String? errorMsg;
  final BlocStatus status;
  final List<EkramCharityOrgnizationItem>? charityOrgnizations;
  final List<LookUpItem>? cities;
  final LookUpItem? selectedCity;

  const EkramOrgnizationCemetryState({
    this.errorMsg,
    this.status = BlocStatus.initial,
    this.cities,
    this.selectedCity,
    this.charityOrgnizations,
  });

  @override
  List<Object?> get props => [
        errorMsg,
        status,
        charityOrgnizations,
        selectedCity,
      ];

  EkramOrgnizationCemetryState copyWith({
    String? errorMsg,
    BlocStatus? status,
    List<EkramCharityOrgnizationItem>? charityOrgnizations,
    List<LookUpItem>? cities,
    Nullable<LookUpItem?>? selectedCity,
  }) {
    return EkramOrgnizationCemetryState(
      errorMsg: errorMsg ?? this.errorMsg,
      status: status ?? this.status,
      charityOrgnizations: charityOrgnizations ?? this.charityOrgnizations,
      cities: cities ?? this.cities,
      selectedCity:
          selectedCity == null ? this.selectedCity : selectedCity.value,
    );
  }
}
