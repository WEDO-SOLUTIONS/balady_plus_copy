import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DeceasedInfoDto extends Equatable {
  final LookUpItem? burialCityId;
  final LookUpItem? genderId;
  final bool? multipleCityRequest;
  final bool? muslimReligion;
  final String? name;
  final LookUpItem? nationalityId;
  final bool? specialTransferNeeded;
  final String? specialTransferOtherReason;
  final LookUpItem? specialTransferReasonId;

  DeceasedInfoDto(
      {this.burialCityId,
      this.genderId,
      this.multipleCityRequest,
      this.muslimReligion,
      this.name,
      this.nationalityId,
      this.specialTransferNeeded,
      this.specialTransferOtherReason,
      this.specialTransferReasonId});

  DeceasedInfoDto copyWith(
      {final LookUpItem? burialCityId,
      final LookUpItem? genderId,
      final bool? multipleCityRequest,
      final bool? muslimReligion,
      final String? name,
      final LookUpItem? nationalityId,
      final bool? specialTransferNeeded,
      final String? specialTransferOtherReason,
      final LookUpItem? specialTransferReasonId}) {
    return DeceasedInfoDto(
        burialCityId: multipleCityRequest == false
            ? null
            : burialCityId ?? this.burialCityId,
        genderId: genderId ?? this.genderId,
        multipleCityRequest: multipleCityRequest ?? this.multipleCityRequest,
        muslimReligion: muslimReligion ?? this.muslimReligion,
        name: name ?? this.name,
        nationalityId: nationalityId ?? this.nationalityId,
        specialTransferNeeded:
            specialTransferNeeded ?? this.specialTransferNeeded,
        specialTransferOtherReason: specialTransferNeeded == false
            ? null
            : specialTransferOtherReason ?? this.specialTransferOtherReason,
        specialTransferReasonId: specialTransferNeeded == false
            ? null
            : specialTransferReasonId ?? this.specialTransferReasonId);
  }

  Map<String, dynamic> toMap() => {
        "burialCityId": burialCityId?.id,
        "genderId": genderId?.id,
        "multipleCityRequest": multipleCityRequest,
        "isMuslimReligion": muslimReligion,
        "name": name,
        "nationalityId": nationalityId?.id,
        "specialTransferNeeded": specialTransferNeeded,
        "specialTransferOtherReason": specialTransferOtherReason,
        "specialTransferReasonId": specialTransferReasonId?.id,
        "anonymous": false
      };

  String getReligion() {
    return (muslimReligion == false) ? ("non_muslim").tr() : ("muslim").tr();
  }

  @override
  List<Object?> get props => [
        burialCityId,
        genderId,
        multipleCityRequest,
        muslimReligion,
        name,
        nationalityId,
        specialTransferNeeded,
        specialTransferOtherReason,
        specialTransferReasonId
      ];
}
