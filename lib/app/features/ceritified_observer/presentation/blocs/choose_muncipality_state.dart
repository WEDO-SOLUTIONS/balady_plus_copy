part of 'choose_muncipality_bloc.dart';

abstract class CertifiedObserverState extends Equatable {
  const CertifiedObserverState();

  CertifiedObserverState copyWith();

  @override
  List<Object?> get props => [];
}

class ChooseMuncipalityState extends CertifiedObserverState {
  final BlocStatus status;
  final String? errorMessage;
  final ObserverStatusEntity? observerStatusEntity;
  final List<LookUpItem>? lstMunicipalityLookUp;
  final List<LookUpItem>? lstCitesLookUp;
  final List<LookUpItem>? lstDistrictLookUp;
  final List<LookUpItem>? lstDegrees;
  final List<LookUpItem>? lstMaritalStatus;
  final List<LookUpItem>? lstBanks;
  final RegisterObserverRequest? requestData;
  final bool? isAcceptNewObservers;
  final List? pagesList;
  int currentPageValue;

  TextEditingController bankIbanController;
  TextEditingController phoneController;
  TextEditingController emailController;

  ChooseMuncipalityState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    required this.bankIbanController,
    required this.emailController,
    required this.phoneController,
    this.observerStatusEntity,
    this.lstMunicipalityLookUp,
    this.requestData,
    this.isAcceptNewObservers,
    this.pagesList,
    this.currentPageValue = 0,
    this.lstDegrees,
    this.lstMaritalStatus,
    this.lstBanks,
    this.lstCitesLookUp,
    this.lstDistrictLookUp,
  });

  @override
  CertifiedObserverState copyWith({
    BlocStatus? status,
    String? errorMessage,
    ObserverStatusEntity? observerStatusEntity,
    List<LookUpItem>? lstMunicipalityLookUp,
    RegisterObserverRequest? requestData,
    bool? isAcceptNewObservers,
    List? pagesList,
    int? currentPageValue,
    List<LookUpItem>? lstBanks,
    List<LookUpItem>? lstMaritalStatus,
    List<LookUpItem>? lstDegrees,
    List<LookUpItem>? lstCitesLookUp,
    List<LookUpItem>? lstDistrictLookUp,
  }) {
    return ChooseMuncipalityState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      observerStatusEntity: observerStatusEntity ?? this.observerStatusEntity,
      lstMunicipalityLookUp:
          lstMunicipalityLookUp ?? this.lstMunicipalityLookUp,
      requestData: requestData ?? this.requestData,
      isAcceptNewObservers: isAcceptNewObservers ?? this.isAcceptNewObservers,
      pagesList: pagesList ?? this.pagesList,
      currentPageValue: currentPageValue ?? this.currentPageValue,
      lstDegrees: lstDegrees ?? this.lstDegrees,
      lstMaritalStatus: lstMaritalStatus ?? this.lstMaritalStatus,
      lstBanks: lstBanks ?? this.lstBanks,
      lstCitesLookUp: lstCitesLookUp ?? this.lstCitesLookUp,
      lstDistrictLookUp: lstDistrictLookUp ?? this.lstDistrictLookUp,
      bankIbanController: bankIbanController,
      emailController: emailController,
      phoneController: phoneController,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        observerStatusEntity,
        lstMunicipalityLookUp,
        //// Location Info
        requestData?.municipality,
        requestData?.city,
        requestData?.district,
        //// Personal Info
        requestData?.email,
        requestData?.mobileNumber,
        requestData?.maritalStatus,
        requestData?.academicQualification,
        //// Bank Info
        requestData?.bankInfo,
        requestData?.iban,
        //// User Data applicant
        //// Additional Info
        requestData?.surveyQuestion1,
        requestData?.surveyQuestion2,
        requestData?.surveyQuestion3,
        requestData?.surveyQuestion4,
        ////////////////////
        requestData?.pledgeQuestion,
        ////////////////////
        isAcceptNewObservers,
        pagesList,
        currentPageValue,
        lstBanks,
        lstDegrees,
        lstMaritalStatus,
        lstDistrictLookUp,
        lstCitesLookUp
      ];

  getMuncipalityById(String? id) {
    if (id != null &&
        lstMunicipalityLookUp != null &&
        lstMunicipalityLookUp!.isNotEmpty) {
      for (int index = 0; index < lstMunicipalityLookUp!.length; index++) {
        if (lstMunicipalityLookUp![index].strId == id) {
          return lstMunicipalityLookUp![index];
        }
      }
    }
  }

  getCityById(String? id) {
    if (id != null && lstCitesLookUp != null && lstCitesLookUp!.isNotEmpty) {
      for (int index = 0; index < lstCitesLookUp!.length; index++) {
        if (lstCitesLookUp![index].strId == id) {
          return lstCitesLookUp![index];
        }
      }
    }
  }

  getDegreeByName(String? name) {
    if (name != null && lstDegrees != null && lstDegrees!.isNotEmpty) {
      for (int index = 0; index < lstDegrees!.length; index++) {
        if (lstDegrees![index].name == name) {
          return lstDegrees![index];
        }
      }
    }
  }

  getMaritalStatusByName(String? name) {
    if (name != null &&
        lstMaritalStatus != null &&
        lstMaritalStatus!.isNotEmpty) {
      for (int index = 0; index < lstMaritalStatus!.length; index++) {
        if (lstMaritalStatus![index].name == name) {
          return lstMaritalStatus![index];
        }
      }
    }
  }
}

class LoadingApprovalState extends CertifiedObserverState {
  const LoadingApprovalState();

  @override
  CertifiedObserverState copyWith() {
    return const LoadingApprovalState();
  }
}

class FailureApprovalState extends CertifiedObserverState {
  final String failure;

  const FailureApprovalState({required this.failure});

  @override
  CertifiedObserverState copyWith({String? failure}) {
    return FailureApprovalState(
      failure: failure ?? this.failure,
    );
  }
}

class WaitingApprovalState extends CertifiedObserverState {
  final ObserverStatusEntity? observerStatusEntity;

  const WaitingApprovalState({this.observerStatusEntity});

  @override
  CertifiedObserverState copyWith({
    ObserverStatusEntity? observerStatusEntity,
  }) {
    return WaitingApprovalState(
      observerStatusEntity: observerStatusEntity ?? this.observerStatusEntity,
    );
  }
}
class NoHaveFreelanceCertificateState extends CertifiedObserverState {

  const NoHaveFreelanceCertificateState();

  @override
  NoHaveFreelanceCertificateState copyWith() {
    return const NoHaveFreelanceCertificateState();
  }
}
