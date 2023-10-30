import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/commercial_license/domain/entities/verifiy_salama_requst.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/qr/qr_lookup.dart';
import '../../../domain/entities/commercial_board_type.dart';
import '../../../domain/entities/save_shop_details_request.dart';
import '../../../domain/use_cases/fawry_salama_bills.dart';
import '../../../domain/use_cases/fawry_salama_reports.dart';
import '../../../domain/use_cases/get_clean_contracts.dart';
import '../../../domain/use_cases/get_deed_info.dart';
import '../../../domain/use_cases/get_ejar_info.dart';
import '../../../domain/use_cases/get_investment_contracts.dart';
import '../../../domain/use_cases/get_malls.dart';
import '../../../domain/use_cases/save_shop_details.dart';
import '../../../domain/use_cases/validate_salama_bill.dart';
import '../../../domain/use_cases/validate_salama_report.dart';
import '../../step3/bloc/map_bloc.dart';
import 'package:collection/collection.dart';
part 'cr_step4_shop_data_state.dart';

class CrStep4ShopDataCubit extends Cubit<CrStep4ShopDataState> {
  final GetAccommodationTypes _getAccommodationTypes;
  final GetCleanContracts _getCleanContracts;
  final GetInvestmentContracts _getInvestmentContracts;

  final SaveShopDetails _saveShopDetails;
  final GetCleanOptions _getCleanOptions;
  final GetDeedOptions _getDeedOptions;
  final GetEjarInfo _getEjarInfo;
  final GetDeedInfo _getDeedInfo;
  final GetFawrySalamaBills _getFawrySalamaBills;
  final GetFawrySalamaReports _getFawrySalamaReports;
  final GetMalls _getMalls;
  final ValidateSalamaPermit _validateSalamaPermit;
  final ValidateSalamaBill _validateSalamaBill;
  final ValidateSalamaReport _validateSalamaReport;

  CrStep4ShopDataCubit()
      : _getAccommodationTypes = GetAccommodationTypes(repository: sl()),
        _getCleanContracts = GetCleanContracts(repository: sl()),
        _getInvestmentContracts = GetInvestmentContracts(repository: sl()),
        _saveShopDetails = SaveShopDetails(repository: sl()),
        _getCleanOptions = GetCleanOptions(repository: sl()),
        _getDeedOptions = GetDeedOptions(repository: sl()),
        _getEjarInfo = GetEjarInfo(repository: sl()),
        _getDeedInfo = GetDeedInfo(repository: sl()),
        _getFawrySalamaReports = GetFawrySalamaReports(repository: sl()),
        _getFawrySalamaBills = GetFawrySalamaBills(repository: sl()),
        _getMalls = GetMalls(repository: sl()),
        _validateSalamaPermit = ValidateSalamaPermit(repository: sl()),
        _validateSalamaBill = ValidateSalamaBill(repository: sl()),
        _validateSalamaReport = ValidateSalamaReport(repository: sl()),
        super(CrStep4ShopDataState());

