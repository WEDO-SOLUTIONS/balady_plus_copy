import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../data/models/find_grave_response_model.dart';

class EkramInquiryGraveState extends Equatable {
  final String? errorMsg;
  final BlocStatus status;
  final List<FindGraveItem>? findGraveResponse;
  final List<LookUpItem>? cities;
  final List<LookUpItem>? nationalities;
  final List<LookUpItem>? nationalIdTypes;

  final String? fullName;
  final String? nationalId;
  final LookUpItem? selectedCity;
  final LookUpItem? selectedNationalIdType;
  final LookUpItem? selectedNationality;

  const EkramInquiryGraveState(
      {this.errorMsg,
      this.status = BlocStatus.initial,
      this.cities,
      this.selectedCity,
      this.findGraveResponse,
      this.fullName,
      this.nationalId,
      this.nationalIdTypes,
      this.nationalities,
      this.selectedNationalIdType,
      this.selectedNationality});

  @override
  List<Object?> get props => [
        errorMsg,
        status,
        findGraveResponse,
        cities,
        nationalities,
        nationalIdTypes,
        fullName,
        nationalId,
        selectedCity,
        selectedNationalIdType,
        selectedNationality,
      ];

  EkramInquiryGraveState copyWith({
    final String? errorMsg,
    final BlocStatus? status,
    final List<FindGraveItem>? findGraveResponse,
    final List<LookUpItem>? cities,
    final List<LookUpItem>? nationalities,
    final List<LookUpItem>? nationalIdTypes,
    final String? fullName,
    final String? nationalId,
    final LookUpItem? selectedCity,
    final LookUpItem? selectedNationalIdType,
    final LookUpItem? selectedNationality,
  }) {
    return EkramInquiryGraveState(
        errorMsg: errorMsg ?? this.errorMsg,
        status: status ?? this.status,
        findGraveResponse: findGraveResponse ?? this.findGraveResponse,
        cities: cities ?? this.cities,
        nationalities: nationalities ?? this.nationalities,
        selectedCity: selectedCity ?? this.selectedCity,
        nationalIdTypes: nationalIdTypes ?? this.nationalIdTypes,
        fullName: fullName ?? this.fullName,
        nationalId: nationalId ?? this.nationalId,
        selectedNationalIdType:
            selectedNationalIdType ?? this.selectedNationalIdType,
        selectedNationality: selectedNationality ?? this.selectedNationality);
  }

  bool isFormValid() {
    if (fullName?.isEmpty ?? true) {
      return false;
    }
    else {
      if (nationalId != null&&nationalId?.isNotEmpty == true) {
        if(selectedNationalIdType != null) {
          return true;
        } else {
          return false;
        }

      }
      else {
        return true;
      }
    }


    return true;
  }
}
