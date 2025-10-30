import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/nullable.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../data/models/find_cemetry_response_model.dart';

class EkramInquiryCemetryState extends Equatable {
  final String? errorMsg;
  final BlocStatus status;
  final List<FindCemetryItem>? findCemetryResponse;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? distrcts;
  final LookUpItem? selectedCity;
  final LookUpItem? selectedDistrcit;
  final bool? laundryExist;
  final bool? muslim;

  const EkramInquiryCemetryState(
      {this.errorMsg,
      this.status = BlocStatus.initial,
      this.cities,
      this.distrcts,
      this.selectedCity,
      this.selectedDistrcit,
      this.findCemetryResponse,
      this.laundryExist,
      this.muslim = true});

  @override
  List<Object?> get props => [
        errorMsg,
        status,
        findCemetryResponse,
        selectedCity,
        selectedDistrcit,
        laundryExist,
        muslim
      ];

  EkramInquiryCemetryState copyWith({
    String? errorMsg,
    BlocStatus? status,
    List<FindCemetryItem>? findCemetryResponse,
    List<LookUpItem>? cities,
    List<LookUpItem>? distrcts,
    Nullable<LookUpItem?>? selectedCity,
    Nullable<LookUpItem?>? selectedDistrcit,
    Nullable<bool?>? laundryExist,
    Nullable<bool?>? muslim,
  }) {
    return EkramInquiryCemetryState(
        errorMsg: errorMsg ?? this.errorMsg,
        status: status ?? this.status,
        findCemetryResponse: findCemetryResponse ?? this.findCemetryResponse,
        cities: cities ?? this.cities,
        distrcts: distrcts ?? this.distrcts,
        selectedCity:
            selectedCity == null ? this.selectedCity : selectedCity.value,
        selectedDistrcit: selectedDistrcit == null
            ? this.selectedDistrcit
            : selectedDistrcit.value,
        laundryExist:
            laundryExist == null ? this.laundryExist : laundryExist.value,
        muslim: muslim == null ? this.muslim : muslim.value);
  }
}
