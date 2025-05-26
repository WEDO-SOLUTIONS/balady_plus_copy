part of 'identical_list_bloc.dart';

abstract class IdenticalListEvent extends Equatable {
  const IdenticalListEvent();

  @override
  List<Object> get props => [];
}



// class GetTripsDetailsEvent extends IdenticalListEvent {
//   final DeceasedInfoResponseDtoList dto;
//   final List<TransportAttachResponseDto>? letters;
//   final int requestId;
//   final int requestStatusId;
//   const GetTripsDetailsEvent(
//       {required this.dto,
//       required this.requestId,
//       required this.requestStatusId,
//       this.letters});
// }

class GetIdenticalListRequestEvent extends IdenticalListEvent {
 final int requestId;
  const GetIdenticalListRequestEvent({required this.requestId});
}

class GetTripsLocationEvent extends IdenticalListEvent {
  final int index;
  const GetTripsLocationEvent({required this.index});
}