  void getAccommodationTypes() async {
    emit(state.copyWith(accommodationTypesStatus: BlocStatus.loading));
    final response = await _getAccommodationTypes(NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
              accommodationTypesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          accommodationTypesStatus: BlocStatus.success,
          accommodationTypes: List.from(success)));
    });
  }

  void onAccommodationTypes(DropDownItem accommodationTypes) =>
      emit(state.copyWith(selectedAccommodationType: accommodationTypes));

  void addBoard(CommercialBoardType board) {
    emit(state.copyWith(status: BlocStatus.loading));
    List<CommercialBoardType> selectedBoards = state.selectedBoards ?? [];

    int index = selectedBoards.indexWhere((element) => element.id == board.id);
    print(index);
    if (index == -1) {
      selectedBoards.add(board);
    } else {
      selectedBoards[index] = board;
    }
    print(selectedBoards.length);
    emit(state.copyWith(
        selectedBoards: selectedBoards, status: BlocStatus.success));
  }

  void updateFields(
      {final bool? brand,
      final String? shopName,
      final String? shopUnitNumber,
      final String? blockNumber,
      final int? holesCount,
      final int? floorCount,
      final int? noOfCameras,
      final bool? hasElevator,
      final int? floorNumber,
      final bool? isCitizenPledgedToClean}) {
    emit(state.copyWith(
        errorMessage: "",
        brand: brand,
        shopName: shopName,
        shopUnitNumber: shopUnitNumber,
        blockNumber: blockNumber,
        holesCount: holesCount,
        floorCount: floorCount,
        noOfCameras: noOfCameras,
        hasElevator: hasElevator,
        floorNumber: floorNumber,
        isCitizenPledgedToClean: Nullable(isCitizenPledgedToClean)));
  }

  void updateExistsInMallFields({
    final bool? existInMall,
  }) {
    emit(state.copyWith(
      errorMessage: "",
      existInMall: existInMall,
      selectedMall: Nullable(null),
    ));
  }

  void updateIsCitizenPledgedToClean(bool isCitizenPledgedToClean) {
    emit(state.copyWith(
        errorMessage: "",
        isCitizenPledgedToClean: Nullable(isCitizenPledgedToClean),
        cleanContractEndDate: Nullable(null)));

    if (isCitizenPledgedToClean == true &&
        state.cleanContractshowService() &&
        (state.cleanOptionCLEANCONTRACT() || state.cleanOptionOPTIONAL()))
      getCleanContracts();
  }

  void updateSalamaPermitExists({
    final bool? salamaPermitExist,
  }) {
    emit(state.copyWith(
        errorMessage: "",
        salamaPermitExist: salamaPermitExist,
        salamaPermitNumber: Nullable(null),
        slamaReportNumber: Nullable(null),
        slamaBillNumber: Nullable(null)));
  }

  void updateSalamaPermitNumber({
    final String? salamaPermitNumber,
  }) {
    emit(state.copyWith(
        errorMessage: "",
        salamaPermitNumber: Nullable(salamaPermitNumber),
        slamaReportNumber: Nullable(null),
        slamaBillNumber: Nullable(null)));
  }

  void updateSalamaPermitBill({
    final String? salamaBillNumber,
  }) {
    emit(state.copyWith(
        errorMessage: "",
        salamaPermitNumber: Nullable(null),
        slamaReportNumber: Nullable(null),
        slamaBillNumber: Nullable(salamaBillNumber)));
  }

  void updateSalamaPermitReport({
    final String? salamaReportNumber,
  }) {
    emit(state.copyWith(
        errorMessage: "",
        salamaPermitNumber: Nullable(null),
        slamaReportNumber: Nullable(salamaReportNumber),
        slamaBillNumber: Nullable(null)));
  }

  void updateSubmitterType(CRSubmitterType type) {
    emit(state.copyWith(
      errorMessage: "",
      crSubmitterType: Nullable(type),
      crContractType: Nullable(null),
      crContractOption: Nullable(null),
      contractNumber: Nullable(null),
      contractDate: Nullable(null),
      selectedInvestmentContract: Nullable(null),
    ));
  }

  void updateCRContractType(CRContractType type) {
    emit(state.copyWith(
      errorMessage: "",
      crContractType: Nullable(type),
      crContractOption: Nullable(null),
      contractNumber: Nullable(null),
      contractDate: Nullable(null),
      selectedInvestmentContract: Nullable(null),
    ));
  }

  void updateCRContractOption(CRContractOption type) {
    emit(state.copyWith(
      errorMessage: "",
      crContractOption: Nullable(type),
      contractNumber: Nullable(null),
      contractDate: Nullable(null),
      selectedInvestmentContract: Nullable(null),
    ));

    getInvestmentContracts();
  }

  void updateContractNumber(String value) {
    emit(state.copyWith(
      errorMessage: "",
      contractNumber: Nullable(value),
    ));
  }

  void updateContractDate(String value) {
    emit(state.copyWith(
      errorMessage: "",
      contractDate: Nullable(value),
    ));
  }

  void updateCleanContractDate(String value) {
    emit(state.copyWith(
      errorMessage: "",
      cleanContractEndDate: Nullable(value),
    ));
  }

  void selectInvestmentContract(InvestmentContractItem? item) {
    emit(state.copyWith(
      errorMessage: "",
      selectedInvestmentContract: Nullable(item),
    ));
  }

  void getCleanContracts() async {
    if (!state.cleanContractshowService() &&
        state.isCitizenPledgedToClean == true) return;
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(
        contractsListStatus: BlocStatus.loading, errorMessage: ""));
    final response =
        await _getCleanContracts(CleanContractsRequest(requestId: requestId));
    response.fold(
        (failure) => emit(state.copyWith(
              isCitizenPledgedToClean: Nullable(null),
              contractsListStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          contractsListStatus: BlocStatus.success,
          cleanContractsResponse: success));
    });
  }

  void getInvestmentContracts() async {
    if (state.crContractType == CRContractType.invest &&
        state.crSubmitterType == CRSubmitterType.rental &&
        state.crContractOption == CRContractOption.service) {
      int requestId = sl<CommercialLicenseBloc>().state.requestId!;

      emit(state.copyWith(
          investmentListStatus: BlocStatus.loading, errorMessage: ""));
      final response = await _getInvestmentContracts(
          InvestmentContractRequest(requestId: requestId));
      response.fold(
          (failure) => emit(state.copyWith(
                investmentListStatus: BlocStatus.failure,
                errorMessage: (failure as ServerFailure).errorMessage,
              )), (success) {
        emit(state.copyWith(
            investmentListStatus: BlocStatus.success,
            investmentContractResponse: success));
      });
    }
  }

  void initForm() {
    SaveLocationResponse? res =
        sl<CommercialLicenseBloc>().state.locationResponse;

    emit(state.copyWith(locationResponse: res, errorMessage: ""));
  }

  SaveLocationResponse? get saveLocationResponse =>
      sl<CommercialLicenseBloc>().state.locationResponse;

  String get cameraEndorsmentText =>
      sl<CommercialLicenseBloc>().state.locationResponse?.endorsementText ?? "";

  void save() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    SaveShopDetailsRequest request = SaveShopDetailsRequest(
        requestId: requestId,
        boardsInfo: state.selectedBoards,
        brand: state.brand,
        floorNumber: state.floorNumber,
        hasElevator: state.hasElevator,
        isCitizenPledgedToClean: state.isCitizenPledgedToClean,
        shopName: state.shopName,
        shopUnitNumber: state.shopUnitNumber,
        holesCount: state.holesCount.toString(),
        floorCount: state.floorCount.toString(),
        noOfCameras: state.noOfCameras.toString(),
        existInMall: state.existInMall,
        contractDate: CommonFunctions.padHijriDate(state.contractDate ?? ""),
        contractNumber: state.contractNumber,
        contractType: state.crContractType?.name,
        contractOption: state.crContractOption?.name,
        cleanContractEndDate:
            CommonFunctions.padHijriDate(state.cleanContractEndDate ?? ""),
        investmentContractNumber:
            state.selectedInvestmentContract?.siteContractId,
        salamaBillNumber: state.slamaBillNumber,
        salamaPermitExist: state.salamaPermitExist,
        salamaPermitNumber: state.salamaPermitNumber,
        slamaReportNumber: state.slamaReportNumber,
        ejarContractInfo:
            state.ejarVerified == true ? state.ejarInfoRequst : null,
        deedInfo: state.deedVerified == true ? state.deedInfoRequst : null,
        cleanContractNumber:
            state.selectedCleanContract?.unifiedCleanContractNo.toString(),
        selectedBoardContractOption: "MANUAL");
    final failOrSuccess = await _saveShopDetails(request);

    failOrSuccess.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));
      emit(state.copyWith(status: BlocStatus.success));
    });

    /* final response = await _saveActivityDetails(SubmitActivityDetailRequest(
        requestId: requestId,
        workerTypeId: state.workerType!.index,
        area: state.totalArea ?? 0,
        detailedActivityId: state.selectedSubActivity!.id!));

    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));
      emit(state.copyWith(status: BlocStatus.success));
    });*/
  }

  void salamaReportFawery() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(
        samalaReportFawryStatus: BlocStatus.loading, errorMessage: ""));
    final response = await _getFawrySalamaReports(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              samalaReportFawryStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          samalaReportFawryStatus: BlocStatus.success, isFawryReport: success));
    });
  }

  void salamaBillFawery() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(
        samalaBillFawryStatus: BlocStatus.loading, errorMessage: ""));
    final response = await _getFawrySalamaBills(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              samalaBillFawryStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          samalaBillFawryStatus: BlocStatus.success, isFawryBill: success));
    });
  }

  void getDeedOwnerShipsTypes() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(deedOptionsStatus: BlocStatus.loading));
    final response = await _getDeedOptions(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              deedOptionsStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          deedOptionsStatus: BlocStatus.success, deedOptions: success));
    });
  }

  void getCleanOptions() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(
        cleanOptionsStatus: BlocStatus.loading, errorMessage: ""));
    final response = await _getCleanOptions(requestId);
    response.fold(
        (failure) => emit(state.copyWith(
              cleanOptionsStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          cleanOptionsStatus: BlocStatus.success,
          cleanOptionResponse: success));
    });
  }

  void updateDeedInfo({String? ownershipType, String? deedNumber}) {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    state.copyWith(status: BlocStatus.loading, errorMessage: "");

    DeedInfoRequest deedInfoRequst =
        state.deedInfoRequst ?? DeedInfoRequest(requestId: requestId);

    deedInfoRequst = deedInfoRequst.copyWith(
      ownershipType: ownershipType,
      deedNumber: deedNumber,
    );

    emit(state.copyWith(
        status: BlocStatus.success,
        deedInfoRequst: deedInfoRequst,
        deedVerified: Nullable(false),
        errorMessage: ""));
  }

  void updateTenancyInfo(
      {String? id, String? tenancyContractNumber, String? versionNumber}) {
    state.copyWith(status: BlocStatus.loading, errorMessage: "");

    EjarInfoRequest ejarInfoRequst = state.ejarInfoRequst ?? EjarInfoRequest();

    String nationalId = ejarInfoRequst.nationalId ?? "";
    String iqamaNumber = ejarInfoRequst.iqamaNumber ?? "";

    if (id?.startsWith("1") ?? false) {
      nationalId = id!;
      iqamaNumber = "";
    }
    if (id?.startsWith("2") ?? false) {
      nationalId = "";
      iqamaNumber = id!;
    }
    ejarInfoRequst = ejarInfoRequst.copyWith(
      iqamaNumber: iqamaNumber,
      nationalId: nationalId,
      tenancyContractNumber: tenancyContractNumber,
      versionNumber: versionNumber,
    );

    emit(state.copyWith(
        status: BlocStatus.success,
        ejarInfoRequst: ejarInfoRequst,
        ejarVerified: Nullable(false),
        errorMessage: ""));
  }

  Future<void> getDeedInfoHandler() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final failOrSuccess = await _getDeedInfo(state.deedInfoRequst ??
        DeedInfoRequest(
          requestId: requestId,
        ));
    failOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          deedVerified: Nullable(false),
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emit(state.copyWith(
          status: BlocStatus.success, deedVerified: Nullable(true)));
    });
  }

  Future<void> getEjarInfoHandler() async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final failOrSuccess =
        await _getEjarInfo(state.ejarInfoRequst ?? EjarInfoRequest());

    failOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          ejarVerified: Nullable(false),
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      print("success");
      emit(state.copyWith(
          status: BlocStatus.success, ejarVerified: Nullable(true)));
    });
  }

  void selectCleanContract(CleanContractItem? item) {
    emit(state.copyWith(
      errorMessage: "",
      selectedCleanContract: Nullable(item),
    ));
  }

  void getMalls() async {
    String districtId =
        sl<CommercialLicenseBloc>().state.gisResponse?.Balady_DistrictID ?? "";
    ;

    emit(state.copyWith(
      mallsStatus: BlocStatus.loading,
      errorMessage: "",
    ));

    final failOrSuccess = await _getMalls(districtId);

    failOrSuccess.fold((l) {
      emit(state.copyWith(
        //  errorMessage: (l as ServerFailure).errorMessage,
        mallsStatus: BlocStatus.failure,
      ));
    }, (r) {
      emit(
          state.copyWith(mallsStatus: BlocStatus.success, mallsList: r.result));
    });
  }

  void updateMall(QrLookUpItem value) {
    emit(state.copyWith(selectedMall: Nullable(value)));
  }

  Future<void> verifySalamaPermit() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final failOrSuccess = await _validateSalamaPermit(VerifySalamaRequest(
        requestId: requestId, number: state.salamaPermitNumber ?? ""));

    failOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          isSalamaPermitVerified: Nullable(false),
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emit(state.copyWith(
          status: BlocStatus.success, isSalamaPermitVerified: Nullable(true)));
    });
  }

  Future<void> verifySalamaBill() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final failOrSuccess = await _validateSalamaBill(VerifySalamaRequest(
        requestId: requestId, number: state.slamaBillNumber ?? ""));

    failOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          isSalamaBillVerified: Nullable(false),
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emit(state.copyWith(
          status: BlocStatus.success, isSalamaBillVerified: Nullable(true)));
    });
  }

  Future<void> verifySalamaReport() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final failOrSuccess = await _validateSalamaReport(VerifySalamaRequest(
        requestId: requestId, number: state.slamaReportNumber ?? ""));

    failOrSuccess.fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          isSalamaReportVerified: Nullable(false),
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emit(state.copyWith(
          status: BlocStatus.success, isSalamaReportVerified: Nullable(true)));
    });
  }
}
