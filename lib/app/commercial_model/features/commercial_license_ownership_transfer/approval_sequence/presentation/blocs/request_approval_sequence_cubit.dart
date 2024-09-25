import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';

import '../../../../commercial_license/domain/entities/deed_info_request.dart';
import '../../../../commercial_license/domain/entities/ejar_info_request.dart';
import '../../../../commercial_license/domain/entities/investment_contracts_request.dart';
import '../../../../commercial_license/domain/entities/investment_contracts_response.dart';
import '../../../../commercial_license/domain/entities/save_shop_details_request.dart';
import '../../../../commercial_license/domain/use_cases/get_deed_info.dart';
import '../../../../commercial_license/domain/use_cases/get_deed_options.dart';
import '../../../../commercial_license/domain/use_cases/get_ejar_info.dart';
import '../../../../commercial_license/domain/use_cases/get_investment_contracts.dart';
import '../../../old_owner_transfer/persentation/interface/step_interface.dart';

import '../../data/models/request_permits_model/request_permits_model.dart';
import '../../domain/entities/save_selected_requests_permits_request.dart';
import '../../domain/entities/save_shop_info_request.dart';
import '../../domain/repositories/repository.dart';

part 'request_approval_sequence_state.dart';

class RequestApprovalSequenceCubit extends Cubit<RequestApprovalSequenceState> {
  RequestApprovalSequenceRepository requestApprovalSequenceRepository;
  int? requestNumber;
  bool isChecked;
  SaveSelectedRequestsPermitsRequest saveSelectedRequestsPermitsRequest =
      SaveSelectedRequestsPermitsRequest();

  final GetInvestmentContracts _getInvestmentContracts;
  final GetDeedInfo _getDeedInfo;
  final GetEjarInfo _getEjarInfo;
  final GetDeedOptions _getDeedOptions;
  var dto;
  RequestOwnershipTransferDetailsCubit? requestDetailsBloc;

