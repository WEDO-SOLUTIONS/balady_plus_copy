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
import '../../../domain/use_cases/get_clean_contracts.dart';
import '../../../domain/use_cases/get_investment_contracts.dart';
import '../../step3/bloc/map_bloc.dart';

part 'cr_step4_shop_data_state.dart';

class CrStep4ShopDataCubit extends Cubit<CrStep4ShopDataState> {
  final GetAccommodationTypes _getAccommodationTypes;
  final GetCleanContracts _getCleanContracts;
  final GetInvestmentContracts _getInvestmentContracts;
  CrStep4ShopDataCubit()
      : _getAccommodationTypes = GetAccommodationTypes(repository: sl()),
        _getCleanContracts = GetCleanContracts(repository: sl()),
        _getInvestmentContracts = GetInvestmentContracts(repository: sl()),
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
    List<CommercialBoardType> selectedBoards = state.selectedBoards ?? [];
    selectedBoards.add(board);
    emit(state.copyWith(selectedBoards: selectedBoards));
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
    ));
  }

  void updateCRContractType(CRContractType type) {
    emit(state.copyWith(
      crContractType: Nullable(type),
    ));
  }

  void updateCRContractOption(CRContractOption type) {
    emit(state.copyWith(
      crContractOption: Nullable(type),
    ));
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
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(investmentListStatus: BlocStatus.loading));
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

  void initForm() {
    var context = NavigationService.navigatorKey.currentContext;

    SaveLocationResponse? res = context?.read<MapBloc>().state.locationResponse;
    print("DDDDFGGFDF ${res?.maxYears}");
    print(res?.maxYears);
  }
}
