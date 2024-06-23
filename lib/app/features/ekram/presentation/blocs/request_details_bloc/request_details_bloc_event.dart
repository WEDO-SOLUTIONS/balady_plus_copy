part of 'request_details_bloc_bloc.dart';

abstract class RequestDetailsEvent extends Equatable {
  const RequestDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetTripsEvent extends RequestDetailsEvent {
  final int index;
  const GetTripsEvent({required this.index});
}

class GetTripsDetailsEvent extends RequestDetailsEvent {
  final DeceasedInfoResponseDtoList dto;
  final List<TransportAttachResponseDto>? letters;
  final int requestId;
  final int requestStatusId;
  const GetTripsDetailsEvent(
      {required this.dto,
      required this.requestId,
      required this.requestStatusId,
      this.letters});
}

class GetDriverRequestDetails extends RequestDetailsEvent {
  const GetDriverRequestDetails();
}

class GetTripsLocationEvent extends RequestDetailsEvent {
  final int index;
  const GetTripsLocationEvent({required this.index});
}
