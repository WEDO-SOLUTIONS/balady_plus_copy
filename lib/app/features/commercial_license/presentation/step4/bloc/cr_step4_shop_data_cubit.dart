import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../domain/entities/commercial_board_type.dart';
import '../../../domain/entities/save_shop_details_request.dart';
import '../../../domain/use_cases/get_clean_contracts.dart';
import '../../../domain/use_cases/get_deed_info.dart';
import '../../../domain/use_cases/get_ejar_info.dart';
import '../../../domain/use_cases/get_investment_contracts.dart';
import '../../../domain/use_cases/save_shop_details.dart';
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

  CrStep4ShopDataCubit()
      : _getAccommodationTypes = GetAccommodationTypes(repository: sl()),
        _getCleanContracts = GetCleanContracts(repository: sl()),
        _getInvestmentContracts = GetInvestmentContracts(repository: sl()),
        _saveShopDetails = SaveShopDetails(repository: sl()),
        _getCleanOptions = GetCleanOptions(repository: sl()),
        _getDeedOptions = GetDeedOptions(repository: sl()),
        _getEjarInfo = GetEjarInfo(repository: sl()),
        _getDeedInfo = GetDeedInfo(repository: sl()),
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
      final bool? existInMall,
      final int? floorNumber,
      final bool? isCitizenPledgedToClean}) {
    emit(state.copyWith(
        brand: brand,
        shopName: shopName,
        shopUnitNumber: shopUnitNumber,
        blockNumber: blockNumber,
        holesCount: holesCount,
        floorCount: floorCount,
        noOfCameras: noOfCameras,
        hasElevator: hasElevator,
        existInMall: existInMall,
        floorNumber: floorNumber,
        isCitizenPledgedToClean: isCitizenPledgedToClean));
  }

  void updateIsCitizenPledgedToClean(bool isCitizenPledgedToClean) {
    emit(state.copyWith(
        isCitizenPledgedToClean: isCitizenPledgedToClean,
        cleanContractEndDate: Nullable(null)));
  }

  void updateSalama(
      {final bool? salamaPermitExist,
      final String? salamaPermitNumber,
      final String? slamaReportNumber}) {
    emit(state.copyWith(
        salamaPermitExist: salamaPermitExist,
        salamaPermitNumber:
            salamaPermitNumber != null ? Nullable(salamaPermitNumber) : null,
        slamaReportNumber: salamaPermitNumber != null
            ? Nullable((salamaPermitNumber))
            : null));
  }

  void updateSubmitterType(CRSubmitterType type) {
    emit(state.copyWith(
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
      crContractType: Nullable(type),
      crContractOption: Nullable(null),
      contractNumber: Nullable(null),
      contractDate: Nullable(null),
      selectedInvestmentContract: Nullable(null),
    ));
  }

  void updateCRContractOption(CRContractOption type) {
    emit(state.copyWith(
      crContractOption: Nullable(type),
      contractNumber: Nullable(null),
      contractDate: Nullable(null),
      selectedInvestmentContract: Nullable(null),
    ));

    getInvestmentContracts();
  }

  void updateContractNumber(String value) {
    emit(state.copyWith(
      contractNumber: Nullable(value),
    ));
  }

  void updateContractDate(String value) {
    emit(state.copyWith(
      contractDate: Nullable(value),
    ));
  }

  void updateCleanContractDate(String value) {
    emit(state.copyWith(
      cleanContractEndDate: Nullable(value),
    ));
  }

  void selectInvestmentContract(InvestmentContractItem? item) {
    emit(state.copyWith(
      selectedInvestmentContract: Nullable(item),
    ));
  }

  void getCleanContracts() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(contractsListStatus: BlocStatus.loading));
    final response =
        await _getCleanContracts(CleanContractsRequest(requestId: requestId));
    response.fold(
        (failure) => emit(state.copyWith(
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

      emit(state.copyWith(investmentListStatus: BlocStatus.loading));
      final response = await _getInvestmentContracts(
          InvestmentContractRequest(requestId: 4413209184));
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
}
