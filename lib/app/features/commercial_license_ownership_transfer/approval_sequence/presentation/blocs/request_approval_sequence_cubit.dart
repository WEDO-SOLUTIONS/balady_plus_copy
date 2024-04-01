import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/commercial_license/domain/use_cases/get_investment_contracts.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../commercial_license/data/models/commercial_request_details_response.dart';
import '../../../../commercial_license/domain/entities/deed_info_request.dart';
import '../../../../commercial_license/domain/entities/ejar_info_request.dart';
import '../../../../commercial_license/domain/entities/investment_contracts_request.dart';
import '../../../../commercial_license/domain/entities/investment_contracts_response.dart';
import '../../../../commercial_license/domain/use_cases/get_deed_info.dart';
import '../../../../commercial_license/domain/use_cases/get_deed_options.dart';
import '../../../../commercial_license/domain/use_cases/get_ejar_info.dart';
import '../../../request_details/data/models/commercial_licence_details.dart';
import '../../data/models/request_permits_model/request_permits_model.dart';
import '../../domain/repositories/repository.dart';

part 'request_approval_sequence_state.dart';

class RequestApprovalSequenceCubit extends Cubit<RequestApprovalSequenceState> {
  RequestApprovalSequenceRepository requestApprovalSequenceRepository;
  int? requestNumber;
  bool isChecked;
  final GetInvestmentContracts _getInvestmentContracts;
  final GetDeedInfo _getDeedInfo;
  final GetEjarInfo _getEjarInfo;
  final GetDeedOptions _getDeedOptions;
  var dto;


  //  TransferLicenseRequest request= TransferLicenseRequest();
  RequestApprovalSequenceCubit(
      {
        required this.requestApprovalSequenceRepository,
        required this.isChecked,




      })
      : _getInvestmentContracts = GetInvestmentContracts(repository: sl()),
        _getDeedInfo = GetDeedInfo(repository: sl()),
        _getEjarInfo = GetEjarInfo(repository: sl()),
        _getDeedOptions = GetDeedOptions(repository: sl()),
        super(RequestApprovalSequenceState()) {
    getRequestPermits;
  }

  Future<void> getRequestPermits(
    int requestNumber,
    /*TransferLicenseRequest request*/
  ) async {
    emit(LoadingState());
    final failureOrSuccess = await requestApprovalSequenceRepository
        .getRequestPermits(requestNumber);
    failureOrSuccess.fold(
      (failure) {
        if (failure is NoDataFoundException) {
          emit(EmptyState());
        } else if (failure is ServerFailure) {
          emit(FailureState(failureMessage: failure.errorMessage));
        } else {
          emit(FailureState(failureMessage: "error"));
        }
      },
      (requestPermitsModel) {
        emit(SucceedState(permitsList: requestPermitsModel!));
      },
    );
  }


  void InitForm() async {
    RequestOwnershipTransferDetailsCubit bloc = sl();
     dto= bloc.state.commercialLicenceDetails?.shopInfo?.contractInfoResponseDto;
    emit(DTOState());

  }
  //   void getDeedOwnerShipsTypes() async {
  //
  //
  //   //emit(CurrentState.copyWith());
  //
  //
  //   CRContractOption? crContractOption ;
  //   CRContractType? crContractType ;
  //   CRSubmitterType? crSubmitterType ;
  //
  //
  //   // if (dto?.shopInfo?.contractInfoResponseDto?.contractOption ==
  //   //     "ATTACH")
  //   //   crContractOption = CRContractOption.attach;
  //   //
  //   // if (requestData?.shopInfo?.contractInfoResponseDto?.contractOption ==
  //   //     "SERVICE")
  //   //   crContractOption = CRContractOption.service;
  //
  //   // if (dto?.contractOptionsResponseDto.deedOptions!=null)
  //   //    crContractType = CRContractType.deed;
  //   //
  //   // if (dto?.contractOptionsResponseDto.ejarOptions !=null)
  //   //   crContractType = CRContractType.ejar;
  //   //
  //   // if (dto?.contractOptionsResponseDto.investOptions !=null)
  //   //   crContractType = CRContractType.invest;
  //   //
  //   // if (crContractType == CRContractType.deed) {
  //   //   crSubmitterType = CRSubmitterType.owner;
  //   // }
  //   //
  //   // if (crContractType == CRContractType.ejar ||
  //   //     crContractType == CRContractType.invest) {
  //   //   crSubmitterType = CRSubmitterType.rental;
  //   // }
  //
  //
  //   emit(DTOState());
  //
  //
  //
  // }


  void getDeedOwnerShipsTypes() async {

    RequestOwnershipTransferDetailsCubit bloc = sl();
    var ST = state as DTOState;
    emit(ST.copyWith(deedOptionsStatus: BlocStatus.loading));
    final response = await _getDeedOptions(int.parse(bloc.requestID!));
    response.fold(
            (failure) =>
                emit(ST.copyWith(
          deedOptionsStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        )), (success) {
      emit(ST.copyWith(
          deedOptionsStatus: BlocStatus.success, deedOptions: success));
    });
  }

