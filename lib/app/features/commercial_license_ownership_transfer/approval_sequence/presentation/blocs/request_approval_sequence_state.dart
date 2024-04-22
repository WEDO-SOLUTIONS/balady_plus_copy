part of 'request_approval_sequence_cubit.dart';

class RequestApprovalSequenceState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

// final class AttachmentState extends RequestApprovalSequenceState {
//   final BlocStatus status;
//   final BlocStatus attachmentStatus;
//   final BlocStatus credenceStatus;
//
//   final String? errorMessage;
//   final CrAttachmentResponse? attachmentResponse;
//   final List<AttachmentData>? attachments;
//   final String? notes;
//   final List<CredenceItem>? crdences;
//
//   AttachmentState(
//       {this.status = BlocStatus.initial,
//       this.attachmentStatus = BlocStatus.initial,
//       this.credenceStatus = BlocStatus.initial,
//       this.errorMessage,
//       this.attachmentResponse,
//       this.attachments,
//       this.notes,
//       this.crdences});
//
//   @override
//   List<Object?> get props {
//     return [
//       status,
//       attachmentStatus,
//       credenceStatus,
//       errorMessage,
//       attachmentResponse,
//       attachments,
//       notes,
//       crdences
//     ];
//   }
//
//   AttachmentState copyWith(
//       {BlocStatus? status,
//       String? errorMessage,
//       CrAttachmentResponse? attachmentResponse,
//       BlocStatus? attachmentStatus,
//       BlocStatus? credenceStatus,
//       List<AttachmentData>? attachments,
//       String? notes,
//       List<CredenceItem>? crdences}) {
//     return AttachmentState(
//         status: status ?? this.status,
//         attachmentStatus: attachmentStatus ?? this.attachmentStatus,
//         credenceStatus: credenceStatus ?? this.credenceStatus,
//         errorMessage: errorMessage ?? this.errorMessage,
//         attachments: attachments ?? this.attachments,
//         attachmentResponse: attachmentResponse ?? this.attachmentResponse,
//         notes: notes ?? this.notes,
//         crdences: crdences ?? this.crdences);
//   }
//
//   bool isFormValid() {
//     bool isValid = true;
//
//     attachments?.forEach((element) {
//       if (element.isUploaded == false && element.isRequired == true) {
//         isValid = false;
//       }
//     });
//     return isValid;
//   }
// }

final class InitialState implements RequestApprovalSequenceState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LoadingState extends RequestApprovalSequenceState {
  @override
  List<Object?> get props => [];
}

final class EmptyState extends RequestApprovalSequenceState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class FailureState extends RequestApprovalSequenceState {
  final String failureMessage;

  FailureState({required this.failureMessage});

  @override
  List<Object?> get props => [failureMessage];
}

final class GetPermitsSucceedState extends RequestApprovalSequenceState {
  final RequestPermitsModel permitsList;

  GetPermitsSucceedState({required this.permitsList});

  @override
  List<Object?> get props => [permitsList];
}

final class SucceedState extends RequestApprovalSequenceState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class DTOState extends RequestApprovalSequenceState {
  final CRContractOption? crContractOption;
  final CRContractType? crContractType;
  final CRSubmitterType? crSubmitterType;
  final ContractInfo? dto;
  final String? contractNumber;
  final String? contractDate;
  final DeedInfoRequest? deedInfoRequst;
  final List<String>? deedOptions;
  final bool? deedVerified;
  final EjarInfoRequest? ejarInfoRequst;
  final bool? ejarVerified;
  final InvestmentContractResponse? investmentContractResponse;
  final InvestmentContractItem? selectedInvestmentContract;
  final BlocStatus? deedOptionsStatus;
  final BlocStatus? investmentListStatus;
  final String? errorMessage;
  final BlocStatus? status;

