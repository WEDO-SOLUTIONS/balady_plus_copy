part of 'offers_bloc.dart';

class OffersState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final RequestOffersPageParams? params;
  final OffersResponse? offersResponse;
  final List<OfferItem>? items;
  final List<RequestRepliesModel>? requestReplies;
  final RequestRepliesModel? currentRequest;

  OffersState(
      {this.items,
      this.offersResponse,
      this.status = BlocStatus.initial,
      this.errorMessage,
      this.requestReplies,
      this.currentRequest,
      this.params});

  OffersState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      OffersResponse? offersResponse,
      List<OfferItem>? items,
      RequestOffersPageParams? params,
      List<RequestRepliesModel>? requestReplies,
      bool? clearResponse,
      RequestRepliesModel? currentRequest}) {
    return OffersState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        params: params ?? this.params,
        items: items ?? this.items,
        requestReplies: requestReplies ?? this.requestReplies,
        offersResponse: clearResponse == true
            ? null
            : offersResponse ?? this.offersResponse,
        currentRequest: currentRequest ?? this.currentRequest);
  }

  @override
  List<Object?> get props => [status, requestReplies, currentRequest];
}
