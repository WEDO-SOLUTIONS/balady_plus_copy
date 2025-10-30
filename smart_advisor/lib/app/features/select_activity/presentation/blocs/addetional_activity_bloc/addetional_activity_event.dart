part of 'addetional_activity_bloc.dart';

abstract class AddetionalActivityEvent extends Equatable {
  const AddetionalActivityEvent();

  @override
  List<Object?> get props => [];
}

class GetAddetionalActivites extends AddetionalActivityEvent {
  const GetAddetionalActivites();
}

class ToggleAddetionalActivity extends AddetionalActivityEvent {
  final int index;
  const ToggleAddetionalActivity({required this.index});
}