  DTOState(
      {this.crContractOption,
      this.crContractType,
      this.crSubmitterType,
      this.dto,
      this.contractNumber,
      this.contractDate,
      this.deedInfoRequst,
      this.deedOptions,
      this.deedVerified,
      this.ejarInfoRequst,
      this.ejarVerified,
      this.investmentContractResponse,
      this.selectedInvestmentContract,
      this.deedOptionsStatus = BlocStatus.initial,
      this.investmentListStatus = BlocStatus.initial,
      this.status = BlocStatus.initial,
      this.errorMessage});

  DTOState copyWith(
      {CRContractOption? crContractOption,
      CRContractType? crContractType,
      CRSubmitterType? crSubmitterType,
      ContractInfo? dto,
      String? contractNumber,
      String? contractDate,
      DeedInfoRequest? deedInfoRequst,
      List<String>? deedOptions,
      bool? deedVerified,
      EjarInfoRequest? ejarInfoRequst,
      bool? ejarVerified,
      InvestmentContractResponse? investmentContractResponse,
      InvestmentContractItem? selectedInvestmentContract,
      BlocStatus? deedOptionsStatus,
      BlocStatus? investmentListStatus,
      String? errorMessage,
      BlocStatus? status}) {
    return DTOState(
      status: status,
      ejarVerified: ejarVerified == null ? this.ejarVerified : ejarVerified,
      deedVerified: deedVerified == null ? this.deedVerified : deedVerified,
      deedOptionsStatus: deedOptionsStatus,
      deedOptions: deedOptions ?? this.deedOptions,
      investmentContractResponse:
          investmentContractResponse ?? this.investmentContractResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      contractDate: contractDate == null ? this.contractDate : contractDate,
      contractNumber:
          contractNumber == null ? this.contractNumber : contractNumber,
      crSubmitterType:
          crSubmitterType == null ? this.crSubmitterType : crSubmitterType,
      dto: dto == null ? this.dto : dto,
      crContractType:
          crContractType == null ? this.crContractType : crContractType,
      crContractOption:
          crContractOption == null ? this.crContractOption : crContractOption,
      investmentListStatus: investmentListStatus,
      selectedInvestmentContract: selectedInvestmentContract == null
          ? this.selectedInvestmentContract
          : selectedInvestmentContract,
      ejarInfoRequst: ejarInfoRequst ?? this.ejarInfoRequst,
      deedInfoRequst: deedInfoRequst ?? this.deedInfoRequst,
    );
  }

  bool showAttachDeed() {
    if (dto?.contractOptionsResponseDto?.deedOptions?.contains("ATTACH") ??
        false) {
      return true;
    }

    return false;
  }

  bool showServicehDeed() {
    if (dto?.contractOptionsResponseDto?.deedOptions?.contains("SERVICE") ??
        false) {
      return true;
    }

    return false;
  }

  bool showAttachEjar() {
    if (dto?.contractOptionsResponseDto?.ejarOptions?.contains("ATTACH") ??
        false) {
      return true;
    }
    return false;
  }

  bool showAttachInvest() {
    if (dto?.contractOptionsResponseDto?.investOptions?.contains("ATTACH") ??
        false) {
      return true;
    }
    return false;
  }

  bool showServiceEjar() {
    if (dto?.contractOptionsResponseDto?.ejarOptions?.contains("SERVICE") ??
        false) {
      return true;
    }
    return false;
  }

  bool showServiceInvest() {
    if (dto?.contractOptionsResponseDto?.investOptions?.contains("SERVICE") ??
        false) {
      return true;
    }
    return false;
  }

  bool isFormValid() {
    if ((crContractOption == CRContractOption.service) &&
        (crContractType == CRContractType.ejar) &&
        ejarVerified == false) {
      return false;
    }
    return true;
  }

  @override
  List<Object?> get props {
    return [
      status,
      errorMessage,
      contractDate,
      contractNumber,
      crSubmitterType,
      crContractType,
      crContractOption,
      crSubmitterType,
      crContractType,
      crContractOption,
      investmentListStatus,
      investmentContractResponse,
      selectedInvestmentContract,
      deedOptionsStatus,
      deedOptions,
      ejarVerified,
      deedVerified,
      ejarInfoRequst,
      deedInfoRequst
    ];
  }
}
