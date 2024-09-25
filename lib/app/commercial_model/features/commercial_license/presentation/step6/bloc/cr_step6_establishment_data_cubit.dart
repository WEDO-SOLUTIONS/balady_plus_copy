import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/domain/entities/citizen_info_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/data/entities/validators/email_validation.dart';
import '../../../../../../features/_shared_feature_/data/entities/validators/phone_number_validation.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/send_otp_response.dart';
import 'package:balady_plus/app/features/create_compliance/domain/entities/verify_otp_request.dart';
import 'package:balady_plus/app/features/create_compliance/domain/use_cases/send_otp.dart';
import 'package:balady_plus/app/features/create_compliance/domain/use_cases/verify_otp.dart';
import '../../../commercial_license_exports.dart'
    show
        CommercialLicenseBloc,
        GoToNextPageEvent,
        ValidateAprovals;
import '../../../data/models/citizen_info_model.dart';
import '../../../data/models/qr/apply_commercial_response_model.dart';
import '../../../data/models/qr/qr_lookup.dart';
import '../../../data/models/qr/save_enterprise_data_request.dart';
import '../../../domain/use_cases/apply_commercial_request.dart';
import '../../../domain/use_cases/get_citizen_info.dart';
import '../../../domain/use_cases/get_qr_lookup.dart';
import '../../../domain/use_cases/save_qr_enterprise_data.dart';

part 'cr_step6_establishment_data_state.dart';

class CRStep6EstablishmentCubit extends Cubit<CRStep6EstablishmentState> {
  final ApplyCommercialRequest _applyCommercialRequest;
  final SaveQrEnterpriseData _saveQrEnterpriseData;
  final GetQrLookUp _getQrLookUp;
  final GetCitizenInfo _getCitizenInfo;
  final SendOTP _sendOTP;
  final VerifyOTP _verifyOTP;
  CRStep6EstablishmentCubit()
      : _applyCommercialRequest = ApplyCommercialRequest(repository: sl()),
        _saveQrEnterpriseData = SaveQrEnterpriseData(repository: sl()),
        _getQrLookUp = GetQrLookUp(repository: sl()),
        _getCitizenInfo = GetCitizenInfo(repository: sl()),
        _sendOTP = SendOTP(repository: sl()),
        _verifyOTP = VerifyOTP(repository: sl()),
        super(CRStep6EstablishmentState(
            managerMobileNumber: CommonProperties.userInfo?.getPhone())) {}

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
    //if (state.applyResponse != null) return;
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
      if (state.applyResponse == null &&
          sl<CommercialLicenseBloc>().state.isDraft == true) {
        setQrDraftData();
      }

