part of 'ekram_requests_bloc.dart';

abstract class EkramRequestsEvent extends Equatable {
  const EkramRequestsEvent();

  @override
  List<Object> get props => [];
}

class GetDeceasedTransportRequestsEvent extends EkramRequestsEvent {
  final bool isDriver;
  final String? text;
  final int? requestStatusId;
  final int? transportLocationStatusId;
  final bool? isMultiCity;
  final bool? clear;
  GetDeceasedTransportRequestsEvent(
      {required this.isDriver,
      this.text,
      this.requestStatusId,
      this.transportLocationStatusId,
      this.isMultiCity,
      this.clear});
}

class GetDeceasedTransportRequestDetailsEvent extends EkramRequestsEvent {
  final int requestId;
  final bool isDriver;

  GetDeceasedTransportRequestDetailsEvent(
      {required this.requestId, required this.isDriver});
}

class GetMoreDeceasedTransportRequestsEvent extends EkramRequestsEvent {
  final bool isDriver;

  GetMoreDeceasedTransportRequestsEvent({required this.isDriver});
}

class ShowFilterEvent extends EkramRequestsEvent {
  ShowFilterEvent();
}

class GetCemetryRequestsEvent extends EkramRequestsEvent {
  GetCemetryRequestsEvent();
}

class GetMoreCemetryRequestsEvent extends EkramRequestsEvent {
  GetMoreCemetryRequestsEvent();
}

class GetCemetryRequestDetailsEvent extends EkramRequestsEvent {
  final String requestId;

  GetCemetryRequestDetailsEvent({required this.requestId});
}
