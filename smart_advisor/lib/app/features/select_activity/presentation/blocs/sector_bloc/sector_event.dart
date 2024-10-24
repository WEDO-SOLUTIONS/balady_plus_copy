part of 'sector_bloc.dart';

abstract class SectorEvent extends Equatable {
  const SectorEvent();

  @override
  List<Object?> get props => [];
}

class GetSectorEvent extends SectorEvent {
  const GetSectorEvent();
}