  void updateSubmitterType(CRSubmitterType type) {
    var CurrentState =state as DTOState;
    //CurrentState.dto ??= dto;
    emit(CurrentState.copyWith(crSubmitterType: type,dto: dto,status: null,investmentListStatus: null,deedOptionsStatus: null));
  }



  void updateCRContractType(CRContractType type) {

    var CurrentState =state as DTOState;
    //CurrentState.dto ??= dto;
    emit(CurrentState.copyWith(
      crContractType: type,dto: dto,status: null,investmentListStatus: null,deedOptionsStatus: null

    ));
  }
  void updateCRContractOption(CRContractOption type) {
    var CurrentState =state as DTOState;
    emit(CurrentState.copyWith(crContractOption: type,status: null,investmentListStatus: null,deedOptionsStatus: null));

    getInvestmentContracts();
  }

  void updateContractNumber(String value) {
    var CurrentState =state as DTOState;
    emit(CurrentState.copyWith(contractNumber: value,status: null,investmentListStatus: null,deedOptionsStatus: null));
  }

  void updateContractDate(String value) {
    var CurrentState =state as DTOState;
    emit(CurrentState.copyWith(contractDate: value,status: null,investmentListStatus: null,deedOptionsStatus: null));
  }





  void getInvestmentContracts() async {
    if(state is DTOState) {

      var ST = state as DTOState;
      if (ST.crContractType == CRContractType.invest &&
          ST.crSubmitterType == CRSubmitterType.rental &&
          ST.crContractOption == CRContractOption.service) {

        RequestOwnershipTransferDetailsCubit bloc = sl();
        int requestId = int.parse(bloc.requestID!);
        var CurrentState =state as DTOState;
        emit(CurrentState.copyWith(investmentListStatus: BlocStatus.loading));
        final response = await _getInvestmentContracts(
            InvestmentContractRequest(requestId: requestId));
        response.fold(
                (failure) =>
                emit(CurrentState.copyWith(
                  investmentListStatus: BlocStatus.failure,
                  errorMessage: (failure as ServerFailure).errorMessage,
                )), (success) {
          emit(CurrentState.copyWith(
              investmentListStatus: BlocStatus.success,
              investmentContractResponse: success));
        });
      }
    }
  }




  void updateDeedInfo({String? ownershipType, String? deedNumber}) {
    var CurrentState =state as DTOState;
    CurrentState.copyWith(status: BlocStatus.loading, errorMessage: "");

    var ST = state as DTOState;
    DeedInfoRequest deedInfoRequst =
        ST.deedInfoRequst ?? DeedInfoRequest(requestId: requestNumber!);

    deedInfoRequst = deedInfoRequst.copyWith(
      ownershipType: ownershipType,
      deedNumber: deedNumber,
    );

    emit(CurrentState.copyWith(
        status: BlocStatus.success,
        deedInfoRequst: deedInfoRequst,
        deedVerified: false,
        errorMessage: ""));
  }


  Future<void> getDeedInfoHandler() async {

    var CurrentState =state as DTOState;
    emit(CurrentState.copyWith(status: BlocStatus.loading, errorMessage: ""));
    var ST = state as DTOState;
    final failOrSuccess = await _getDeedInfo(ST.deedInfoRequst ??
        DeedInfoRequest(
          requestId: requestNumber!,
        ));
    failOrSuccess.fold((l) {
      emit(CurrentState.copyWith(
          status: BlocStatus.failure,
          deedVerified: false,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emit(CurrentState.copyWith(
          status: BlocStatus.success, deedVerified: true));
    });
  }

  void updateTenancyInfo(
      {String? id, String? tenancyContractNumber, String? versionNumber}) {
    var CurrentState =state as DTOState;
    CurrentState.copyWith(status: BlocStatus.loading, errorMessage: "");

    var ST = state as DTOState;
    EjarInfoRequest ejarInfoRequst = ST.ejarInfoRequst ?? EjarInfoRequest();

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

    emit(CurrentState.copyWith(
        status: BlocStatus.success,
        ejarInfoRequst: ejarInfoRequst,
        ejarVerified: false,
        errorMessage: ""));
  }



  Future<void> getEjarInfoHandler() async {
    var CurrentState =state as DTOState;
    emit(CurrentState.copyWith(status: BlocStatus.loading, errorMessage: ""));
    var ST = state as DTOState;
    final failOrSuccess =
    await _getEjarInfo(ST.ejarInfoRequst ?? EjarInfoRequest());

    failOrSuccess.fold((l) {
      emit(CurrentState.copyWith(
          status: BlocStatus.failure,
          ejarVerified: false,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) {

      emit(CurrentState.copyWith(
          status: BlocStatus.success, ejarVerified: true));
    });
  }

  void selectInvestmentContract(InvestmentContractItem? item) {
    var CurrentState =state as DTOState;
    emit(CurrentState.copyWith(
      errorMessage: "",
      selectedInvestmentContract: item,
    ));
  }

}
