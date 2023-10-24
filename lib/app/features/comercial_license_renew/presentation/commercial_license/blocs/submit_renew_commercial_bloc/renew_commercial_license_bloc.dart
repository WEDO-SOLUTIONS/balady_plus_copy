import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/services/services_exports.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/utils_exports.dart';
import '../../../../domain/use_cases/get_info_request.dart';
import '../../../../domain/use_cases/get_renew_years.dart';
import '../../../../renew_commercial_license_exports.dart';

part 'renew_commercial_license_event.dart';
part 'renew_commercial_license_state.dart';

class RenewCommercialLicenseBloc
    extends Bloc<RenewCommercialLicenseEvent, RenewCommercialLicenseState> {
  PageController controller = PageController();
  final CalculateRequestInfo _calculateRequestInfo;
  final GetRenewYears _getRenewYears;

  RenewCommercialLicenseBloc({required int requestId})
      : _getRenewYears = GetRenewYears(repository: sl()),
        _calculateRequestInfo = CalculateRequestInfo(repository: sl()),
        super(RenewCommercialLicenseState(requestId: requestId)) {
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<GetRenewYearsEvent>(_getRenewYearsHandler);
    on<GetRequestInfoEvent>(_getRequestInfoHandler);
    on<UpdateRenewYearsEvent>(_updateRenewYears);
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    //print("next page");
    print("DataLog ${state}");
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));

      await controller.animateToPage(nextPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: nextPage));
    }
    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentPageValue - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      await controller.animateToPage(prvoiusPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: prvoiusPage));
    }
    hideKeyboard();
  }

  Future<void> _getRenewYearsHandler(
      GetRenewYearsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _getRenewYears(state.requestId!);

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success, renewYears: r.data?.result));
    });
  }

  Future<void> _getRequestInfoHandler(
      GetRequestInfoEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.loading, licensePeriod: int.tryParse(e.year ?? "")));
    final failOrSuccess = await _calculateRequestInfo(RenewInfoRequest(
        licensePeriod: state.licensePeriod!, requestId: state.requestId!));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emitter(state.copyWith(status: BlocStatus.success, info: r));
    });
  }

  Future<void> _updateRenewYears(
      UpdateRenewYearsEvent e, Emitter emitter) async {
    emitter(state.copyWith(licensePeriod: int.tryParse(e.year)));
  }

  bool isLastPage() {
    return state.currentPageValue == (state.pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /*void updateSalama(
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
  }*/

  void updateCleanOptions(CRContractCleanRenewOptions type) {
    emit(state.copyWith(
      crContractCleanRenewOptions: Nullable(type),
    ));
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

    // getInvestmentContracts();
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
  /*
 void getCleanContracts() async {
    int requestId = state.requestId!;

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
      int requestId = state.requestId!;

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
  }*/
}
