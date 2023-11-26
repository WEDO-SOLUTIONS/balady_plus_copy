part of 'trip_details_bloc_bloc.dart';

abstract class TripDetailsEvent extends Equatable {
  const TripDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetTripsDetailsInDialogEvent extends TripDetailsEvent {
  const GetTripsDetailsInDialogEvent();
}

class CompleteTripEvent extends TripDetailsEvent {
  const CompleteTripEvent();
}

class UploadLetterEvent extends TripDetailsEvent {
  final FileDataItem? file;
  final int? requestId;
  const UploadLetterEvent({this.file, this.requestId});
}

class UploadHdSharieEvent extends TripDetailsEvent {
  final FileDataItem? file;
  final int? requestId;
  const UploadHdSharieEvent({this.file, this.requestId});
}

class DeleteTripEvent extends TripDetailsEvent {
  final int id;
  const DeleteTripEvent({required this.id});
}

class DownLoadAttachmentEvent extends TripDetailsEvent {
  final int id;
  const DownLoadAttachmentEvent({required this.id});
}

class GetDriverRequestDetails extends TripDetailsEvent {
  const GetDriverRequestDetails();
}