  //  TransferLicenseRequest request= TransferLicenseRequest();
  RequestApprovalSequenceCubit(
      {required this.requestApprovalSequenceRepository,
      required this.isChecked})
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
        emit(GetPermitsSucceedState(permitsList: requestPermitsModel));
      },
    );
  }

  Future<void> saveSelectedRequestPermits(
      int requestNumber,
      SaveSelectedRequestsPermitsRequest saveSelectedRequestsPermitsRequest,
      StepInterface stepInterface) async {
    emit(LoadingState());
    final failureOrSuccess =
        await requestApprovalSequenceRepository.saveSelectedRequestPermits(
            requestNumber, saveSelectedRequestsPermitsRequest);
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
      (success) {
        emit(SucceedState());
        stepInterface.nextPage();
      },
    );
  }

  Future<void> saveShopInfo(int requestNumber, SaveShopInfoRequest params,
      StepInterface stepInterface) async {
    emit(LoadingState());
    final failureOrSuccess = await requestApprovalSequenceRepository
        .saveShopInfo(requestNumber, params);
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
      (success) {
        stepInterface.nextPage();
        //  emit(SucceedState());
      },
    );
  }

  void InitForm() async {
    dto = requestDetailsBloc
        ?.state.commercialLicenceDetails?.shopInfo?.contractInfoResponseDto;
    emit(DTOState());
  }

  void getInvestmentContracts() async {
    if (state is DTOState) {
      var ST = state as DTOState;
      if (ST.crContractType == CRContractType.invest &&
          ST.crSubmitterType == CRSubmitterType.rental &&
          ST.crContractOption == CRContractOption.service) {
      //  RequestOwnershipTransferDetailsCubit bloc = sl();
        int requestId = int.parse(requestDetailsBloc!.requestID!);
        var CurrentState = state as DTOState;
        emit(CurrentState.copyWith(investmentListStatus: BlocStatus.loading));
        final response = await _getInvestmentContracts(
            InvestmentContractRequest(requestId: requestId));
        response.fold(
            (failure) => emit(CurrentState.copyWith(
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

  void getDeedOwnerShipsTypes() async {
   // RequestOwnershipTransferDetailsCubit bloc = sl();
    var ST = state as DTOState;
    emit(ST.copyWith(deedOptionsStatus: BlocStatus.loading));
    final response = await _getDeedOptions(int.parse(requestDetailsBloc!.requestID!));
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
    var CurrentState = state as DTOState;
    //CurrentState.dto ??= dto;
    emit(CurrentState.copyWith(
        crSubmitterType: type,
        dto: dto,
        status: null,
        investmentListStatus: null,
        deedOptionsStatus: null));
  }

  void updateCRContractType(CRContractType type) {
    var CurrentState = state as DTOState;
    emit(CurrentState.copyWith(
        crContractType: type,
        dto: dto,
        status: null,
        investmentListStatus: null,
        deedOptionsStatus: null));
  }

  void updateCRContractOption(CRContractOption type) {
    var CurrentState = state as DTOState;
    emit(CurrentState.copyWith(
        crContractOption: type,
        status: null,
        investmentListStatus: null,
        deedOptionsStatus: null));
    getInvestmentContracts();
  }

  void updateContractNumber(String value) {
    var CurrentState = state as DTOState;
    emit(CurrentState.copyWith(
        contractNumber: value,
        status: null,
        investmentListStatus: null,
        deedOptionsStatus: null));
  }

  void updateContractDate(String value) {
    var CurrentState = state as DTOState;
    emit(CurrentState.copyWith(
        contractDate: value,
        status: null,
        investmentListStatus: null,
        deedOptionsStatus: null));
  }

  void updateDeedInfo({String? ownershipType, String? deedNumber}) {
    var CurrentState = state as DTOState;
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
    var CurrentState = state as DTOState;
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
    var CurrentState = state as DTOState;
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
    var CurrentState = state as DTOState;
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
    var CurrentState = state as DTOState;
    emit(CurrentState.copyWith(
      errorMessage: "",
      selectedInvestmentContract: item,
    ));
  }

  void saveData(StepInterface stepInterface) async {
    var CurrentState = state as DTOState;
    emit(CurrentState.copyWith(status: BlocStatus.loading, errorMessage: ""));

    SaveShopDetailsRequest request = SaveShopDetailsRequest(
      requestId: requestNumber,
      contractDate:
          CommonFunctions.padHijriDate(CurrentState.contractDate ?? ""),
      contractNumber: CurrentState.contractNumber,
      contractType: CurrentState.crContractType?.name,
      contractOption: CurrentState.crContractOption?.name,
      investmentContractNumber:
          CurrentState.selectedInvestmentContract?.siteContractId,
      ejarContractInfo: CurrentState.ejarVerified == true
          ? CurrentState.ejarInfoRequst
          : null,
      deedInfo: CurrentState.deedVerified == true
          ? CurrentState.deedInfoRequst
          : null,
    );
    RequestApprovalSequenceRepository dateSource = sl();
    final failOrSuccess = await dateSource.saveShopDetails(request);

    failOrSuccess.fold(
        (failure) => emit(CurrentState.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(CurrentState.copyWith(status: BlocStatus.success));

      stepInterface.nextPage();
    });
  }

  // void getAttachments() async {
  //   //4517311700
  //
  //   emit((state as AttachmentState)
  //       .copyWith(attachmentStatus: BlocStatus.loading));
  //   final response =
  //       await requestApprovalSequenceRepository.requestAttachments(requestNumber!);
  //   response.fold(
  //       (failure) =>
  //           emit((state as AttachmentState).copyWith(
  //             attachmentStatus: BlocStatus.failure,
  //             errorMessage: (failure as ServerFailure).errorMessage,
  //           )), (success) {
  //     List<AttachmentData> attachmentData = (success ?? [])
  //         .map((e) => AttachmentData(
  //             id: e.id.toString(),
  //             memo: e.name ?? "",
  //             title: "${e.name} ${e.allowedFilesExtension}",
  //             isRequired: e.isMandatory ?? false,
  //             filePath: e.attachUrl,
  //             fileName: e.originFileName,
  //             isUploaded: e.attached ?? false))
  //         .toList();
  //
  //     emit((state as AttachmentState).copyWith(
  //         attachmentStatus: BlocStatus.success, attachments: attachmentData));
  //   });
  // }
  //
  // deleteFile(int index) async {
  //   emit((state as AttachmentState).copyWith(status: BlocStatus.loading));
  //
  //   List<AttachmentData> attachments = (state as AttachmentState).attachments ?? [];
  //   attachments[index].base64 = null;
  //   attachments[index].fileName = null;
  //   attachments[index].filePath = null;
  //   attachments[index].isUploaded = false;
  //   emit((state as AttachmentState).copyWith(status: BlocStatus.success, attachments: attachments));
  // }
  //
  // void updateNotes(String? notes) {
  //   emit((state as AttachmentState).copyWith(
  //     notes: notes,
  //     errorMessage: "",
  //   ));
  // }
  //
  // saveFile(
  //     {required int index,
  //       required String filePath,
  //       required String fileName,
  //       required String fileBase64}) async {
  //
  //
  //   emit((state as AttachmentState).copyWith(
  //     status: BlocStatus.loading,
  //     errorMessage: "",
  //   ));
  //
  //   final failOrSuccess = await requestApprovalSequenceRepository.saveAttachment(CrAttachmentRequest(
  //       requestId: requestNumber,
  //       data: (state as AttachmentState).attachments![index].copyWith(
  //           fileName: fileName, filePath: filePath, base64: fileBase64)));
  //
  //   failOrSuccess.fold((l) {
  //     emit((state as AttachmentState).copyWith(
  //       errorMessage: (l as ServerFailure).errorMessage,
  //       status: BlocStatus.failure,
  //     ));
  //   }, (r) {
  //     List<AttachmentData> attachments = (state as AttachmentState).attachments ?? [];
  //     attachments[index].base64 = fileBase64;
  //     attachments[index].fileName = fileName;
  //     attachments[index].filePath = filePath;
  //     attachments[index].isUploaded = true;
  //     emit(
  //         (state as AttachmentState).copyWith(status: BlocStatus.success, attachments: attachments));
  //   });
  // }
  //
  //
  // deleteCredence(int index) async {
  //   emit((state as AttachmentState).copyWith(
  //     status: BlocStatus.loading,
  //     errorMessage: "",
  //   ));
  //
  //   List<CredenceItem> attachments = (state as AttachmentState).crdences ?? [];
  //   attachments[index].attachmentUrl = null;
  //
  //   emit((state as AttachmentState).copyWith(status: BlocStatus.success, crdences: attachments));
  // }
  //
  //
  //
  // void uploadCrednece(FileDataItem item, int index) async {
  //
  //
  //   emit((state as AttachmentState).copyWith(
  //     status: BlocStatus.loading,
  //     errorMessage: "",
  //   ));
  //
  //   final failOrSuccess = await requestApprovalSequenceRepository.uploadCredence(CrAttachmentRequest(
  //       requestId: requestNumber,
  //       data: AttachmentData(
  //           id: (state as AttachmentState).crdences![index].credenceId!.toString(),
  //           fileName: item.fileName,
  //           filePath: item.filePath,
  //           base64: item.fileBase64,
  //           memo: item.fileName,
  //           title: item.fileName,
  //           isRequired: true,
  //           isUploaded: false)));
  //
  //   failOrSuccess.fold((l) {
  //     emit((state as AttachmentState).copyWith(
  //       errorMessage: (l as ServerFailure).errorMessage,
  //       status: BlocStatus.failure,
  //     ));
  //   }, (r) {
  //     List<CredenceItem> attachments = (state as AttachmentState).crdences ?? [];
  //     attachments[index].attachmentUrl = item.filePath;
  //
  //     emit((state as AttachmentState).copyWith(status: BlocStatus.success, crdences: attachments));
  //   });
  // }

  Future<int> submitApprove() async {
    int requestId = 0;

    emit((state as DTOState).copyWith(status: BlocStatus.loading));
    final response = await requestApprovalSequenceRepository.submitApprovel(
      requestNumber!,
    );
    response.fold((failure) {
      requestId = -1;
      emit((state as DTOState).copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      requestId = requestNumber!;
      emit((state as DTOState).copyWith(status: BlocStatus.success));
    });

    return requestId;
  }
}
