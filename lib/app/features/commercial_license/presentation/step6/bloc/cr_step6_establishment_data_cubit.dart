import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/utils_exports.dart';

import '../../../commercial_license_exports.dart'
    show
        AddBeneficiaryNotes,
        CommercialLicenseBloc,
        CrAddNotesRequest,
        CrAttachmentRequest,
        CredenceItem,
        GetRequestCredence,
        GoToNextPageEvent,
        UploadCredence,
        ValidateAprovals,
        ValidateSalamaAttachmentsRequest;
import '../../../data/models/qr/apply_commercial_response_model.dart';
import '../../../data/models/qr/citizen_info_model.dart';
import '../../../data/models/qr/qr_lookup.dart';
import '../../../data/models/qr/save_enterprise_data_request.dart';
import '../../../domain/use_cases/apply_commercial_request.dart';
import '../../../domain/use_cases/get_qr_lookup.dart';
import '../../../domain/use_cases/save_qr_enterprise_data.dart';

part 'cr_step6_establishment_data_state.dart';

class CRStep6EstablishmentCubit extends Cubit<CRStep6EstablishmentState> {
  final ApplyCommercialRequest _applyCommercialRequest;
  final SaveQrEnterpriseData _saveQrEnterpriseData;
  final GetQrLookUp _getQrLookUp;

  CRStep6EstablishmentCubit()
      : _applyCommercialRequest = ApplyCommercialRequest(repository: sl()),
        _saveQrEnterpriseData = SaveQrEnterpriseData(repository: sl()),
        _getQrLookUp = GetQrLookUp(repository: sl()),
        super(const CRStep6EstablishmentState()) {}

  void getPaymentMethods() async {
    if (state.paymentsMethods?.isNotEmpty ?? false) return;

    emit(state.copyWith(
      paymentsMethodsStatus: BlocStatus.loading,
      errorMessage: "",
    ));

    final failOrSuccess = await _getQrLookUp("PAYMENT_METHODS");

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        paymentsMethodsStatus: BlocStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
          paymentsMethodsStatus: BlocStatus.success,
          paymentsMethods: r.result));
    });
  }

  void getBuildingNature() async {
    if (state.buildingNature?.isNotEmpty ?? false) return;

    emit(state.copyWith(
      buildingNatureStatus: BlocStatus.loading,
      errorMessage: "",
    ));

    final failOrSuccess = await _getQrLookUp("BUILDING_NATURE");

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        buildingNatureStatus: BlocStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
          buildingNatureStatus: BlocStatus.success, buildingNature: r.result));
    });
  }

  void getSiteNature() async {
    if (state.siteNature?.isNotEmpty ?? false) return;

    emit(state.copyWith(
      siteNatureStatus: BlocStatus.loading,
      errorMessage: "",
    ));

    final failOrSuccess = await _getQrLookUp("SITE_NATURE");

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        siteNatureStatus: BlocStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
          siteNatureStatus: BlocStatus.success, siteNature: r.result));
    });
  }

  void getApplyCommercialRequest() async {
    if (state.applyResponse != null) return;
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;
    emit(state.copyWith(
      applyStatus: BlocStatus.loading,
      errorMessage: "",
    ));

    final failOrSuccess = await _applyCommercialRequest(requestId);

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        applyStatus: BlocStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
          crOwners: r.enterpriseInfo?.crOwners,
          contactInfo: r.enterpriseInfo?.contactInfo,
          applyStatus: BlocStatus.success,
          applyResponse: r));
    });
  }

  void updateQRSiteLocationType(QRSiteLocationType value) {
    emit(state.copyWith(siteLocationType: value));
  }

  void updateBuildingNature(QrLookUpItem value) {
    emit(state.copyWith(selectedBuildingNature: value));
  }

  void updateSiteNature(QrLookUpItem value) {
    emit(state.copyWith(selectedSiteNature: value));
  }

  void updateFields({
    final String? buildingName,
    final String? buildingUnit,
    final String? buildingFloor,
    final String? buildingDirections,
    final String? siteName,
    final String? siteDesc,
    final String? siteLandmark,
    final String? buildingNumber,
    final String? addetionalNumber,
    final String? postalCode,
  }) {
    emit(state.copyWith(
        buildingName: buildingName,
        buildingUnit: buildingUnit,
        buildingFloor: buildingFloor,
        buildingDirections: buildingDirections,
        siteName: siteName,
        siteDesc: siteDesc,
        siteLandmark: siteLandmark,
        buildingNumber: buildingNumber,
        addetionalNumber: addetionalNumber,
        postalCode: postalCode));
  }
}
