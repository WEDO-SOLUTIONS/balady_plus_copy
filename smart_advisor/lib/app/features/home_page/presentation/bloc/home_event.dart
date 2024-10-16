import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetEntityTypes extends HomeEvent {
  GetEntityTypes();
}

class HideHintChat extends HomeEvent {
  HideHintChat();
}

class GetSectorEvent extends HomeEvent {
  GetSectorEvent();
}
