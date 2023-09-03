import 'package:equatable/equatable.dart';

class SelfRatingEvent extends Equatable {
  const SelfRatingEvent();

  @override
  List<Object> get props => [];
}

class SelfRatingChangePageEvent extends SelfRatingEvent {
  final double index;
  const SelfRatingChangePageEvent(this.index);
}

class SelfRatingRadioSelectEvent extends SelfRatingEvent {
  final int index;
  final bool compliance;
  SelfRatingRadioSelectEvent({required this.index, required this.compliance});
}

class InitSelfRatingEvent extends SelfRatingEvent {
  const InitSelfRatingEvent();
}
