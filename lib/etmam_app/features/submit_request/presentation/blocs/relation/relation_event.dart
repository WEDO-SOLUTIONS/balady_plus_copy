part of 'relation_bloc.dart';

abstract class RelationEvent extends Equatable {
  const RelationEvent();

  @override
  List<Object> get props => [];
}

class SelectRelationEvent extends RelationEvent {
  int index;
  SelectRelationEvent({required this.index});
}

class GetProvidersByService extends RelationEvent {
  int index;
  ServiceParams params;
  GetProvidersByService({required this.params, required this.index});
}

class DeleteRelationItem extends RelationEvent {
  String id;
  DeleteRelationItem({required this.id});
}