      String? managerMobileNumber = r.enterpriseInfo?.contactInfo?.mobile;
      if (managerMobileNumber != null &&
          managerMobileNumber.isNotEmpty &&
          !managerMobileNumber.startsWith("0")) {
        managerMobileNumber = "0" + managerMobileNumber;
      }
      emit(state.copyWith(
          crOwners: r.enterpriseInfo?.crOwners,
          contactInfo: r.enterpriseInfo?.contactInfo,
          managerMobileNumber: managerMobileNumber,
          applyStatus: BlocStatus.success,
          applyResponse: r));
      sl<CommercialLicenseBloc>().updateQrData(applyCommercialResponse: r);
    });
  }

  void updateQRSiteLocationType(QRSiteLocationType value) {
    emit(state.copyWith(errorMessage: "", siteLocationType: value));
  }

  void updateBuildingNature(QrLookUpItem value) {
    emit(state.copyWith(errorMessage: "", selectedBuildingNature: value));
  }

  void updateSiteNature(QrLookUpItem value) {
    emit(state.copyWith(errorMessage: "", selectedSiteNature: value));
  }

  void updateFields(
      {final String? buildingName,
      final String? buildingUnit,
      final String? buildingFloor,
      final String? buildingDirections,
      final String? siteName,
      final String? siteDesc,
      final String? siteLandmark,
      final String? buildingNumber,
      final String? addetionalNumber,
      final String? postalCode,
      final bool? paymentMethods}) {
    emit(state.copyWith(
        errorMessage: "",
        buildingName: buildingName,
        buildingUnit: buildingUnit,
        buildingFloor: buildingFloor,
        buildingDirections: buildingDirections,
        siteName: siteName,
        siteDesc: siteDesc,
        siteLandmark: siteLandmark,
        buildingNumber: buildingNumber,
        addetionalNumber: addetionalNumber,
        postalCode: postalCode,
        hasPaymentMethods: paymentMethods));
  }

  void updatePaymentsMethods({required int index, required bool value}) {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    List<QrLookUpItem> p = state.paymentsMethods ?? [];
    p[index].selected = value;
    emit(state.copyWith(paymentsMethods: p, status: BlocStatus.success));
  }

  void updateCrOwner({required CrOwner item, required int index}) {
    emit(
      state.copyWith(status: BlocStatus.loading, errorMessage: ""),
    );

    List<CrOwner> items = state.crOwners ?? [];
    items[index] = item;

    emit(
      state.copyWith(crOwners: items, status: BlocStatus.success),
    );
  }

  void updateManagerMobileNumber({String? mobile}) {
    emit(state.copyWith(
        errorMessage: "",
        managerMobileNumber: mobile,
        managerMobileNumberVerified: Nullable(false)));
  }

  void updateContactInfo({
    String? mobile,
    final String? phone,
    final String? mail,
    final String? website,
    final String? twitter,
    final String? instegram,
    final String? snapchat,
    final String? facebook,
    final String? whatsApp,
    final String? enterpriseUniqueCode,
  }) {
    ContactInfo info = state.contactInfo ?? ContactInfo();

    info = info.copyWith(
        mobile: CommonProperties.userInfo?.getPhone(),
        phone: phone,
        mail: mail,
        website: website,
        twitter: twitter,
        instegram: instegram,
        snapchat: snapchat,
        facebook: facebook,
        whatsApp: whatsApp,
        enterpriseUniqueCode: enterpriseUniqueCode);

    emit(state.copyWith(errorMessage: "", contactInfo: info));
  }

  void updateManagerData({
    final String? id,
    final String? birthDate,
  }) {
    emit(state.copyWith(
        errorMessage: "",
        birthDate: birthDate,
        nationalId: id,
        managerInfo: Nullable(null)));
  }

  void save() async {
    int? requestId =
        sl<CommercialLicenseBloc>().state.applyCommercialResponse?.requestId;

    emit(state.copyWith(status: BlocStatus.loading));
    NationalAddress nationalAddress = NationalAddress(
      additionalNumber: state.addetionalNumber,
      buildingNumber: state.buildingNumber,
      floorNumber: int.tryParse(state.buildingFloor ?? ""),
      unitNumber: state.buildingUnit,
      zipCode: state.postalCode,
    );
    SaveEnterprisDataRequest request = SaveEnterprisDataRequest(
        managerBirthDate: CommonFunctions.padHijriDate(state.birthDate),
        managerIdentityNumber: state.nationalId ?? "",
        managerNationalityId: null,
        managerNationalityName: null,
        managerProfessionalName: null,
        managerSexName: null,
        managerSexId: null,
        requestId: requestId,
        crOwners: state.crOwners,
        contactInfo:
            state.contactInfo?.copyWith(mobile: state.managerMobileNumber),
        hasPaymentMethods: state.hasPaymentMethods,
        paymentMethods: (state.paymentsMethods ?? [])
            .where((element) => element.selected == true)
            ?.map((e) => PaymentMethod(ename: e.ename, name: e.name, id: e.id))
            .toList(),
        qrEnterpriseLocationDto: QrEnterpriseLocationDto(
          nationalAddress: nationalAddress,
          siteLocationType: state.siteLocationType?.name,
          locationInsideBuildingDto:
              state.siteLocationType == QRSiteLocationType.INSIDE_BUILDING
                  ? LocationInsideBuildingDto(
                      accessDirections: state.buildingDirections,
                      buildingName: state.buildingName,
                      buildingNatureId: state.selectedBuildingNature?.id)
                  : null,
          locationOnStreetDto:
              state.siteLocationType == QRSiteLocationType.ON_STREET
                  ? LocationOnStreetDto(
                      siteName: state.siteName,
                      nearestLandmark: state.siteLandmark,
                      siteDescription: state.siteDesc,
                      siteNatureId: state.selectedSiteNature?.id)
                  : null,
        ));

    final failureOrSuccess = await _saveQrEnterpriseData(request);

    failureOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      emit(state.copyWith(status: BlocStatus.success));

      sl<CommercialLicenseBloc>().add(GoToNextPageEvent());
    });
  }

  void setQrDraftData() {
    QRSiteLocationType? siteLocationType;
    state.siteLocationType;

    String? siteLocationTypeStr =
        state.applyResponse?.comLicenseInfo?.locationInfo?.siteLocationType;

    if (siteLocationTypeStr == "INSIDE_BUILDING") {
      siteLocationType = QRSiteLocationType.INSIDE_BUILDING;
    } else if (siteLocationTypeStr == "ON_STREET") {
      siteLocationType = QRSiteLocationType.ON_STREET;
    }

    emit(state.copyWith(siteLocationType: siteLocationType));
  }

  void getCizienInfo() async {
    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

    final failOrSuccess = await _getCitizenInfo(CitizenInfoParams(
        id: state.nationalId ?? "",
        birthdate: CommonFunctions.padHijriDate(state.birthDate ?? "")));

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emit(
          state.copyWith(status: BlocStatus.success, managerInfo: Nullable(r)));
    });
  }

  Future<void> sendOTPHandler({bool? showOTPPage}) async {
    emit(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess = await _sendOTP(state.managerMobileNumber ?? "");

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
          status: BlocStatus.success, sendOtpResponse: Nullable(r)));
      if (showOTPPage == true)
        NavigationService.navigatorKey.currentState
            ?.pushNamed(CommercialRouteName.CommercialOtpScreen, arguments: this);
    });
  }

  Future<void> verifyOTPHandler(String otpValue) async {
    emit(state.copyWith(
      status: BlocStatus.loading,
    ));

    final failOrSuccess = await _verifyOTP(VerifyOTPRequest(
        mobileNumber: state.managerMobileNumber ?? "",
        token: otpValue,
        tokenId: state.sendOtpResponse?.tokenId ?? ""));

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        errorMessage: (l as ServerFailure).errorMessage,
        status: BlocStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
          status: BlocStatus.success,
          managerMobileNumberVerified: Nullable(true)));
    });
  }
}
