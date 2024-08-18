import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import '../../../commercial_license_exports.dart'
    show
        AddBeneficiaryNotes,
        AddtionalQrDataRequest,
        CommercialLicenseBloc,
        CrAddNotesRequest,
        CrAttachmentRequest,
        CredenceItem,
        GetRequestCredence,
        GoToNextPageEvent,
        UpdateQrDataEvent,
        UploadCredence,
        ValidateAprovals,
        ValidateSalamaAttachmentsRequest;
import '../../../domain/use_cases/save_addetional_qr_data.dart';

part 'cr_step10_addetional_data_state.dart';

class CRStep10AddetionalDataCubit extends Cubit<CRStep10AddetionalState> {
  final SaveAddetionalQrData _applyCommercialRequest;

  CRStep10AddetionalDataCubit()
      : _applyCommercialRequest = SaveAddetionalQrData(repository: sl()),
        super(CRStep10AddetionalState()) {}

  void updateFields(
      {String? electAccountNumber,
      String? hasDelivery,
      String? hasElectronicSale,
      String? hasVehicleParking,
      bool? serveDisabledPersons,
      String? siteDeliveryName,
      bool? thereIsOuterInvestablePlace,
      String? waterAccountNumber}) {
    emit(state.copyWith(
        electAccountNumber: electAccountNumber,
        hasDelivery: hasDelivery,
        hasElectronicSale: hasElectronicSale,
        hasVehicleParking: hasVehicleParking,
        serveDisabledPersons: serveDisabledPersons,
        siteDeliveryName: siteDeliveryName,
        thereIsOuterInvestablePlace: thereIsOuterInvestablePlace,
        waterAccountNumber: waterAccountNumber));
  }

  void updateSiteDeliveryType({
    String? siteDeliveryType,
  }) {
    emit(state.copyWith(
      siteDeliveryType: Nullable(siteDeliveryType),
    ));
  }

  void updateHasParking({
    bool? hasParking,
  }) {
    emit(state.copyWith(
      hasParking: hasParking,
      parkingCount: Nullable(null),
    ));
  }

  void updateParkingCount({String? parkingCount}) {
    emit(state.copyWith(
      parkingCount: Nullable(int.tryParse(parkingCount ?? "")),
    ));
  }

  void save() async {
    int? requestId =
        sl<CommercialLicenseBloc>().state.applyCommercialResponse?.requestId;

    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess =
        await _applyCommercialRequest(AddtionalQrDataRequest(
      requestId: requestId,
      electAccountNumber: state.electAccountNumber,
      hasDelivery: state.hasDelivery ?? "NO",
      hasElectronicSale: state.hasElectronicSale ?? "NO",
      hasParking: state.hasParking ?? false,
      hasVehicleParking: state.hasVehicleParking ?? "NO",
      parkingCount: state.parkingCount,
      serveDisabledPersons: state.serveDisabledPersons ?? false,
      siteDeliveryName: state.siteDeliveryName,
      siteDeliveryType: state.siteDeliveryType,
      thereIsOuterInvestablePlace: state.thereIsOuterInvestablePlace ?? false,
      waterAccountNumber: state.waterAccountNumber,
    ));

    failureOrSuccess.fold((l) {
      emit(
        state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            status: BlocStatus.failure),
      );
    }, (r) {
      emit(
        state.copyWith(errorMessage: "", status: BlocStatus.success),
      );
      sl<CommercialLicenseBloc>().add(const GoToNextPageEvent());
    });
  }
}
