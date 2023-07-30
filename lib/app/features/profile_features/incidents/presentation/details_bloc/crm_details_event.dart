part of 'crm_details_bloc.dart';

abstract class CrmDetailsEvent extends Equatable {
  const CrmDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetCRMRequestEvent extends CrmDetailsEvent {
  final String id;
  const GetCRMRequestEvent({required this.id});
}
