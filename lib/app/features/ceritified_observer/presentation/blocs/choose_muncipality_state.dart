part of 'choose_muncipality_bloc.dart';


class ChooseMuncipalityState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final ObserverStatusEntity? observerStatusEntity;
  final List<LookUpItem>? lstMunicipalityLookUp;
  final RegisterObserverRequest? requestData;
  final bool? isAcceptNewObservers;
   final List? pagesList;
  int currentPageValue;

   ChooseMuncipalityState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.observerStatusEntity,
    this.lstMunicipalityLookUp,
    this.requestData,
    this.isAcceptNewObservers,
    this.pagesList,
    this.currentPageValue = 0
  });



  ChooseMuncipalityState copyWith({
    BlocStatus? status,
    String? errorMessage,
     ObserverStatusEntity? observerStatusEntity,
    List<LookUpItem>? lstMunicipalityLookUp,
    RegisterObserverRequest? requestData,
    bool? isAcceptNewObservers,
    List? pagesList,
    int? currentPageValue
  }) {
    return ChooseMuncipalityState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
        observerStatusEntity:observerStatusEntity??this.observerStatusEntity,
        lstMunicipalityLookUp:lstMunicipalityLookUp??this.lstMunicipalityLookUp,
        requestData:requestData??this.requestData,
        isAcceptNewObservers:isAcceptNewObservers??this.isAcceptNewObservers,
        pagesList:pagesList??this.pagesList,
        currentPageValue:currentPageValue??this.currentPageValue

    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    observerStatusEntity,
    lstMunicipalityLookUp,
    requestData,
    isAcceptNewObservers,
    pagesList,
    currentPageValue
  ];


  getMuncipalityById(String? id)
  {
    if(id != null&& lstMunicipalityLookUp != null && lstMunicipalityLookUp!.isNotEmpty)
      {
        for (int index = 0; index < lstMunicipalityLookUp!.length; index++) {
          if (lstMunicipalityLookUp![index].strId == id) {
            return lstMunicipalityLookUp![index];
          }
        }
      }
  }
}
